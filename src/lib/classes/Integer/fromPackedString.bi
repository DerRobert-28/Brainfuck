function Integer.fromPackedString%(theString as string)
	dim as string	intStr
	intStr = String.concat(theString, Integer.toPackedString(0))
	intStr = String.subStr(intStr, 0, 2)
	Integer.fromPackedString = cvi(intStr)
end function
