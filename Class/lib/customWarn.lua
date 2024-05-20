return function(message: string, useTrace: boolean)
	warn(message .. (useTrace and "\n" .. debug.traceback() or ""))
end