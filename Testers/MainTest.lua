local Class = require(script.Parent.Parent:WaitForChild("Main"))
local method = Class.method
local event = Class.event

local person = Class "person" {
	method "__init"(function(self, internals, name, age)
		self.name = name
		self.age = age
		
		internals.information = `name: { name } | age: { age }`
	end);
	
	method "__call"(function(self, internals, ...)
		self.__called:Fire(...)
		
		return Class.getRealSelf(self)
	end);
	
	method "__concat"(function(internals, left, right)
		if Class.type(left, "person") then
			return left.name .. right
		elseif Class.type(right, "person") then
			return left .. right.name
		end
		
		return `concat failed!`
	end);
	
	event "__called";
}

local L_02L = person.new("미믹", "고3")

print(L_02L == L_02L(){}(){}(){})

print(L_02L .. " is jong 5 pom translator")
print("jong 5 pom translator: " .. L_02L)

return nil