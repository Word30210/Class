local assert = require(script.Parent:WaitForChild("customAssert"))

export type checker = (value: any) -> boolean

local function returnEmptyString()return""end

local typeChecker = {}

function typeChecker.type(typeName: string): checker
	return function(value: any)
		return type(value) == typeName
	end
end

function typeChecker.typeof(typeName: string): checker
	return function(value: any)
		return typeof(value) == typeName
	end
end

function typeChecker.t(headerValue: any): checker
	local headerValueType = type(headerValue)
	return function(value: any)
		return type(value) == headerValueType
	end
end

function typeChecker.to(headerValue: any): checker
	local headerValueType = typeof(headerValue)
	return function(value: any)
		return typeof(value) == headerValueType
	end
end

function typeChecker.any(value)
	return value ~= nil and true or false
end

function typeChecker.tableType(keyTypeName: boolean, valueTypeName: string)
	return function(t: {[any]: any})
		for key, value in t do
			if keyTypeName == "any" then
				if not typeChecker.any(key) then
					return false
				end
			else
				if type(key) ~= keyTypeName then
					return false
				end
			end
			if valueTypeName == "any" then
				if not typeChecker.any(value) then
					return false
				end
			else
				if type(value) ~= valueTypeName then
					return false
				end
			end
		end
		return true
	end
end

typeChecker._nil = typeChecker.type("nil")
typeChecker.boolean = typeChecker.type("boolean")
typeChecker.number = typeChecker.type("number")
typeChecker.string = typeChecker.type("string")
typeChecker._function = typeChecker.type("function")
typeChecker.userdata = typeChecker.type("userdata")
typeChecker.thread = typeChecker.type("thread")
typeChecker.table = typeChecker.type("table")

typeChecker["nil"] = typeChecker.type("nil")
typeChecker["function"] = typeChecker.type("function")

typeChecker.Axes = typeChecker.typeof("Axes")
typeChecker.BrickColor = typeChecker.typeof("BrickColor")
typeChecker.CatalogSearchParams = typeChecker.typeof("CatalogSearchParams")
typeChecker.CFrame = typeChecker.typeof("CFrame")
typeChecker.Color3 = typeChecker.typeof("Color3")
typeChecker.ColorSequence = typeChecker.typeof("ColorSequence")
typeChecker.ColorSequenceKeypoint = typeChecker.typeof("ColorSequenceKeypoint")
typeChecker.DateTime = typeChecker.typeof("DateTime")
typeChecker.DockWidgetPluginGuiInfo = typeChecker.typeof("DockWidgetPluginGuiInfo")
typeChecker.Enum = typeChecker.typeof("Enum")
typeChecker.EnumItem = typeChecker.typeof("EnumItem")
typeChecker.Enums = typeChecker.typeof("Enums")
typeChecker.Faces = typeChecker.typeof("Faces")
typeChecker.Instance = typeChecker.typeof("Instance")
typeChecker.NumberRange = typeChecker.typeof("NumberRange")
typeChecker.NumberSequence = typeChecker.typeof("NumberSequence")
typeChecker.NumberSequenceKeypoint = typeChecker.typeof("NumberSequenceKeypoint")
typeChecker.PathWaypoint = typeChecker.typeof("PathWaypoint")
typeChecker.PhysicalProperties = typeChecker.typeof("PhysicalProperties")
typeChecker.Random = typeChecker.typeof("Random")
typeChecker.Ray = typeChecker.typeof("Ray")
typeChecker.RaycastParams = typeChecker.typeof("RaycastParams")
typeChecker.RaycastResult = typeChecker.typeof("RaycastResult")
typeChecker.RBXScriptConnection = typeChecker.typeof("RBXScriptConnection")
typeChecker.RBXScriptSignal = typeChecker.typeof("RBXScriptSignal")
typeChecker.Rect = typeChecker.typeof("Rect")
typeChecker.Region3 = typeChecker.typeof("Region3")
typeChecker.Region3int16 = typeChecker.typeof("Region3int16")
typeChecker.TweenInfo = typeChecker.typeof("TweenInfo")
typeChecker.UDim = typeChecker.typeof("UDim")
typeChecker.UDim2 = typeChecker.typeof("UDim2")
typeChecker.Vector2 = typeChecker.typeof("Vector2")
typeChecker.Vector2int16 = typeChecker.typeof("Vector2int16")
typeChecker.Vector3 = typeChecker.typeof("Vector3")
typeChecker.Vector3int16 = typeChecker.typeof("Vector3int16")

function typeChecker.tuple(...)
	local types = { ... }
	return function(...)
		local values = { ... }
		for i, v in types do
			assert(typeChecker[v], `{ v } is a non-existent type`, 4)
			assert(values[i], `{ v } expected, got void`, 4)
			assert(typeChecker[v](values[i]), `{ v } expected, got { type(values[i]) }`, 4)
		end
		return true
	end
end

return typeChecker