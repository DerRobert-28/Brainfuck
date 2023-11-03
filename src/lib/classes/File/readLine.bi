function File.readLine$(handle as string)
	dim as string localReadLine
	line input #handle, localReadLine
	File.readLine = localReadLine
end function
