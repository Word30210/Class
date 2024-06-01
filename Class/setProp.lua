--#[ lib ]#--
local lib = script.Parent.lib
local assert = require(lib.customAssert)

--#[ Functions ]#--
local function main(object, key, value)
    local metatable = getmetatable(object)

    if metatable.__getableKeyDict[key] then
        if metatable.__setableKeyDict[key] then
            metatable.__properties[key] = value
        else
            assert(false, `{ tostring(object) }.{ key } is readonly`, 4)
        end
    elseif value ~= nil then
        metatable.__getableKeyDict[key] = true
        metatable.__setableKeyDict[key] = true
        metatable.__properties[key] = value
    end
end

return main