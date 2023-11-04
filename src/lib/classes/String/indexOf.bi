function String.indexOf%(theString as string, search as string)
	if String.isEmpty(theString) or String.isEmpty(search) then
		String.indexOf = String.IndexOfNotFound
	else
		String.indexOf = instr(1, theString, search) - 1
	endif
end function


function String.IndexOfNotFound%()
	String.IndexOfNotFound = -1
end function


function String.indexOfOneOf%(theString as string, charList as string)
	dim as integer each
	dim as string currentChar
	dim as integer position
	
	for each = 1 to String.length(charList)
		currentChar = String.charAt(charList, each - 1)
		position = String.indexOf(theString, currentChar)
		if position >= 0 then
			String.indexOfOneOf = position
			exit function
		endif
	next

	String.indexOfOneOf = String.IndexOfNotFound
end function
