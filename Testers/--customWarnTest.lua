local lib = script.Parent.Parent:WaitForChild("lib")
local warn = require(lib:WaitForChild("customWarn"))

local function a()
	warn("asdfasdf")
end

a()

return nil