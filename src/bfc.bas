'$include:'lib/application/core/versionInfo.bi'
'$include:'lib/application/core/bfcOptions.bi'
'$include:'lib/application/core/bfArrays.bi'
'$include:'lib/application/core/bf.bi'

'$include:'lib/application/fileType.bi'
'$include:'lib/application/greetings.bi'
'$include:'lib/application/macros.bi'

'$include:'lib/bfc/processIncludes.bi'
'$include:'lib/bfc/processMacros.bi'

'$include:'lib/classes/Buffer.bi'
'$include:'lib/classes/Char.bi'
'$include:'lib/classes/Exceptions.bi'
'$include:'lib/classes/File.bi'
'$include:'lib/classes/Integer.bi'
'$include:'lib/classes/String.bi'
'$include:'lib/classes/System.bi'


function Main%(cmdLine as string)
	dim as integer	outFile
	dim as string	fileName
	dim as string	tempFile1
	dim as string	currentInputFile
	dim as string	messageBuffer

	bfcGreeting With(VERSION)

	fileName = String.trim(cmdLine)
	if String.isEmpty(fileName) then
		Main = Throw(CallingSyntaxException("Calling syntax: bfc <srcFile>"))
		exit function
	endif
	
	Console.writeLine "Step 1: Processing includes ..."
	tempFile1 = fileType(fileName, "tmp.1")
	outFile = File.open(tempFile1, FileMode.ForWriting)
	result = processIncludes(outFile, fileName)
	File.close outFile

	if result then
		Invoke File.remove(tempFile1)
		Buffer messageBuffer, "Error processing includes."
		Buffer.writeLine messageBuffer, "Check source file(s) and try again."
		Main = Throw(FileProcessingException(messageBuffer))
		exit function
	endif

	Console.writeLine "Step 2: Processing macros ..."
	tempFile2 = fileType(fileName, "tmp.2")
	result = processMacros(tempFile1, tempFile2)
	
	if result then
		Invoke File.remove(tempFile1)
		Invoke File.remove(tempFile2)
		Buffer messageBuffer, "Processing macros was not successful."
		Buffer.writeLine messageBuffer, "Check source file(s) and try again."
		Main = Throw(MacroProcessingException(messageBuffer))
		exit function
	endif

end function






Constants:
	const CHAR_SPACE	= 32
	const DEST_EXT		= "bc"
	const EMPTY		= ""
	const EXT_SEP		= "."
	' const FOR_READING	= "I"
	' const FOR_WRITING	= "O"
	const NULL_BYTE		= 0
	const NUMBER_LIST	= "0123456789"
	const SRC_EXT		= "bf"
	const TEMP_EXT1		= "bc.tmp1"
	const TEMP_EXT2		= "bc.tmp2"
	const TEMP_EXT3		= "bc.tmp3"
	const TOKEN_LIST	= "+,-.<>[]"


GlobalArrays:
	redim shared as string	macroCodes(0)
	redim shared as string	macroNames(0)


GlobalVariables:
	dim shared as integer	IOresult
	dim shared as string	Token_Sep


Variables:
	dim as integer			_
		count, currentIndex,	_
		each,			_
	  	foundIndex,		_
	  	inFile, includeFile,	_
	  	outFile,		_
		result,			_
		value
	dim as string								_
		bfLine, bfToken, byteCode,					_
		currentMacro, currentName,					_
		destFile,							_
		fileName,							_
		includeLine, includeSrc,					_
		kind,								_
		push,								_
		srcFile,							_
		tempFile1, tempFile2, tempFile3, theMacro, theName, theToken


Exceptions:
	IOresult = 0
	on error goto OnException



