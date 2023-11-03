function Char.codeAt%(theString as string, index as integer)
	Char.codeAt = asc(mid$(theString, index + 1, 1))
end function
