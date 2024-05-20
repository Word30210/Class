--// Types
local types = require(script.Parent:WaitForChild("Types"))

local function newEventLevel1(eventName: string | { string }): types.nm_final
	return setmetatable({ eventName }, { __metatable = "event" })
end

return newEventLevel1