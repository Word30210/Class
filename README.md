# Class for Rblx
Roblox Object Oriented Programming Helper that resembles Python

# Document
Not yet.(sorry)

# Example
```lua
local ServerStorage = game:GetService("ServerStorage")

local Class = require(path.to.Class)
local def = Class.func
local event = Class.event
local get = Class.getProp
local set = Class.setProp
local super = Class.setProps
local destroyer = Class.destroyer

local Human = {}
Human = Class "Human" {
  def "__init" (function(self, internal, name, age, job)
    super(self) {
      name = name;
      age = age;
      job = job;

      health = 100;
    }

    local newCharacter = ServerStorage.characterTemplate:Clone()
    newCharacter.Name = name;
    newCharacter.Parent = workspace
    internal.character = newCharacter
  end);

  def "__setter" (function(self, internal, key, value)
    if key == "name" then
      internal.character.Name = value
    elseif key == "health" then
      internal.character.Health = value
      if value == 0 then
        self.Died:Fire()
      end
    end
    set(self, key, value)
  end);

  def "__str" (function(self, _)
    return self.name
  end);

  def ":Kill" (function(self, _)
    self.health = 0 --// call __setter
  end);

  def ":Destroy" (function(self, _)
    return destroyer(self)
  end);

  event "Died";
}

Human.objectCreated:Connect(function(object)
  print(`{ object } has been born`)
end)

local word = Human.new("word", 15 --[[My american age]], "Student")
print(word)

word.Died:Connect(print, "Died") --// LemonSignal
word.health = 0 --//😈😈
```
Output
```
word has been born
word
Died
```
