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
local destroyer = require(script.Parent.destroyer)

--#[ libs ]#--
local lib = script.Parent.lib
local assert = require(lib.customAssert)
local warn = require(lib.customWarn)
local pipe = require(lib.pipe)
local typeChecker = require(lib.typeChecker)
local LemonSignal = require(lib.LemonSignal)

--#[ Variables ]#--
local main = {}

local null = newproxy()

local getableClassKeyDict = {
	new = true;

	objectCreated = true;
	objectDestroyed = true;
	childClassCreated = true;
}

--#[ Functions ]#--
local __call = nil
local interpret = nil
local buildClass = nil
local buildObject = nil

local __call_inheritance = nil
local interpret_inheritance = nil

local function weaktable(weaktable)
	weaktable.__mode = weaktable.__mode or "kv"

	return setmetatable({}, weaktable)
end

function __call(self, classNameOrClassConfig)
	if type(classNameOrClassConfig) == "string" then
		return function(classConfig)
			return interpret(classNameOrClassConfig, classConfig) :: Types.class
		end
	elseif type(classNameOrClassConfig) == "table" then
		return interpret(nil, classNameOrClassConfig) :: Types.class
	end
end

function __call_inheritance(self, classNameOrClassConfig: string | Types.classConfig)
	if type(classNameOrClassConfig) == "string" then
		return function(classConfig: Types.classConfig)
			return interpret_inheritance(classNameOrClassConfig, classConfig, self) :: Types.class
		end
	elseif type(classNameOrClassConfig) == "table" then
		return interpret_inheritance(nil, classNameOrClassConfig, self) :: Types.class
	end
end

function interpret(className: string, classConfig: Types.classConfig)
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

function interpret_inheritance(className: string, classConfig: Types.classConfig, parentClass: Types.class)
	local parentMetatable = getmetatable(parentClass)
	local parentMagicmethods = parentMetatable.__variables.magicmethods
	local parentFunctions = parentMetatable.__variables.functions
	local parentMethods = parentMetatable.__variables.methods
	local parentEvents = parentMetatable.__variables.events

	local function inherit(parentTable, childTable)
		for key, value in parentTable do
			if childTable[key] then continue end

			childTable[key] = value
		end
	end

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

	inherit(parentMagicmethods, magicmethods)
	inherit(parentFunctions, functions)
	inherit(parentMethods, methods)
	inherit(parentEvents, events)

	return buildClass(className, magicmethods, functions, methods, events)
end

