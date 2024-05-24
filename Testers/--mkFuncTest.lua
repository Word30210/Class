local mkFunc = require(script.Parent.Parent.mkFunc)

local newFuncConfig1 = mkFunc ".test"

print(newFuncConfig1)
print(newFuncConfig1.funcType)

local newFuncConfig1 = mkFunc ":test"

print(newFuncConfig1)
print(newFuncConfig1.funcType)

local newFuncConfig1 = mkFunc "__test"

print(newFuncConfig1)
print(newFuncConfig1.funcType)

local newFuncConfig1 = mkFunc "test"

print(newFuncConfig1)
print(newFuncConfig1.funcType)

local newFuncConfig2 = mkFunc ".test"

local runner1 = function()end
local runner2 = function()end

print(newFuncConfig2)
print(getmetatable(newFuncConfig2).__type == "func")

newFuncConfig2(runner1)
print(newFuncConfig2.runner == print)
print(newFuncConfig2.runner == runner1)

-- newFuncConfig2(runner2) --// There must be an error
-- print(newFuncConfig2.runner == runner1)
-- print(newFuncConfig2.runner == runner2)

return nil