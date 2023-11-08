function compileFile%(sourceFile as string, targetFile as string)
	dim as integer	byteCode,		_
			currentIndex,		_
			inFile, includeFile,	_
			outFile,		_
			result
	dim as long	address,	_
			each
	dim as string	currentCode, currentLine, currentMacro, currentStream, currentToken,	_
			fetchResult,								_
			hiCode, hiMode,								_
			includeLine, includeLines,						_
			loCode, loMode, lowerToken
	
	Try
		inFile = File.open(sourceFile, FileMode.ForReading)
		outFile = File.open(targetFile, FileMode.ForWriting)
	Catch result
	EndTry

	if result then
		compileFile = result
		exit function
	endif

	'prepare with reserved byte:
	loMode = HexToken_SwitchToAsciiMode
	hiMode = HexToken_SwitchToTextMode
	File.write outFile, Char.from(255)

	currentLine = String.Empty
	currentStream = String.Empty
	do until File.endOf(inFile)
		currentToken = String.toLowerCase(fetchToken(inFile, currentLine))

		if String.startsWith(currentToken, ";") then
			currentLine = String.Empty

		elseif Strings.areEqual(currentToken, ".ascii") then
			loMode = HexToken_SwitchToAsciiMode

		elseif Strings.areEqual(currentToken, ".byte") then
			loMode = HexToken_SwitchToAsciiMode

		elseif Strings.areEqual(currentToken, ".console") then
			hiMode = HexToken_SwitchToTextMode

		elseif Strings.areEqual(currentToken, ".digit") then
			loMode = HexToken_SwitchToNumberMode

		elseif Strings.areEqual(currentToken, ".graphic") then
			hiMode = HexToken_SwitchToGraphMode

		elseif Strings.areEqual(currentToken, ".graphics") then
			hiMode = HexToken_SwitchToGraphMode

		elseif Strings.areEqual(currentToken, ".mode") then
			Try
				fetchResult = String.toLowerCase(fetchToken(inFile, currentLine))
			Catch result
			EndTry

			if String.isNotEmpty(fetchResult) then
				String.prepend fetchResult, "."
				String.prepend currentLine, fetchResult
			endif

		elseif Strings.areEqual(currentToken, ".number") then
			loMode = HexToken_SwitchToNumberMode

		elseif Strings.areEqual(currentToken, ".text") then
			hiMode = HexToken_SwitchToTextMode

		elseif Strings.areEqual(currentToken, ".video") then
			hiMode = HexToken_SwitchToGraphMode

		elseif Strings.areEqual(currentToken, "call") then
			Try
				fetchResult = fetchToken(inFile, currentLine)
			Catch result
			EndTry

			if result then
				File.closeAll
				Console.writeLine "Missing macro at 'call' token."
				exit do
			endif

			currentIndex = getMacroIndexOf(fetchResult)
			String.prepend currentLine, getMacroCode(currentIndex)

		'	pre-implementation (word-jumps with address number)
		elseif Strings.areEqual(currentToken, "jmp") then
			currentCode = mapToCode(currentToken)

			Try
		 		fetchResult = fetchToken(inFile, currentLine)
		 	Catch result
		 	EndTry

		 	if result then
		 		File.closeAll
		 		Console.writeLine "Missing label."
		 		exit do
		 	endif
			
			address = Long.fromString(fetchResult)
			String.append currentCode, dec2hex(address, 4)
			String.append currentStream, currentCode

		' elseif Strings.areEqual(currentToken, "label") then
		'  	Try
		'  		fetchResult = fetchToken(inFile, currentLine)
		'  	Catch result
		'  	EndTry

		'  	if result then
		'  		File.closeAll
		'  		Console.writeLine "Missing label name."
		'  		exit do
		'  	endif

		'  	currentIndex = addLabelName(fetchResult)
		'  	currentMacro = String.Empty

		elseif Strings.areEqual(currentToken, "macro") then
			Try
				fetchResult = fetchToken(inFile, currentLine)
			Catch result
			EndTry

			if result then
				File.closeAll
				Console.writeLine "Missing macro name."
				exit do
			endif

			currentIndex = addMacroName(fetchResult)
			currentMacro = String.Empty

			do
				Try
					fetchResult = fetchToken(inFile, currentLine)
				Catch result
				EndTry

				if result then
					File.closeAll
					Console.writeLine "Unexpected end of file."
					exit do
				endif

				lowerToken = String.toLowerCase(fetchResult)
				
				if String.startsWith(fetchResult, ";") then
					currentLine = String.Empty
				elseif Strings.areEqual(lowerToken, "endm") then
					exit do
				elseif Strings.areEqual(lowerToken, "endp") then
					exit do
				elseif Strings.areEqual(lowerToken, "macro") then
					Console.writeLine "WARNING: Nested macros are not allowed!"
					Console.writeLine "         Token 'macro' will be ignored!"
				elseif Strings.areEqual(lowerToken, "proc") then
					Console.writeLine "WARNING: Nested procedures are not allowed!"
					Console.writeLine "         Token 'proc' will be ignored!"
				else
					String.append currentMacro, String.concat(Char.Space, fetchResult)
				endif
			loop

			addMacroCode currentIndex, String.trim(currentMacro)
		
		elseif Strings.areEqual(currentToken, "proc") then
			String.prepend currentLine, "macro "

		elseif String.startsWith(currentToken, "st_") then
			if String.length(currentToken) <> 4 then
				Console.writeLine String.concat("Unrecognized token: ", currentToken)
				result = COMPILATION_ERROR
				exit do
			endif
			currentCode = HexToken_Store(String.charAt(currentToken, 3))

			if Strings.areEqual(currentCode, HexToken_SwitchToAsciiMode) then
				String.prepend currentLine, ".ascii "
			elseif Strings.areEqual(currentCode, HexToken_SwitchToGraphMode) then
				String.prepend currentLine, ".video "
			elseif Strings.areEqual(currentCode, HexToken_SwitchToNumberMode) then
				String.prepend currentLine, ".number "
			elseif Strings.areEqual(currentCode, HexToken_SwitchToTextMode) then
				String.prepend currentLine, ".text "
			else
				String.append currentStream, currentCode
				while String.length(currentStream) > 2
					currentCode = String.subStr(currentStream, 0, 2)
					byteCode = hex2dec(currentToken)
					File.write outFile, Char.from(byteCode)
					currentStream = String.subString(currentStream, 2)
				wend
			endif

		else
			currentCode = mapToCode(currentToken)
			String.append currentStream, currentCode
		endif
	loop

	if result then
		compileFile = result
		exit function
	endif

	String.append currentStream, HexToken_Return
	String.append currentStream, HexToken_NoOperation
	String.append currentStream, HexToken_NoOperation

	for each = 1 to String.length(currentStream) step 2
		loCode = String.subStr(currentStream, each - 1, 1)
		hiCode = String.subStr(currentStream, each, 1)
		byteCode = hex2Dec(String.concat(hiCode, loCode))
		File.write outFile, Char.from(byteCode)
	next

	Invoke File.seek(outFile, 0)
	currentCode = String.concat(hiMode, loMode)
	byteCode = hex2dec(currentCode)
	File.write outFile, Char.from(byteCode)

	File.close inFile
	File.close outFile

	compileFile = result
end function
