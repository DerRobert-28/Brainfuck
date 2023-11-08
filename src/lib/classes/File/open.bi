function File.open%(fileName as string, fileMode as string)
	dim handle as integer

	handle = freefile
	open fileMode, handle, String.trim(fileName)

	File.open = handle
end function
