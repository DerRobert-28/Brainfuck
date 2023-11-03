function File.write%(handle as integer, theString as string)
	dim as integer result
	Try
		print #handle, theString;
	Catch result
	EndTry
	File.write = result
end function

sub File.write(handle as integer, theString as string)
	dim as integer dummy
	dummy = File.write(handle, theString)
end sub
