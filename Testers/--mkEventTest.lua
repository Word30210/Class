local mkEvent = require(script.Parent.Parent.mkEvent)

local newEventConfig = mkEvent "test"

print(newEventConfig)
print(getmetatable(newEventConfig).__type == "event")

return nil