--#[ Variables ]#--
--

--#[ Functions ]#--
local function main(funcName: string)
    local funcType = "unknownFunc"

    local prefix, fnName = string.match(funcName, "([%.:]?)([%a_][%w_]+)")
    if prefix == ":" then
        funcType = "method"
    elseif prefix == "." then
        funcType = "default"
    elseif string.find(fnName, "^__") then
        funcType = "magic"
    end

    return setmetatable({ name = fnName or funcName, funcType = funcType, runner = print }, {
        __type = "func";
    
        __call = function(self, runner)
            self.runner = runner
            getmetatable(self).__call = nil
            return self
        end
    })
end

return main