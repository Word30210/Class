# Class for Rblx
Roblox Object Oriented Programming Helper that resembles Python

# Document
Not yet.(sorry)

# Examples
**CarClass.luau**
```lua
local Class = require(path.to.Class)
local def = Class.func
local event = Class.event
local get = Class.getProp
local set = Class.setProp
local prop = Class.setProps
local destroyer = Class.destroyer

local Car = Class "Car" {
  def "__init" (function(self, internal, Model, Color)
    prop(self) {
      Model = Model or "EpicModel";
      Color = Color or "Blue";
      Speed = 0;
      IsDriving = false;
    }
  end);

  def "__setter" (function(self, internal, key, value)
    assert(key ~= "Speed", "Car.Speed is read-only")
    assert(key ~= "IsDriving", "Car.IsDriving is read-only")

    set(self, key, value)
  end);

  def ":Drive" (function(self, internal)
    set(self, "IsDriving", true)
  end);

  def ":Stop" (function(self, internal)
    set(self, "Speed", 0)
    set(self, "IsDriving", false)

    self.Stopped:Fire()
  end);

  def ":SetSpeed" (function(self, internal, speed)
    if self.IsDriving then
      set(self, "Speed", speed)
    end

    self.SpeedChanged:Fire(speed)
  end);

  def ":Destroy" (function(self, internal)
    destroyer(self)
  end);

  event "Stopped";
  event "SpeedChanged";
}

local myCar = Car.new("bung-bung car", "Red & Yellow")

myCar.Stopped:Connect(print, "Stopped") --// LemonSignal
myCar.SpeedChanged:Connect(print, "SppedChanged") --// LemonSignal

myCar:Drive()
myCar.Color = "Blue & Green"
myCar:SetSpeed(100)
myCar:Stop()
print(myCar.Color)

return nil
```
Output
```
SppedChanged 100
Stopped
Blue & Green
```

**ez_buffer.luau**
https://gist.github.com/Word30210/1b0ebc0a7960c4e426ae4270c2178054
