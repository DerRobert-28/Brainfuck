function String.startsWith%(theString as string, withString as string)
	dim as integer	theLength
	dim as string	leftString
	
	theLength = String.length(withString)
	leftString = String.subStr(theString, 0, theLength)

	String.startsWith = Strings.areEqual(leftString, withString)
end function
