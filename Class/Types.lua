local lib = script.Parent:WaitForChild("lib")
local LemonSignal = require(lib:WaitForChild("LemonSignal"))

--// Global Type
export type runner = (self: {[any]: any}, internals: {[any]: any}, ...any) -> ...any
export type returnValueType = "a"
| "any" | "-> any"
| "string" | "-> string"
| "number" | "-> number"
| "table" | "-> table"
| "userdata" | "-> userdata"
| "Axes" | "-> Axes"
| "BrickColor" | "-> BrickColor"
| "CatalogSearchParams" | "-> CatalogSearchParams"
| "CFrame" | "-> CFrame"
| "Color3" | "-> Color3"
| "ColorSequence" | "-> ColorSequence"
| "ColorSequenceKeypoint" | "-> ColorSequenceKeypoint"
| "Content" | "-> Content"
| "DateTime" | "-> DateTime"
| "DockWidgetPluginGuiInfo" | "-> DockWidgetPluginGuiInfo"
| "Enum" | "-> Enum"
| "EnumItem" | "-> EnumItem"
| "Enums" | "-> Enums"
| "Faces" | "-> Faces"
| "FloatCurveKey" | "-> FloatCurveKey"
| "Font" | "-> Font"
| "Instance" | "-> Instance"
| "NumberRange" | "-> NumberRange"
| "NumberSequence" | "-> NumberSequence"
| "NumberSequenceKeypoint" | "-> NumberSequenceKeypoint"
| "OverlapParams" | "-> OverlapParams"
| "PathWaypoint" | "-> PathWaypoint"
| "PhysicalProperties" | "-> PhysicalProperties"
| "Random" | "-> Random"
| "Ray" | "-> Ray"
| "RaycastParms" | "-> RaycastParms"
| "RaycastResult" | "-> RaycastResult"
| "RBXScriptConnection" | "-> RBXScriptConnection"
| "RBXScriptSignal" | "-> RBXScriptSignal"
| "Rect" | "-> Rect"
| "Region3" | "-> Region3"
| "Region3int16" | "-> Region3int16"
| "Secret" | "-> Secret"
| "SharedTable" | "-> SharedTable"
| "TweenInfo" | "-> TweenInfo"
| "UDim" | "-> UDim"
| "UDim2" | "-> UDim2"
| "Vector2" | "-> Vector2"
| "Vector2int16" | "-> Vector2int16"
| "Vector3" | "-> Vector3"
| "Vector3in16" | "-> Vector3in16"
export type classConfig = {}
export type classNode = {}

--// Main Module
export type main = {}
export type Class = {
	className: string;
	
	objectCreated: LemonSignal.Signal<any>;
	
	new: (...any) -> ();
	is: (Object) -> boolean;
}

--// Class Methods

--// newMethod Module
export type nm_level1 = ((methodName: string) -> nm_level2) & any
export type nm_level2 = ((runner: runner) -> ...any) -> nm_level3
export type nm_level3 = ((returnValueType: returnValueType) -> method) & method
export type method = { "method" & runner & returnValueType }

--// newEvent Module
export type ne_level1 = ((eventName: string) -> eventName) & any
export type eventName = string

local a: classConfig

return nil