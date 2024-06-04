--#[ Types ]#--
local Types = require(script.Parent.Types)

--#[ Services ]#--
--

--#[ Head Variables ]#--
--

--#[ Modules ]#--
--

local function main(object)
    local metatable = getmetatable(object)
    local class = metatable.__class
    local objectDestroyed = getmetatable(class).__variables.objectDestroyed

    for _, lemon in metatable.__properties do
        lemon:Destroy()
    end

    for k, _ in metatable do
        metatable[k] = nil
    end

    task.defer(objectDestroyed.Fire, objectDestroyed)

    return object
end

return main