function buildClass(className: string, magicmethods, functions, methods, events)
	local class = newproxy(true)
	local metatable = getmetatable(class)

	local objectCreated = LemonSignal.new()
	local objectDestroyed = LemonSignal.new()
	local childClassCreated = LemonSignal.new()

	local function new(...: any)
		local newObject = buildObject(class, ...)

		task.defer(objectCreated.Fire, objectCreated, newObject)

		return newObject
	end

	metatable.__variables = {
		className = className ;
		magicmethods = magicmethods;
		functions = functions;
		methods = methods;
		events = events;

		new = new;
		objectCreated = objectCreated;
		objectDestroyed = objectDestroyed;
		childClassCreated = childClassCreated;
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

	function metatable.__call(self, classNameOrClassConfig)
		local childClass = __call_inheritance(self, classNameOrClassConfig)

		task.defer(childClassCreated.Fire, childClassCreated, childClass)

		return childClass
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

	local internal = {}
	local properties = {}

	local object = newproxy(true)
	local metatable = getmetatable(object)

	metatable.__properties = properties
	metatable.__internal = internal
	metatable.__type = className
	metatable.__class = class

	local getableKeyDict = {}
	local setableKeyDict = {}

	metatable.__getableKeyDict = getableKeyDict
	metatable.__setableKeyDict = setableKeyDict

	if magicmethods.__new then
		magicmethods.__new.runner(object, internal, ...)
	end

	for _, func in functions do
		getableKeyDict[func.name] = true
		properties[func.name] = function(...)
			return func.runner(internal, ...)
		end
	end

	for _, method in methods do
		getableKeyDict[method.name] = true
		properties[method.name] = function(self, ...)
			return method.runner(self, internal, ...)
		end
	end

	for _, event in events do
		getableKeyDict[event.name] = true
		properties[event.name] = LemonSignal.new()
	end

	local function __index(self, key)
		assert(getableKeyDict[key], `{ key } is not a valid member of { tostring(class) }.`)

		if magicmethods.__getter then
			local result = magicmethods.__getter.runner(self, internal, key)
			if result == null then
				return nil
			else
				return result
			end
		elseif magicmethods.__index then
			local result = magicmethods.__index.runner(self, internal, key)
			if result == null then
				return nil
			else
				return result
			end
		else
			if properties[key] == null then
				return nil
			else
				return properties[key]
			end
		end
	end

	local function __newindex(self, key, value)
		assert(setableKeyDict[key], `{ tostring(self) }.{ key } is readonly`)

		if magicmethods.__setter then
			magicmethods.__setter.runner(self, internal, key, value)
		elseif magicmethods.__newindex then
			magicmethods.__newindex.runner(self, internal, key, value)
		else
			properties[key] = value
		end
	end

	local function __call(self, ...)
		return magicmethods.__call.runner(self, internal, ...)
	end

	local function __concat(obj1, obj2)
		if magicmethods.__concat then
			return magicmethods.__concat.runner(object, internal, obj1, obj2)
		else
			return tostring(obj1) .. tostring(obj2)
		end
	end

	local function __unm(self)
		return magicmethods.__unm.runner(self, internal)
	end

	local function __add(obj1, obj2)
		return magicmethods.__add.runner(object, internal, obj1, obj2)
	end

	local function __sub(obj1, obj2)
		return magicmethods.__sub.runner(object, internal, obj1, obj2)
	end

	local function __mul(obj1, obj2)
		return magicmethods.__mul.runner(object, internal, obj1, obj2)
	end

	local function __div(obj1, obj2)
		return magicmethods.__div.runner(object, internal, obj1, obj2)
	end

	local function __idiv(obj1, obj2)
		return magicmethods.__idiv.runner(object, internal, obj1, obj2)
	end

	local function __mod(obj1, obj2)
		return magicmethods.__mod.runner(object, internal, obj1, obj2)
	end

	local function __pow(obj1, obj2)
		return magicmethods.__pow.runner(object, internal, obj1, obj2)
	end

	local function __tostring(self)
		if magicmethods.__str then
			return magicmethods.__str.runner(self, internal)
		elseif magicmethods.__tostring then
			return magicmethods.__tostring.runner(self, internal)
		else
			return `<Object: { className or "[Unknown]" }>`
		end
	end

	local function __eq(obj1, obj2)
		return magicmethods.__eq.runner(object, internal, obj1, obj2)
	end

	local function __lt(obj1, obj2)
		return magicmethods.__lt.runner(object, internal, obj1, obj2)
	end

	local function __le(obj1, obj2)
		return magicmethods.__le.runner(object, internal, obj1, obj2)
	end

	local function __len(self)
		return magicmethods.__len.runner(self, internal)
	end

	local function __iter(self)
		return magicmethods.__iter.runner(self, internal)
	end

	if magicmethods.__init then
		magicmethods.__init.runner(object, internal, ...)
	end

	metatable.__objectCreated = true

	metatable.__index = __index
	metatable.__newindex = __newindex
	metatable.__call = magicmethods.__call and __call
	metatable.__concat = magicmethods.__concat and __concat
	metatable.__unm = magicmethods.__unm and __unm
	metatable.__add = magicmethods.__add and __add
	metatable.__sub = magicmethods.__sub and __sub
	metatable.__mul = magicmethods.__mul and __mul
	metatable.__div = magicmethods.__div and __div
	metatable.__idiv = magicmethods.__idiv and __idiv
	metatable.__mod = magicmethods.__mod and __mod
	metatable.__pow = magicmethods.__pow and __pow
	metatable.__tostring = __tostring
	metatable.__eq = magicmethods.__eq and __eq
	metatable.__lt = magicmethods.__lt and __lt
	metatable.__le = magicmethods.__le and __le
	metatable.__len = magicmethods.__len and __len
	metatable.__iter = magicmethods.__iter and __iter

	return object
end

main.func = mkFunc
main.event = mkEvent
main.getProp = getProp
main.setProp = setProp
main.setProps = setProps
main.destroyer = destroyer
main.null = null

return setmetatable(main, { __call = __call })