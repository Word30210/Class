--#[ Variables ]#--
local metatable = { __type = "event" }

--#[ Functions ]#--
local function main(eventName: string)
    return setmetatable({ name = eventName }, metatable)
end

return main