--#[ Types ]#--
local Types = require(script.Parent.Types)

--#[ Services ]#--
--

--#[ Head Variables ]#--
--

--#[ Modules ]#--
local mkEvent = require(script.Parent.mkEvent)
local mkFunc = require(script.Parent.mkFunc)
local getProp = require(script.Parent.getProp)
local setProp = require(script.Parent.setProp)
local setProps = require(script.Parent.setProps)

--#[ libs ]#--
local libs = script.Parent.lib
local assert = require(libs.customAssert)
local warn = require(libs.customWarn)
local pipe = require(libs.pipe)
local typeChecker = require(libs.typeChecker)

--#[ Variables ]#--
local main = {}

local getableClassKeyDict = {
	new = true
}

--#[ Functions ]#--
local __call = nil
local interpret = nil
local buildClass = nil
local buildObject = nil

local function weaktable(weaktable)
	weaktable.__mode = weaktable.__mode or "kv"
	
	return setmetatable({}, weaktable)
end

function __call(self, classNameOrClassConfig)
	if type(classNameOrClassConfig) == "string" then
		return function(classConfig)
			return interpret(classNameOrClassConfig, classConfig)
		end
	elseif type(classNameOrClassConfig) == "table" then
		return interpret(nil, classNameOrClassConfig)
	end
end

function interpret(className, classConfig)
	local magicmethods = {}
	local functions = {}
	local methods = {}
	local events = {}

	for _, config in classConfig do
		local configType = getmetatable(config).__type
		if configType == "func" then
			local funcType = config.funcType
			if funcType == "magic" then
				magicmethods[config.name] = config
			elseif funcType == "default" then
				functions[config.name] = config
			elseif funcType == "method" then
				methods[config.name] = config
			end
		elseif configType == "event" then
			events[config.name] = config
		end
	end

	return buildClass(className, magicmethods, functions, methods, events)
end

function buildClass(className, magicmethods, functions, methods, events)
	local class = newproxy(true)
	local metatable = getmetatable(class)

	local function new(...: any)
		print("[ main.new ]: ", ...)
		return buildObject(class, ...)
	end

	metatable.__variables = {
		className = className ;
		magicmethods = magicmethods;
		functions = functions;
		methods = methods;
		events = events;

		new = new;
	}

	function metatable.__index(self, key)
		assert(getableClassKeyDict[key], `{ key } is not a valid member of Class "{ className or "[Unknown]" }"`)

		return metatable.__variables[key]
	end

	function metatable.__newindex(self, key, value)
		error(`<Class: { className or "[Unknown]" }>.{ key } is readonly`)
	end

	function metatable.__tostring(self)
		return `<Class: { className or "[Unknown]" }>`
	end

	return class
end

function buildObject(class, ...: any)
	local function getVariable(key)
		return getmetatable(class).__variables[key]
	end

	local magicmethods = getVariable "magicmethods"
	local functions = getVariable "functions"
	local methods = getVariable "methods"
	local events = getVariable "events"
	local className = getVariable "className"

	local internals = weaktable {}
	local properties = weaktable {}

	local object = newproxy(true)
	local metatable = getmetatable(object)

	metatable.__properties = properties
	metatable.__internals = internals
	metatable.__type = className

	local getableKeyDict = {}
	local setableKeyDict = {}

	metatable.__getableKeyDict = getableKeyDict
	metatable.__setableKeyDict = setableKeyDict

	for _, func in functions do
		getableKeyDict[func.name] = true
		properties[func.name] = func.runner
	end

	for _, method in methods do
		getableKeyDict[method.name] = true
		properties[method.name] = function(self, ...)
			method.runner(self, internals, ...)
		end
	end

	for _, event in events do
		getableKeyDict[event.name] = true
	end

	function metatable.__index(self, key)
		assert(getableKeyDict[key], `{ key } is not a valid member of { tostring(class) }.`)

		if magicmethods.__getter then
			return magicmethods.__getter.runner(self, internals, key)
		elseif magicmethods.__index then
			return magicmethods.__index.runner(self, internals, key)
		else
			return properties[key]
		end
	end

	function metatable.__newindex(self, key, value)
		assert(setableKeyDict[key], `{ tostring(self) }.{ key } is readonly`)

		if magicmethods.__setter then
			magicmethods.__setter.runner(self, internals, key, value)
		elseif magicmethods.__newindex then
			magicmethods.__newindex.runner(self, internals, key, value)
		else
			properties[key] = value
		end
	end

	function metatable.__call(self, ...)
		if magicmethods.__call then
			return magicmethods.__call.runner(self, internals, ...)
		end
	end

	function metatable.__concat(obj1, obj2)
		if magicmethods.__concat then
			return magicmethods.__concat.runner(object, internals, obj1, obj2)
		else
			return tostring(obj1) .. tostring(obj2)
		end
	end

	function metatable.__unm(self)
		if magicmethods.__unm then
			return magicmethods.__unm.runner(self, internals)
		end
	end

	function metatable._add(obj1, obj2)
		if magicmethods.__add then
			return magicmethods.__add.runner(object, internals, obj1, obj2)
		end
	end

	function metatable._sub(obj1, obj2)
		if magicmethods.__sub then
			return magicmethods.__sub.runner(object, internals, obj1, obj2)
		end
	end

	function metatable._mul(obj1, obj2)
		if magicmethods.__mul then
			return magicmethods.__mul.runner(object, internals, obj1, obj2)
		end
	end

	function metatable._div(obj1, obj2)
		if magicmethods.__div then
			return magicmethods.__div.runner(object, internals, obj1, obj2)
		end
	end

	function metatable._idiv(obj1, obj2)
		if magicmethods.__idiv then
			return magicmethods.__idiv.runner(object, internals, obj1, obj2)
		end
	end

	function metatable._mod(obj1, obj2)
		if magicmethods.__mod then
			return magicmethods.__mod.runner(object, internals, obj1, obj2)
		end
	end

	function metatable._pow(obj1, obj2)
		if magicmethods.__pow then
			return magicmethods.__pow.runner(object, internals, obj1, obj2)
		end
	end

	function metatable.__tostring(self)
		if magicmethods.__str then
			return magicmethods.__str.runner(self, internals)
		elseif magicmethods.__tostring then
			return magicmethods.__tostring.runner(self, internals)
		else
			return `<Object: { className or "[Unknown]" }>`
		end
	end

	function metatable.__eq(obj1, obj2)
		if magicmethods.__eq then
			return magicmethods.__eq.runner(object, internals, obj1, obj2)
		end
	end

	function metatable._lt(obj1, obj2)
		if magicmethods.__lt then
			return magicmethods.__lt.runner(object, internals, obj1, obj2)
		end
	end

	function metatable._le(obj1, obj2)
		if magicmethods.__le then
			return magicmethods.__le.runner(object, internals, obj1, obj2)
		end
	end

	function metatable._len()
	end

	function metatable._iter()
	end

	if magicmethods.__init then
		magicmethods.__init.runner(object, internals, ...)
	end

	metatable.__objectCreated = true

	return object
end

main.func = mkFunc
main.event = mkEvent
main.getProp = getProp
main.setProp = setProp
main.setProps = setProps

return setmetatable(main, { __call = __call })