function fetchToken$(handle as integer, currentLineByRef as string)
	dim as integer	index
	dim as string	result

	if String.isEmpty(currentLineByRef) then currentLineByRef = String.trim(File.readLine(handle))

	index = String.indexOfOneOf(currentLineByRef, Char.WhitespaceList)
	if index < 0 then
		result = currentLineByRef
		currentLineByRef = String.Empty
	else
		result = String.subStr(currentLineByRef, 0, index)
		currentLineByRef = String.trim(String.subString(currentLineByRef, index))
	endif

	fetchToken = String.trim(result)
end function
