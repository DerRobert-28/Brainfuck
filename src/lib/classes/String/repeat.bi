function String.repeat$(theString as string, count as integer)
	dim as integer	each
	dim as string	result

	result = String.Empty
	for each = 1 to count
		String.append result, theString
	next

	String.repeat = result
end function
