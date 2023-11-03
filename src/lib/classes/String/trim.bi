function String.trim$(theString as string)
	dim as string result

	result = theString
	while String.contains(Char.WhitespaceList, String.charAt(result, 0))
		result = String.subString(result, 1)
	wend

	result = String.reverse(result)
	while String.contains(Char.WhitespaceList, String.charAt(result, 0))
		result = String.subString(result, 1)
	wend

	String.trim = String.reverse(result)
end function
