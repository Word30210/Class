--// Types
local types = require(script.Parent:WaitForChild("Types"))

local function newMethodLevel1(methodName: string): types.nm_level2
	local function newMethodLevel2(runner: types.runner)
		local function newMethodLevel3(_, returnValueType: types.returnValueType)
			return setmetatable({ methodName, runner, returnValueType }, { __metatable = "method" })
		end
		return setmetatable({ methodName, runner, "any" }, { __metatable = "method", __call = newMethodLevel3 })
	end
	return newMethodLevel2
end

return newMethodLevel1