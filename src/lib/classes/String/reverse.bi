function String.reverse$(theString as string)
	dim as integer	length
	dim as integer	index
	dim as string	result

	length = String.length(theString)
	for index = 0 to length - 1
		String.prepend result, String.charAt(theString, index)
	next

	String.reverse = result
end function
