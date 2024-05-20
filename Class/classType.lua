---@diagnostic disable: invalid-class-name

return function(value: any, typeName)
	if typeof(value) == "table" or typeof(value) == "userdata" then
		return getmetatable(value).__type
	else
		return typeof(value, typeName)
	end
end