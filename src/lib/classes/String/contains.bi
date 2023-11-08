function String.contains%(theString as string, search as string)
	String.contains = (0 <= String.indexOf(theString, search))
end function


function String.containsOneOf%(theString as string, charList as string)
	String.containsOneOf = (0 <= String.indexOfOneOf(theString, charList))
end function
