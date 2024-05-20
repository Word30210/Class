return function(value: any, errorMessage: string?, level: number)
	errorMessage = errorMessage or "assertion failed!"
	if not value then
		error(errorMessage, level)
	end
end