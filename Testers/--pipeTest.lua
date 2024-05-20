local lib = script.Parent.Parent:WaitForChild("lib")
local pipe = require(lib:WaitForChild("pipe"))

local function addadd(x, y, z)
	print(x, y, z)
	x += y
	return function()
		return x + z
	end
end

pipe.pipeUnpackRecursiveFunction({ 1, 2, 3 }, addadd, print)

return nil