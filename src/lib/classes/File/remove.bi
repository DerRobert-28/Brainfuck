function File.remove%(fileName as string)
	dim as integer result
	Try
		' kill fileName
	Catch result
	EndTry
	File.remove = result
end function
