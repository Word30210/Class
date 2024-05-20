local lib = script.Parent.Parent:WaitForChild("lib")
local assert = require(lib:WaitForChild("customAssert"))

local function a(boolean: boolean)
	assert(boolean, "asdfasdf", 2)
end

a()

return nil