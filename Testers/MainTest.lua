local Class = require(script.Parent.Parent:WaitForChild("main"))
local fn = Class.func
local evt = Class.event
local gp = Class.getProp
local sp = Class.setProp
local setProps = Class.setProps

local newClass = Class "testClass" {
	fn "__init" (function(self, inter, name)
		setProps(self) {
			name = name;
			__init = 1;
		};

		inter.test = "1q2w3e4r!"
	end);

	fn "__getter" (function(self, inter, key)
		print(inter.test)

		return gp(self, key)
	end);

	fn "__call" (function(self, inter, ...)
		print(...)
		return "aaa"
	end);

	fn "__concat" (function(self, inter, obj1, obj2)
		return tostring(obj1) .. tostring(obj2)
	end);

	fn "__unm" (function(self, inter)
		return -1
	end);
}

local newObject1 = newClass.new("testName")
local newObject2 = newClass.new("a")

-- print(newObject1(1, 2, 3))
-- print("Is " .. newObject1 .. " not toto?")
-- print(-newObject1)
-- print(newObject1 == newObject2)

print(newObject1.name)

-- setProps(newObject1) {
-- 	name = 1;
-- }

return nil