function String.subStr$(theString as string, index as integer, length as integer)

	String.subStr = mid$(theString, index + 1, length)

end function


function String.subString$(theString as string, index as integer)

	String.subString = mid$(theString, index + 1)

end function
