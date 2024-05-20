---@diagnostic disable: invalid-class-name

--// Types
local types = require(script.Parent:WaitForChild("Types"))

--// Child Modules
local mkMethod = require(script.Parent:WaitForChild("mkMethod"))
local mkEvent = require(script.Parent:WaitForChild("mkEvent"))

local lib = script.Parent:WaitForChild("lib")

local LemonSignal = require(lib:WaitForChild("LemonSignal"))

local assert = require(lib:WaitForChild("customAssert"))
--local pipe = require(lib:WaitForChild("pipe"))

--// Variables
local voidFunction = function()end
local void = (function()end)()
local doingNothing = function(...)return...end

local magicMethods = {
	__init = true;
	__getter = true;
	__setter = true;
	__call = true;
	__concat = true;
	__unm = true;
	__add = true;
	__sub = true;
	__mul = true;
	__div = true;
	__idiv = true;
	__mod = true;
	__pow = true;
	__str = true; --// __tostring
	__tostring = true;
	--__metatable = true;
	__eq = true;
	__lt = true;
	__le = true;
	--__mode = true;
	--__gc = true;
	__len = true;
	__iter = true;
}

local getableClassKeyList = {
	className = true;
	magicMethods = true;
	methods = true;
	events = true;
	
	objectCreated = true;
	
	new = true;
	is = true;
}

--local setableClassKeyList = {}

local __types = {}
local realSelfs = {}

--// Functions
local weaktable = nil
local __type = nil
local getRealSelf = nil
local __call = nil
local interpret = nil
local buildClass = nil
local buildObject = nil

function weaktable(weaktable)
	weaktable.__mode = weaktable.__mode or "kv"
	
	return setmetatable({}, weaktable)
end

function __type(object, className)
	if typeof(object) == "table" or typeof(object) == "userdata" then
		local __type = __types[object] or getmetatable(object).__type

		return __type == className
	else
		return false
	end
end

function getRealSelf(object)
	assert(realSelfs[object], `{ object } is not self2(object)`)
	return realSelfs[object]
end

function __call(self, classNameORclassConfig: string | types.classConfig)
	if type(classNameORclassConfig) == "string" then
		return function(classConfig: types.classConfig)
			return interpret(classNameORclassConfig, classConfig)
		end :: types.Class
	elseif type(classNameORclassConfig) == "table" then
		return interpret(nil, classNameORclassConfig)
	end
end

function interpret(className: string, classConfig: types.classConfig)
	local returnMagicMethods = {}
	local returnMethods = {}
	local returnEvents = {}

	for _, config in classConfig do
		if getmetatable(config) == "method" then
			local methodName = config[1]
			local runner = config[2]
			local returnValueType = string.gsub(config[3], "^%->%s*", "")

			if magicMethods[methodName] then
				returnMagicMethods[methodName] = { runner, returnValueType }
			else
				returnMethods[methodName] = { runner, returnValueType }
			end
		elseif getmetatable(config) == "event" then
			local eventName = config[1]
			table.insert(returnEvents, eventName)
		end
	end

	return buildClass(className, returnMagicMethods, returnMethods, returnEvents) :: types.Class
end

function buildClass(className, magicMethods, methods, events)
	local class = newproxy(true)
	
	--// TODO: RBLX BindableEvent 대신 시그널 모듈로 변경하기(내가 만든 signal.lua도 그걸로 바꿀거임)
	
	local objectCreated = LemonSignal.new()
	
	local function new(...: any)
		local newObject = buildObject(class, ...)
		
		objectCreated:Fire(newObject)
		
		return newObject
	end
	
	local function is(object)
		if typeof(object) == "table" or typeof(object) == "userdata" then
			local __type = __types[object] or getmetatable(object).__type

			return __type == className
		else
			return false
		end
	end
	
	local metatable = getmetatable(class)
	metatable.__variables = {
		className = className or "[Unknown]";
		magicMethods = magicMethods;
		methods = methods;
		events = events;
		
		objectCreated = objectCreated;
		
		new = new;
		is = is;
	}
	
	function metatable.__call(self, ...)
		--// TODO: Create an Inheritance Feature
		
		return new(...)
	end
	
	function metatable.__index(self, key)
		assert(getableClassKeyList[key], `{ key } is not a valid member of Class "{ className or "[Unknown]" }"`)
		return metatable.__variables[key]
	end
	
	function metatable.__newindex(self, key, value)
		error(`<Class: { className or "[Unknown]" }>.{ key } is readonly`)
	end
	
	function metatable.tostring(self)
		return `<Object: { className or "[Unknown]" }>`
	end
	
	return class :: types.Class
