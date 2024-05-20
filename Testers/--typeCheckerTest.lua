local lib = script.Parent.Parent:WaitForChild("lib")
local typeChecker = require(lib:WaitForChild("typeChecker"))

--local isNumber = typeChecker.type("number")
--print(isNumber(123))
--print(isNumber("123"))

--local isBasePart = typeChecker.to(Instance.new("Part"))
--print(isBasePart(123))
--print(isBasePart(Instance.new("Part")))

--local isDict = typeChecker.tableType("string", "any")
--print(isDict({
--	["word"] = 123,
--	["toto"] = "abc",
--	[1] = 123456789
--}))

local fooChecker = typeChecker.tuple("number", "any", "string")
local function a(x, y, name)
	fooChecker(x, y, name)
	return `{ name }: { x + y }`
end

print(a(1, "2", "word"))

return nil