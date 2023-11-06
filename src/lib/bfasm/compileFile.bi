function compileFile%(sourceFile as string, targetFile as string)
	dim as integer	byteCode,		_
			currentIndex,		_
			inFile, includeFile,	_
			outFile,		_
			result
	dim as long	each
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

		elseif Strings.areEqual(currentToken, "include") then
			Try
				fetchResult = fetchToken(inFile, currentLine)
			Catch result
			EndTry

			if result then
				File.closeAll
				Console.writeLine "Missing file name at 'include' token."
				exit do
			endif

			Try
				includeFile = File.open(BF_AssemblerFile(fetchResult), FileMode.ForReading)
			Catch result
			EndTry

			if result then
				File.closeAll
				Console.writeLine String.concat("Could not include file: ", fetchResult)
				exit do
			endif

			includeLines = String.Empty
			do until File.endOf(includeFile)
				includeLine = File.readLine(includeFile)
				String.append includeLines, String.concat(includeLine, Char.Space)
			loop
			File.close includeFile

			String.prepend currentLine, includeLines
			
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







' Constants:
' 	const CHAR_SPACE	= 32
' 	const CHAR_NBSP		= 255
' 	const DEST_EXT		= "bc"
' 	const EMPTY		= ""
' 	const EXT_SEP		= "."
' 	const FOR_READING	= "I"
' 	const FOR_WRITING	= "O"
' 	const NULL_BYTE		= 0
' 	const SRC_EXT		= "bfa"


' GlobalVariables:
' 	dim shared as integer	IOresult
' 	dim shared as string	Token_Sep


' Arrays:
' 	redim as string	macroCodes(0)
' 	redim as string	macroNames(0)


' Variables:
' 	dim as integer				_
' 		currentIndex, currentLine,	_
' 		each,				_
' 		i, inFile, includeFile,		_
' 		outFile,			_
' 		tokenPos,			_
' 		value

' 	dim as string					_
' 		bfLine, bfToken, byteCode,		_
' 		ch, currentName,			_
' 		destFile,				_
' 		fetchResult, fileName,			_
' 		includeLine, includeResult, includeSrc,	_
' 		srcFile,				_
' 		theMacro, theName


' Exceptions:
' 	IOresult = 0
' 	on error goto OnException


' Begin:
' 	Token_Sep = chr$(CHAR_SPACE)

' 	byteCode = EMPTY
' 	bfLine = EMPTY
' 	currentLine = 0
' 	fileName = trim$(command$)
' 	srcFile = fileName + EXT_SEP + SRC_EXT
' 	destFile = fileName + EXT_SEP + DEST_EXT

' 	print
' 	print "Brainfuck Assembler v" + VERSION
' 	print "(c) 2023 by 'Der Robert'"
' 	print
' 	print

' 	print "Attempt to open: " + srcFile
' 	inFile = freefile
' 	open FOR_READING, inFile, srcFile
' 	if IOresult then
' 		print "Could not find: " + srcFile
' 		print "Check file and try again."
' 		close
' 		system
' 	endif

' 	print "Attempt to prepare: " + destFile
' 	outFile = freefile
' 	open FOR_WRITING, outFile, destFile
' 	if IOresult > 0 then
' 		print "Could not prepare output file: " + srcFile
' 		print "Check file access and try again."
' 		close
' 		system
' 	endif

' 	print
' 	print "Writing file ..."

' 	do until eof(inFile)
' 		gosub FetchToken
' 		bfToken = fetchResult

' 		select case lcase$(bfToken)
' 			case "call"
' 				gosub FetchToken
' 				theName = trim$(fetchResult)
' 				if IOresult then
' 					close
' 					kill destFile
' 					print "Error in line:"; currentLine
' 					print "Unexpected end of file."
' 					system
' 				endif
' 				theMacro = EMPTY
' 				currentIndex = ubound(macroNames)
' 				for each = 0 to currentIndex
' 					if macroNames(each) = theName then
' 						theMacro = theMacro + Token_Sep + macroCodes(each)
' 					endif
' 				next
' 				bfLine = trim$(theMacro) + Token_Sep + bfLine

' 			case "endm"
' 				print "WARNING: 'endm' is only allowed with 'macro'!"
' 				print "         Token will be ignored!"

' 			case "endp"
' 				print "WARNING: 'endp' is only allowed with 'proc'!"
' 				print "         Token will be ignored!"

' 			case "include"
' 				gosub FetchToken
' 				if IOresult then
' 					close
' 					kill destFile
' 					print "Error in line:"; currentLine
' 					print "Unexpected end of file."
' 					system
' 				endif
' 				includeSrc = fetchResult + EXT_SEP + SRC_EXT
' 				print "Including: " + includeSrc
' 				includeFile = freefile
' 				open FOR_READING, includeFile, includeSrc
' 				if IOresult then
' 					close
' 					kill destFile
' 					print "Error in line:"; currentLine
' 					print "File not found: " + includeSrc
' 					system
' 				endif
' 				includeResult = EMPTY
' 				do until eof(includeFile)
' 					line input #includeFile, includeLine
' 					includeResult = includeResult + Token_Sep + includeLine
' 				loop
' 				close includeFile
' 				bfLine = trim$(includeResult) + Token_Sep + bfLine

