function File.seek(fileHandle as integer, position as long)
	dim as integer result

	Try
		seek fileHandle, position + 1
	Catch result
	EndTry

	File.seek = result
end function
