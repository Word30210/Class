--#[ Modules ]#--
local setProp = require(script.Parent.setProp)

--#[ Functions ]#--
local function main(object)
    return function(properties)
        for key, value in properties do
            setProp(object, key, value)
        end
    end
end

return main