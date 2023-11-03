function mapToCode$(bfToken as string)
	dim as string result

	if Strings.areEqual(bfToken, "+") then result = "A"
	if Strings.areEqual(bfToken, ",") then result = "F"
	if Strings.areEqual(bfToken, "-") then result = "B"
	if Strings.areEqual(bfToken, ".") then result = "E"
	if Strings.areEqual(bfToken, "<") then result = "9"
	if Strings.areEqual(bfToken, ">") then result = "8"
	if Strings.areEqual(bfToken, "[") then result = "C"
	if Strings.areEqual(bfToken, "]") then result = "D"

	mapToCode = result
end function
