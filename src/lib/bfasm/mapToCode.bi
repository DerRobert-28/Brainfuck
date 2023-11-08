function mapToCode$(theToken as string)
	dim as string bfToken, result

	bfToken = String.toLowerCase(String.trim(theToken))
	result = String.Empty

	if Strings.areEqual(bfToken, "add") then result = HexToken_PlusOne
	if Strings.areEqual(bfToken, "cin") then result = HexToken_InputCell
	if Strings.areEqual(bfToken, "cout") then result = HexToken_OutputCell
	if Strings.areEqual(bfToken, "dec") then result = HexToken_MinusOne
	if Strings.areEqual(bfToken, "if") then result = HexToken_BeginLoop
	if Strings.areEqual(bfToken, "in") then result = HexToken_InputCell
	if Strings.areEqual(bfToken, "inc") then result = HexToken_PlusOne
	if Strings.areEqual(bfToken, "inp") then result = HexToken_InputCell
	if Strings.areEqual(bfToken, "jmp") then result = HexToken_JumpToLabel
	if Strings.areEqual(bfToken, "loop") then result = HexToken_EndLoop
	if Strings.areEqual(bfToken, "loopne") then result = HexToken_EndLoop
	if Strings.areEqual(bfToken, "loopnz") then result = HexToken_EndLoop
	if Strings.areEqual(bfToken, "nop") then result = HexToken_NoOperation
	if Strings.areEqual(bfToken, "out") then result = HexToken_OutputCell
	if Strings.areEqual(bfToken, "pop") then result = HexToken_PrevCell
	if Strings.areEqual(bfToken, "push") then result = HexToken_NextCell
	if Strings.areEqual(bfToken, "ret") then result = HexToken_Return
	if Strings.areEqual(bfToken, "sub") then result = HexToken_MinusOne
	if Strings.areEqual(bfToken, "while") then result = HexToken_BeginLoop

	mapToCode = result
end function
