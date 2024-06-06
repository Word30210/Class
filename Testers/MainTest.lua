local Class = require(script.Parent.Parent:WaitForChild("main"))
local def = Class.func
local event = Class.event
local get = Class.getProp
local set = Class.setProp
local super = Class.setProps
local null = Class.null

local myFrame = Class "Frame" {
	def "__init" (function(self, internal, name)
		super(self) {
			color3 = Color3.new(1, 1, 1);
			anchor = Vector2.new(0.5, 0.5);
			position = UDim2.fromScale(0.5, 0.5);
			size = UDim2.fromOffset(100, 100);
			name = name;
			parent = null;
		}

		local frame = Instance.new("Frame")
		frame.BorderSizePixel = 0
		frame.BackgroundColor3 = Color3.new(1, 1, 1)
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.Size = UDim2.fromOffset(100, 100)
		frame.Name = name

		internal.frame = frame
		internal.getInstanceKey = {
			color3 = "BackgroundColor3";
			anchor = "AnchorPoint";
			position = "Position";
			size = "Size";
			name = "Name";
			parent = "Parent";
		}
	end);

	def "__setter" (function(self, internal, key, value)
		set(self, key, value)

		internal.frame[internal.getInstanceKey[key]] = value
	end);

	def "__str" (function(self, internal)
		return self.name
	end);

	event "testEvent"
}

local Screen = Instance.new("ScreenGui")
Screen.Parent = game.StarterGui

myFrame.objectCreated:Connect(print)

local myNewFrame = myFrame.new("BackgroundFrame")
local a = myFrame.new("a")

return nil