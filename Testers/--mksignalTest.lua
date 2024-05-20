local lib = script.Parent.Parent:WaitForChild("lib")
local mksignal = require(lib:WaitForChild("signal"):WaitForChild("mksignal"))

local newSignal = mksignal.new("mksignal test")

local connection1 = newSignal:Connect(print)

newSignal:Fire("word", "is", "not", "toto")
connection1:Disconnect()

newSignal:Fire("toto", "is", "not", "word")

local connection2 = newSignal:Connect(print)
newSignal:Fire("toto", "is", "not", "word")

newSignal:Destroy()
newSignal:Fire("dead")

return nil