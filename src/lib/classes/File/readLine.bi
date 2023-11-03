function File.readLine$(handle as integer)
	dim as string localReadLine
	line input #handle, localReadLine
	File.readLine = localReadLine
end function
