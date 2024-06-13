local Class = require(script.Parent.Parent:WaitForChild("main"))
local def = Class.func
local event = Class.event
local get = Class.getProp
local set = Class.setProp
local prop = Class.setProps
local destroyer = Class.destroyer

local ioClass = Class "io" {
    def ".saveToInternal" (function(internal, key, value)
        internal[key] = value
    end);

    def ".getFromInternal" (function(internal, key)
        return internal[key]
    end);

    def ".printf" (function(internal, str, ...)
        print(str:format(...))
    end);

    def ".printInternal" (function(internal)
        table.foreach(internal, print)
    end);
}

local io = ioClass.new()

io.saveToInternal("Hello", "world!")
print("Hello, " .. io.getFromInternal("Hello"))

io.printf("Hello, %s", "world!")
io.printInternal()

return nil