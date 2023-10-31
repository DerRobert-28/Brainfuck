Includes:
	'$include:'./bfv.bi'


Options:
	$console:only
	$noprefix
	option explicit
	option explicitarray


Constants:
	const CHAR_SPACE	= 32
	const DEST_EXT		= "bc"
	const EMPTY		= ""
	const EXT_SEP		= "."
	const FOR_READING	= "I"
	const FOR_WRITING	= "O"
	const NULL_BYTE		= 0
	const NUMBER_LIST	= "0123456789"
	const SRC_EXT		= "bf"
	const TEMP_EXT1		= "bc.tmp1"
	const TEMP_EXT2		= "bc.tmp2"
	const TOKEN_LIST	= "+,-.<>[]"


GlobalVariables:
	dim shared as integer	IOresult
	dim shared as string	Token_Sep


Arrays:
	redim as string	macroCodes(0)
	redim as string	macroNames(0)


Variables:
	dim as integer			_
		count, currentIndex,	_
		each,			_
	  	foundIndex,		_
	  	inFile,			_
	  	outFile,		_
		value
	dim as string							_
		bfLine, bfToken, byteCode,				_
		currentMacro, currentName,				_
		destFile,						_
		fileName,						_
		kind,							_
		push,							_
		srcFile,						_
		tempFile1, tempFile2, theMacro, theName, theToken


Exceptions:
	IOresult = 0
	on error goto OnException


Begin:
	Token_Sep   = chr$(CHAR_SPACE)

	byteCode    = EMPTY
	push        = EMPTY

	fileName    = trim$(command$)
	srcFile     = fileName + EXT_SEP + SRC_EXT
	destFile    = fileName + EXT_SEP + DEST_EXT
	tempFile1   = fileName + EXT_SEP + TEMP_EXT1
	tempFile2   = fileName + EXT_SEP + TEMP_EXT2

	print
	print "Brainfuck Compiler v" + VERSION
	print "(c) 2023 by 'Der Robert'"
	print
	print

	print "Attempt to open: " + srcFile
	inFile = freefile
	open FOR_READING, inFile, srcFile
	if IOresult then
		print "Could not access: " + srcFile
		print "Check file and try again."
		close
		system
	endif

	print "Attempt to prepare: " + destFile
	outFile = freefile
	open FOR_WRITING, outFile, tempFile1
	if IOresult then
		print "Could not access output file: " + destFile
		print "Check file access and try again."
		close
		system
	endif

	print
	print "Writing file ..."
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
					print "Unexpected end of file!"
					close
					kill tempFile1
					system
				endif
				if theToken = chr$(34) then exit do
				theName = theName + theToken
			loop
			theName     = trim$(theName)
			currentIndex    = ubound(macroNames)
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
					print "Unexpected end of file!"
					close
					kill tempFile1
					system
				elseif theToken = ")" then
					exit do
				endif
				theMacro = theMacro + theToken
			loop
			theMacro    = trim$(theMacro)
			currentIndex    = min(ubound(macroNames), ubound(macroCodes))
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
					print "Unexpected end of file!"
					close
					kill tempFile1
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
			theMacro    = trim$(theMacro)
			currentIndex    = ubound(macroCodes, 1)
			currentMacro    = trim$(macroCodes(currentIndex))
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

	open FOR_READING, inFile, tempFile1
	open FOR_WRITING, outFile, tempFile2
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

	open FOR_READING, inFile, tempFile2
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

	close
	kill tempFile1
	kill tempFile2

	print
	print "Compiled successfully."
	print

	system
End


OnException:
	IOresult = err
	print errorline
resume next


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
