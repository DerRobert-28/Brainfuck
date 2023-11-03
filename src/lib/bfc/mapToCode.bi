function mapToCode$(bfToken as string)
	dim as string result

	result = String.Empty
	if Strings.areEqual(bfToken, "+") then result = HexToken_PlusOne
	if Strings.areEqual(bfToken, ",") then result = HexToken_InputCell
	if Strings.areEqual(bfToken, "-") then result = HexToken_MinusOne
	if Strings.areEqual(bfToken, ".") then result = HexToken_OutputCell
	if Strings.areEqual(bfToken, "<") then result = HexToken_PrevCell
	if Strings.areEqual(bfToken, ">") then result = HexToken_NextCell
	if Strings.areEqual(bfToken, "[") then result = HexToken_BeginLoop
	if Strings.areEqual(bfToken, "]") then result = HexToken_EndLoop

	mapToCode = result
end function
