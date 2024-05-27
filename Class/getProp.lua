--#[ Functions ]#--
local function main(object, key)
    return getmetatable(object).__properties[key]
end

return main