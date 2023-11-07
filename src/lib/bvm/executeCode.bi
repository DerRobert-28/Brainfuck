function executeCode%(codeBuffer as string, bvmDataPtr as long)
	dim as integer		result
	dim as unsigned long	index
	dim as string		lastCode
	dim as long		nextIndex
	dim as integer		loopCounter
	dim as integer		simCounter
	dim as string		code
	dim as string		theKey
	dim as string		indexStr
	dim as string		nextCode
	dim as string		stackBuffer
	dim as integer		value
	dim as string		loMode, hiMode
	dim as integer		xPos, yPos
	
	result = 0
	lastCode = String.Empty
	stackBuffer = String.Empty
	bvmDataPtr = 0
	xPos = 0
	yPos = 0

	do
		code = String.charAt(codeBuffer, index)
		if Both(simCounter = 0, Strings.areEqual(code, HexToken_InputCell)) then
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

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_MinusOne)) then
			bvmData(bvmDataPtr) = bvmData(bvmDataPtr) - 1

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_NextCell)) then
			if bvmDataPtr >= ubound(bvmData) then
				bvmDataPtr = 0
			else
				bvmDataPtr = bvmDataPtr + 1
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_NoOperation)) then
			if Strings.areEqual(code, lastCode) then
				result = NORMAL_TERMINATION
				exit do
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_OutputCell)) then
			value = bvmData(bvmDataPtr) and 255
			if Strings.areEqual(hiMode, HexToken_SwitchToGraphMode) then
				teleTypePixel xPos, yPos, value
			elseif Strings.areEqual(loMode, HexToken_SwitchToNumberMode) then
				Console.write Integer.toString(value)
			else
				Console.write Char.from(value)
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_PlusOne)) then
			bvmData(bvmDataPtr) = bvmData(bvmDataPtr) + 1

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_PrevCell)) then
			if bvmDataPtr < 1 then
				bvmDataPtr = ubound(bvmData)
			else
				bvmDataPtr = bvmDataPtr - 1
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_Return)) then
			if String.isEmpty(stackBuffer) then
				result = NORMAL_RETURN
				exit do
			else
				indexStr = String.subStr(stackBuffer, 0, 4)
				index = Long.fromPackedString(indexStr) - 1
				stackBuffer = String.subString(stackBuffer, 4)
			endif

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_SwitchToAsciiMode)) then
			loMode = HexToken_SwitchToAsciiMode

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_SwitchToGraphMode)) then
			hiMode = HexToken_SwitchToGraphMode
			Console.clear
			xPos = 0
			yPos = 0

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_SwitchToNumberMode)) then
			loMode = HexToken_SwitchToNumberMode

		elseif Both(simCounter = 0, Strings.areEqual(code, HexToken_SwitchToTextMode)) then
			hiMode = HexToken_SwitchToTextMode
			Console.clear
			xPos = 0
			yPos = 0

		elseif Strings.areEqual(code, HexToken_BeginLoop) then
			value = bvmData(bvmDataPtr) and 255
			if(simCounter > 0) or(value = 0) then
				simCounter = simCounter + 1
			else
				indexStr = Long.toPackedString(index)
				String.prepend stackBuffer, indexStr
			endif

		elseif Strings.areEqual(code, HexToken_EndLoop) then
			if simCounter > 1 then
				simCounter = simCounter - 1
			else
				value = bvmData(bvmDataPtr) and 255
				if value then
					if String.isEmpty(stackBuffer) then
						result = value
						exit do
					else
						indexStr = String.subStr(stackBuffer, 0, 4)
						index = Long.fromPackedString(indexStr) - 1
						stackBuffer = String.subString(stackBuffer, 4)
					endif
				endif
			endif
			
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
