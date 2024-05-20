--[[

	#[ 현재 사용되지 않음 ]#
	#[ Not currently in use ]#

]]--

local typeChecker = require(script.Parent:WaitForChild("typeChecker"))

local function pipe(value, ...: (any) -> (any))
	typeChecker.tuple(table.unpack(string.rep("function ", #{ ... }):gsub("\32$", ""):split(" ")))(...)
	local functions = { ... }
	for _, func in functions do
		value = func(value)
	end
	return value
end

local function pipeUnpack(value, ...: (any) -> {})
	typeChecker.tuple(table.unpack(string.rep("function ", #{ ... }):gsub("\32$", ""):split(" ")))(...)
	local functions = { ... }
	for _, func in functions do
		value = type(value) == "table" and func(table.unpack(value)) or func(value)
	end
	return type(value) == "table" and table.unpack(value) or value
end

local function pipeRecursiveFunction(value, ...: (any) -> ((any) -> ()))
	typeChecker.tuple(table.unpack(string.rep("function ", #{ ... }):gsub("\32$", ""):split(" ")))(...)
	local functions = { ... }
	for _, func in functions do
		while type(value) == "function" do
			value = value()
		end
		value = func(value)
	end
	return value
end

local function pipeUnpackRecursiveFunction(value, ...: ((any) -> ((any) -> ())) & (any) -> {})
	typeChecker.tuple(table.unpack(string.rep("function ", #{ ... }):gsub("\32$", ""):split(" ")))(...)
	local functions = { ... }
	for _, func in functions do
		value = type(value) == "table" and func(table.unpack(value)) or func(value)
		while type(value) == "function" do
			value = value()
		end
	end
	return type(value) == "table" and table.unpack(value) or value
end

return { pipe = pipe, pipeUnpack = pipeUnpack, pipeRecursiveFunction = pipeRecursiveFunction, pipeUnpackRecursiveFunction = pipeUnpackRecursiveFunction }