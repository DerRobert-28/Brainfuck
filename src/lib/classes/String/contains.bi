function String.contains%(theString as string, search as string)
	String.contains = (0 <= String.indexOf(theString, search))
end function
