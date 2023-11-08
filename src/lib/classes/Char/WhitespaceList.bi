function Char.WhitespaceList$()
	dim as string result

	result = Char.Null
	String.append result, Char.Tab
	String.append result, Char.Space
	String.append result, Char.NoBreakingSpace

	Char.WhitespaceList = result
end function
