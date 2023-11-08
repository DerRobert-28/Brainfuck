function Long.fromPackedString&(theString as string)
	dim as string	longStr
	longStr = String.concat(theString, Long.toPackedString(0))
	longStr = String.subStr(longStr, 0, 4)
	Long.fromPackedString = cvl(longStr)
end function
