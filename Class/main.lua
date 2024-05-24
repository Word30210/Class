--#[ Types ]#--
local Types = require(script.Parent.Types)

--#[ Services ]#--
--

--#[ Head Variables ]#--
--

--#[ Modules ]#--
local mkEvent = require(script.Parent.mkEvent)
local mkFunc = require(script.Parent.mkFunc)

--#[ libs ]#--
local libs = script.Parent.lib
local customAssert = require(libs.customAssert)
local customWarn = require(libs.customWarn)
local pipe = require(libs.pipe)
local typeChecker = require(libs.typeChecker)

--#[ Variables ]#--
local main = {}

--#[ Function ]#--
local function interpret(classConfig)
	local magicmethods = {}
	local functions = {}
	local methods = {}
	local events = {}

	for _, config in classConfig do
		local configType = getmetatable(config).__type
		if configType == "func" then
			local funcType = config.funcType
			if funcType == "magic" then
				table.insert(magicmethods, config)
			elseif funcType == "default" then
				table.insert(functions, config)
			elseif funcType == "method" then
				table.insert(methods, config)
			end
		elseif configType == "event" then
			table.insert(events, config)
		end
	end

	return magicmethods, functions, methods, events
end

main.interpret = interpret

main.func = mkFunc
main.event = mkEvent

return main