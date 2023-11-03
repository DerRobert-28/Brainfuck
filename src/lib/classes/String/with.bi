function String.startsWith%(theString as string, withString as string)
	dim as integer theLength
	
	theLength = String.length(withString)

	String.startsWith = Strings.areEqual(String.substr(theString, theLength), withString)
end function

