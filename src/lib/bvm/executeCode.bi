function executeCode%(codeBuffer as string, bvmDataPtr as long)
	dim as integer		loopCounter,	_
				result,		_
				simCounter,	_
				value,		_
				xPos,		_
				yPos
	dim as long		nextIndex
	dim as string		code,				_
				codes,				_
				hiMode,				_
				indexStr,			_
				lastCode, loMode, loopBuffer,	_
				nextCode,			_
				stackBuffer,			_
				theKey
	dim as unsigned long	index
	
	bvmDataPtr = 0
	result = 0
	simCounter = 0
	lastCode = String.Empty
	loopBuffer = String.Empty
	stackBuffer = String.Empty
	xPos = 0
	yPos = 0

	do
		code = String.charAt(codeBuffer, index)

		'	test implementation
		if Both(simCounter = 0, Strings.areEqual(code, HexToken_CallSubRoutine)) then
			Debug.message "Call Subroutine"
			codes = String.subStr(codeBuffer, index + 1, 4)
			indexStr = Long.toPackedString(index + 5)
			String.prepend stackBuffer, indexStr
			value = hex2dec(codes)
			index = index + value - 1

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_InputCell)) then
			Debug.message "Input Cell"
			if Strings.areEqual(hiMode, HexToken_SwitchToGraphMode) then
				value = 0
				do
					theKey = Console.readKey
					if Strings.areEqual(theKey, Key.CursorDown) then
						value = value - 1
					elseif Strings.areEqual(theKey, Key.CursorUp) then
						value = value + 1
					elseif Strings.areEqual(theKey, Key.Enter) then
						exit do
					elseif Strings.areEqual(theKey, Key.Escape) then
						value = 0
					elseif Strings.areEqual(theKey, Key.Minus) then
						value = value - 1
					elseif Strings.areEqual(theKey, Key.NewLine) then
						exit do
					elseif Strings.areEqual(theKey, Key.Plus) then
						value = value + 1
					elseif Strings.areEqual(theKey, Key.Return) then
						exit do
					elseif Strings.areEqual(theKey, Key.Zero) then
						value = value * 10
					elseif Strings.areEqual(theKey, Key.One) then
						value = value * 10 + 1
					elseif Strings.areEqual(theKey, Key.Two) then
						value = value * 10 + 2
					elseif Strings.areEqual(theKey, Key.Three) then
						value = value * 10 + 3
					elseif Strings.areEqual(theKey, Key.Four) then
						value = value * 10 + 4
					elseif Strings.areEqual(theKey, Key.Five) then
						value = value * 10 + 5
					elseif Strings.areEqual(theKey, Key.Six) then
						value = value * 10 + 6
					elseif Strings.areEqual(theKey, Key.Seven) then
						value = value * 10 + 7
					elseif Strings.areEqual(theKey, Key.Eight) then
						value = value * 10 + 8
					elseif Strings.areEqual(theKey, Key.Nine) then
						value = value * 10 + 9
					end if
					putPixel xPos, yPos, value
				loop
				putPixel xPos, yPos, bvmData(bvmDataPtr)
				bvmData(bvmDataPtr) = value
			'elseif Strings.areEqual(loMode, HexToken_SwitchToNumberMode) then
			else
				value = Integer.fromPackedString(Console.readKey)
				bvmData(bvmDataPtr) = value
			endif

		'	test implementation
		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_JumpToLabel)) then
			Debug.message "Jump to Label"
			codes = String.subStr(codeBuffer, index + 1, 4)
			value = hex2dec(codes)
			index = index + value - 1

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_MinusOne)) then
			Debug.message "Minus One"
			bvmData(bvmDataPtr) = bvmData(bvmDataPtr) - 1

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_NextCell)) then
			Debug.message "Next Cell"
			if bvmDataPtr >= ubound(bvmData) then
				bvmDataPtr = 0
			else
				bvmDataPtr = bvmDataPtr + 1
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_NoOperation)) then
			Debug.message "No Operation"
			if Strings.areEqual(code, lastCode) then
				result = NORMAL_TERMINATION
				exit do
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_OutputCell)) then
			Debug.message "Output Cell"
			value = bvmData(bvmDataPtr) and 255
			if Strings.areEqual(hiMode, HexToken_SwitchToGraphMode) then
				teleTypePixel xPos, yPos, value
			elseif Strings.areEqual(loMode, HexToken_SwitchToNumberMode) then
				Console.write Integer.toString(value)
			else
				Console.write Char.from(value)
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_PlusOne)) then
			Debug.message "Plus One"
			bvmData(bvmDataPtr) = bvmData(bvmDataPtr) + 1

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_PrevCell)) then
			Debug.message "Previous Cell"
			if bvmDataPtr < 1 then
				bvmDataPtr = ubound(bvmData)
			else
				bvmDataPtr = bvmDataPtr - 1
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_Return)) then
			Debug.message "Return"
			if String.isEmpty(stackBuffer) then
				result = NORMAL_RETURN
				exit do
			else
				indexStr = String.subStr(stackBuffer, 0, 4)
				index = Long.fromPackedString(indexStr) - 1
				stackBuffer = String.subString(stackBuffer, 4)
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_SwitchToAsciiMode)) then
			Debug.message "Config Ascii Mode"
			loMode = HexToken_SwitchToAsciiMode

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_SwitchToGraphMode)) then
			Debug.message "Config Graph Mode"
			hiMode = HexToken_SwitchToGraphMode
			Console.clear
			xPos = 0
			yPos = 0

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_SwitchToNumberMode)) then
			Debug.message "Config Number Mode"
			loMode = HexToken_SwitchToNumberMode

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_SwitchToTextMode)) then
			Debug.message "Config Text Mode"
			hiMode = HexToken_SwitchToTextMode
			Console.clear
			xPos = 0
			yPos = 0

		elseif Strings.areEqual(code, HexToken_BeginLoop) then
			Debug.message "Begin Loop"
			value = bvmData(bvmDataPtr) and 255
			if(simCounter > 0) or(value = 0) then
				simCounter = simCounter + 1
				Debug.forInteger "Loop counter: ", simCounter
			else
				indexStr = Long.toPackedString(index)
				String.prepend loopBuffer, indexStr
			endif

		elseif Strings.areEqual(code, HexToken_EndLoop) then
			Debug.message "End Loop"
			if simCounter > 0 then
				simCounter = simCounter - 1
			else
				value = bvmData(bvmDataPtr) and 255
				if value then
					if String.isEmpty(loopBuffer) then
						result = value
						exit do
					else
						indexStr = String.subStr(loopBuffer, 0, 4)
						index = Long.fromPackedString(indexStr) - 1
						loopBuffer = String.subString(loopBuffer, 4)
					endif
				endif
			endif
		
		else
			'
			'ignoring illegal token ...
			'
			Debug.forInteger "Loop Depth: ", simCounter
		endif

		if simCounter then
			lastCode = String.Empty
		else
			lastCode = code
		endif

		index = index + 1

	loop while index < String.length(codeBuffer)

	executeCode = result
end function
