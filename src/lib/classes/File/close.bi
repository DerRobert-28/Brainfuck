sub File.close(fileHandle)
	dim as integer result
	Try
		close fileHandle
	Catch result
	EndTry
end sub
