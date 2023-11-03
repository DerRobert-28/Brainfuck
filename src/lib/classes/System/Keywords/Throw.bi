function Throw%(exceptionByVal as integer)
	dim as integer handle

	Try
		error exceptionByVal
	Catch handle
	EndTry

	Throw = handle
end function