Begin:
	Token_Sep   = chr$(CHAR_SPACE)

	byteCode    = EMPTY
	push        = EMPTY

	fileName    = trim$(command$)
	'srcFile     = fileName + EXT_SEP + SRC_EXT
	destFile    = fileName + EXT_SEP + DEST_EXT
	tempFile1   = fileName + EXT_SEP + "1"
	tempFile2   = fileName + EXT_SEP + TEMP_EXT2
	tempFile3   = fileName + EXT_SEP + TEMP_EXT3



	inFile = freefile
	open FOR_READING, inFile, tempFile1
	outFile = freefile
	open FOR_WRITING, outFile, tempFile2
	'
	'   Pre-processing macros
	'
	do until eof(inFile)
		bfToken = input$(1, inFile)

		if bfToken = chr$(34) then
			theName = EMPTY
			do
				theToken = input$(1, inFile)
				if IOresult then
					gosub CloseAndDeleteTempFiles
					print "Unexpected end of file!"
					system
				endif
				if theToken = chr$(34) then exit do
				theName = theName + theToken
			loop
			theName = trim$(theName)
			currentIndex = ubound(macroNames)
			currentName = trim$(macroNames(currentIndex))
			if isNotEmpty(currentName) then
				redim preserve macroNames(0 to currentIndex + 1)
				currentIndex = currentIndex + 1
			endif
			macroNames(currentIndex) = theName

		elseif bfToken = "(" then
			theMacro = EMPTY
			do
				theToken = input$(1, inFile)
				if IOresult then
					gosub CloseAndDeleteTempFiles
					print "Unexpected end of file!"
					system
				elseif theToken = ")" then
					exit do
				endif
				theMacro = theMacro + theToken
			loop
			theMacro = trim$(theMacro)
			currentIndex = min(ubound(macroNames), ubound(macroCodes))
			for each = 0 to currentIndex
				if macroNames(each) = theMacro then
					print #outFile, macroCodes(each);
				endif
			next

		elseif bfToken = ")" then
			print "WARNING: ')' is only allowed with '('!"
			print "         Token will be ignored!"

		elseif bfToken = "{" then
			theMacro = EMPTY
			do
				theToken = input$(1, inFile)
				if IOresult then
					gosub CloseAndDeleteTempFiles
					print "Unexpected end of file!"
					system
				elseif theToken = "{" then
					print "WARNING: Nested macros are not allowed!"
					print "         Token '{' will be ignoed!"
				elseif theToken = "}" then
					exit do
				else
					theMacro = theMacro + theToken
				endif
			loop
			theMacro = trim$(theMacro)
			currentIndex = ubound(macroCodes, 1)
			currentMacro = trim$(macroCodes(currentIndex))
			if isNotEmpty(currentMacro) then
				redim preserve macroCodes(0 to currentIndex + 1)
				currentIndex = currentIndex + 1
			endif
			macroCodes(currentIndex) = theMacro

		elseif bfToken = "}" then
			print "WARNING: '}' is only allowed with '{'!"
			print "         Token will be ignoed!"

		else
			print #outFile, bfToken;
		endif
	loop
	close

	open FOR_READING, inFile, tempFile2
	open FOR_WRITING, outFile, tempFile3
	'
	'   Interpreting numbers
	'
	do until eof(inFile)
		bfToken = input$(1, inFile)

		if instr(TOKEN_LIST, bfToken) then
			if len(push) = 1 then
				print #outFile, push;
				push = EMPTY
			elseif len(push) > 1 then
				print #outFile, mid$(push, 2);
				push = EMPTY
			endif
			push = bfToken

		elseif instr(NUMBER_LIST, bfToken) then
			count = val(bfToken)
			if(len(push) = 1) and(count = 0) then
				push = EMPTY
			else
				kind = left$(push, 1)
				push = push + string$(count, kind)
			endif

		endif
	loop

	if len(push) = 1 then
		print #outFile, push;
		push = EMPTY
	elseif len(push) > 1 then
		print #outFile, mid$(push, 2);
		push = EMPTY
	endif
	close

	open FOR_READING, inFile, tempFile3
	open FOR_WRITING, outFile, destFile
	'
	'   Compiling the code
	'
	do until eof(inFile)
		bfToken = input$(1, inFile)

		select case bfToken
			case "+": byteCode = "A" + byteCode
			case ",": byteCode = "F" + byteCode
			case "-": byteCode = "B" + byteCode
			case ".": byteCode = "E" + byteCode
			case "<": byteCode = "9" + byteCode
			case ">": byteCode = "8" + byteCode
			case "[": byteCode = "C" + byteCode
			case "]": byteCode = "D" + byteCode
		end select

		if len(byteCode) = 2 then
			print byteCode + Token_Sep;
			value = val("&H" + byteCode)
			print #outFile, chr$(value);
			byteCode = EMPTY
		endif
	loop

	if len(byteCode) = 1 then
		print "0" + byteCode + Token_Sep;
		value = val("&H0" + byteCode)
		print #outFile, chr$(value);
	endif

	print "00"
	print #outFile, chr$(NULL_BYTE);

	gosub CloseAndDeleteTempFiles

	print
	print "Compiled successfully."
	print

	system
End


OnException:
	IOresult = err
	print errorline, errormessage$
resume next


CloseAndDeleteTempFiles:
	close
	kill tempFile1
	kill tempFile2
	kill tempFile3
	IOresult = 0
return


function isEmpty%(st as string)
	isEmpty = (len(st) = 0)
end function


function isNotEmpty%(st as string)
	isNotEmpty = (len(st) > 0)
end function


function min%(first as integer, second as integer)
	if first < second then
		min = first
	else
		min = second
	endif
end function