' 			case "macro", "proc"
' 				gosub FetchToken
' 				theName = trim$(fetchResult)
' 				if IOresult then
' 					close
' 					kill destFile
' 					print "Error in line:"; currentLine
' 					print "Unexpected end of file."
' 					system
' 				endif
' 				currentIndex	= ubound(macroNames)
' 				currentName	= trim$(macroNames(currentIndex))
' 				if isNotEmpty(currentName) then
' 					redim preserve macroCodes(0 to currentIndex + 1)
' 					redim preserve macroNames(0 to currentIndex + 1)
' 					currentIndex = currentIndex + 1
' 				endif
' 				macroNames(currentIndex) = theName
' 				theMacro = EMPTY
' 				do
' 					gosub FetchToken
' 					if IOresult then
' 						close
' 						kill destFile
' 						print "Error in line:"; currentLine
' 						print "Unexpected end of file."
' 						system
' 					endif
' 					if lcase$(fetchResult) = "endm" then exit do
' 					if lcase$(fetchResult) = "endp" then exit do
' 					theMacro = theMacro + Token_Sep + fetchResult
' 				loop
' 				macroCodes(currentIndex) = trim$(theMacro)

' 			case "st_0", "nop"
' 				byteCode = "0" + byteCode

' 			case "st_1"
' 				byteCode = "1" + byteCode

' 			case "st_2"
' 				byteCode = "2" + byteCode

' 			case "st_3"
' 				byteCode = "3" + byteCode

' 			case "st_4"
' 				byteCode = "4" + byteCode

' 			case "st_5"
' 				byteCode = "5" + byteCode
' 			case "st_6"
' 				byteCode = "6" + byteCode

' 			case "st_7", "ret"
' 				byteCode = "7" + byteCode

' 			case "st_8", "push"
' 				byteCode = "8" + byteCode

' 			case "st_9", "pop"
' 				byteCode = "9" + byteCode

' 			case "st_a", "add", "inc"
' 				byteCode = "A" + byteCode

' 			case "st_b", "dec", "sub"
' 				byteCode = "B" + byteCode

' 			case "st_c", "if", "while"
' 				byteCode = "C" + byteCode

' 			case "st_d", "loop", "loopne", "loopnz"
' 				byteCode = "D" + byteCode

' 			case "st_e", "cout", "out"
' 				byteCode = "E" + byteCode

' 			case "st_f", "cin", "in", "inp"
' 				byteCode = "F" + byteCode

' 			case else
' 				if left$(bfToken, 1) = ";" then
' 					bfLine = EMPTY
' 				elseif bfToken <> EMPTY then
' 					close
' 					kill destFile
' 					print "Error in line:"; currentLine
' 					print "Unrecognized token: " + bfToken
' 					system
' 				endif
' 		end select

' 		if len(byteCode) = 2 then
' 			print byteCode + Token_Sep;
' 			value = val("&H" + byteCode)
' 			print #outFile, chr$(value);
' 			byteCode = EMPTY
' 		endif

' 	loop

' 	if len(byteCode) = 1 then
' 		print "0" + byteCode + Token_Sep;
' 		value = val("&H0" + byteCode)
' 		print #outFile, chr$(value);
' 	endif

' 	print "00"
' 	print #outFile, chr$(NULL_BYTE);
' 	close

' 	print
' 	print "Compiled successfully."
' 	print

' 	system
' End


' FetchToken:
' 	if isEmpty(bfLine) then
' 		line input #inFile, bfLine
' 		currentLine = currentLine + 1
' 		bfLine = trim$(bfLine)
' 	endif

' 	for i = 1 to len(bfLine)
' 		ch = mid$(bfLine, i, 1)
' 		if asc(ch) < CHAR_SPACE then mid$(bfLine, i, 1) = Token_Sep
' 		if asc(ch) = CHAR_NBSP then mid$(bfLine, i, 1) = Token_Sep
' 	next

' 	tokenPos = instr(1, bfLine, Token_Sep)
' 	if tokenPos > 0 then
' 		fetchResult = rtrim$(left$(bfLine, tokenPos))
' 		bfLine = ltrim$(mid$(bfLine, tokenPos))
' 	else
' 		fetchResult = bfLine
' 		bfLine = EMPTY
' 	endif
' return


' OnException:
'     IOresult = err
' resume next


' function isEmpty%(st as string)
' 	isEmpty = (len(st) = 0)
' end function


' function isNotEmpty%(st as string)
' 	isNotEmpty = (len(st) > 0)
' end function


' function min%(first as integer, second as integer)
' 	if first < second then
' 		min = first
' 	else
' 		min = second
' 	endif
' end function

' 				gosub FetchToken
' 				theName = trim$(fetchResult)
' 				if IOresult then
' 					close
' 					kill destFile
' 					print "Error in line:"; currentLine
' 					print "Unexpected end of file."
' 					system
' 				endif
' 				theMacro = EMPTY
' 				currentIndex = ubound(macroNames)
' 				for each = 0 to currentIndex
' 					if macroNames(each) = theName then
' 						theMacro = theMacro + Token_Sep + macroCodes(each)
' 					endif
' 				next
' 				bfLine = trim$(theMacro) + Token_Sep + bfLine
