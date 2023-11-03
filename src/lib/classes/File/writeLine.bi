function File.writeLine%(handle as string, theString as string)
	dim as integer result
	Try
		print #handle, theString
	Catch result
	EndTry
	File.writeLine = result
end function

sub File.writeLine(handle as string, theString as string)
	dim as integer dummy
	dummy = File.writeLine(handle, theString)
end sub
