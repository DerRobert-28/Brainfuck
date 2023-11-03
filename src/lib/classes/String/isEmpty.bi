function String.isEmpty%(theString as string)
	String.isEmpty = (0 = len(theString))
end function

function String.isEmptyOrWhitespace%(theString as string)
	String.isEmptyOrWhitespace = String.isEmpty(trim$(theString))
end function
