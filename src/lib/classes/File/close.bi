sub File.close(fileHandle as integer)
	dim as integer result
	Try
		close fileHandle
	Catch result
	EndTry
end sub

sub File.closeAll()
	close
end sub