end

function buildObject(class, ...)
	local object = newproxy(true)
	local metatable = getmetatable(object)
	
	--local object = {}
	
	local className = class.className
	local magicMethods = class.magicMethods
	local methods = class.methods
	local events = class.events
	
	local self2 = weaktable {}
	local internals = weaktable {}
	
	__types[self2] = className
	realSelfs[self2] = object
	
	metatable.__type = className
	metatable.__signals = weaktable {}
	metatable.__internals = internals
	metatable.__properties = self2
	
	--local metatable = {
	--	__type = className;
	--	__signals = weaktable {};
	--	__internals = internals;
	--	__properties = self2;
	--}
	
	local getableKeyList = {}
	local setableKeyList = {}

	local function classMagicMethod__getter(self, key)
		assert(getableKeyList[key], `{ key } is not a valid member of { className or "[Unknown]" }.`)
		if magicMethods.__getter then
			return magicMethods.__getter[1](self2, internals, key)
		else
			return self2[key]
		end
	end
	
	local function classMagicMethod__setter(self, key, value)
		assert(setableKeyList[key], `{ className or "[Unknown]" }.{ key } is readonly`)
		
		if magicMethods.__setter then
			return magicMethods.__setter[1](self2, internals, key, value)
		else
			self2[key] = value
		end
	end
	
	local function classMagicMethod__str(self)
		if magicMethods.__str then
			return magicMethods.__str[1](self2, internals)
		elseif magicMethods.__tostring then
			return magicMethods.__tostring[1](self2, internals)
		else
			return `<Class: { className or "[Unknown]" }>`
		end
	end
	
	local function classMagicMethod__call(self, ...)
		if magicMethods.__call then
			return magicMethods.__call[1](self2, internals, ...)
		end
	end
	
	local function classMagicMethod__concat(self, other)
		if magicMethods.__concat then
			if rawequal(self, object) then
				return magicMethods.__concat[1](internals, self2, other)
			elseif rawequal(other, object) then
				return magicMethods.__concat[1](internals, self, self2)
			end
		else
			return tostring(self) .. tostring(other)
		end
	end
	
	for methodName, method in methods do
		getableKeyList[methodName] = true
		self2[methodName] = function(...)
			if rawequal(({ ... })[1], object) then
				local args = { ... }
				table.remove(args, 1)
				
				return method[1](self2, internals, table.unpack(args))
			else
				return method[1](self2, internals, ...)
			end
		end
	end
	
	for _, eventName in events do
		local newSignal = LemonSignal.new()
		self2[eventName] = newSignal
		metatable.__signals[eventName] = newSignal
		getableKeyList[eventName] = true
	end
	
	setmetatable(self2, { __newindex = function(self, key, value)
		setableKeyList[key] = true
		getableKeyList[key] = true
		
		rawset(self2, key, value)
	end })
	;
	(magicMethods.__init[1] or doingNothing)(self2, internals, ...)
	
	setmetatable(self2, nil)
	
	metatable.__index = classMagicMethod__getter
	metatable.__newindex = classMagicMethod__setter
	metatable.__tostring = classMagicMethod__str
	metatable.__call = classMagicMethod__call
	metatable.__concat = classMagicMethod__concat
	
	return object
end

local Main = setmetatable({}, { __call = __call })
Main.method = mkMethod :: types.nm_level1
Main.event = mkEvent :: types.ne_level1
Main.type = __type :: typeof(__type)
Main.getRealSelf = getRealSelf :: typeof(getRealSelf)

return Main