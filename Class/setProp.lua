--#[ lib ]#--
local lib = script.Parent.lib
local assert = require(lib.customAssert)

--#[ Functions ]#--
local function main(object, key, value)
    local metatable = getmetatable(object)

    assert(not metatable.__objectCreated, "After the object is created, the value cannot be specified as \"setProp\"", 4)

    if metatable.__getableKeyDict[key] then
        if metatable.__setableKeyDict[key] then
            if value then
                metatable.__properties[key] = value
            else
                metatable.__getableKeyDict[key] = nil
                metatable.__setableKeyDict[key] = nil
            end
        else
            assert(false, `{ tostring(object) }.{ key } is readonly`, 4)
        end
    elseif value then
        metatable.__getableKeyDict[key] = true
        metatable.__setableKeyDict[key] = true
        metatable.__properties[key] = value
    end
end

return main