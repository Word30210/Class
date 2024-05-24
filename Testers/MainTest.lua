local Class = require(script.Parent.Parent:WaitForChild("main"))
local fn = Class.func
local evt = Class.event

print(Class.interpret {
	fn ":Destroy" (function()
		
	end);

	evt "test";
})

return nil