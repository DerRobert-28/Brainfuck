function String.isNotEmpty%(theString as string)
	String.isNotEmpty = (0 < len(theString))
end function

function String.isNotEmptyOrWhitespace%(theString as string)
	String.isNotEmptyOrWhitespace = String.isNotEmpty(trim$(theString))
end function
