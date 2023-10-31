Includes:
	'$include:'./bfv.bi'


Options:
	$console:only
	$noprefix
	option explicit
	option explicitarray


Constants:
	const CHAR_SPACE	= 32
	const CHAR_NBSP		= 255
	const DEST_EXT		= "bc"
	const EMPTY		= ""
	const EXT_SEP		= "."
	const FOR_READING	= "I"
	const FOR_WRITING	= "O"
	const NULL_BYTE		= 0
	const SRC_EXT		= "bfa"


GlobalVariables:
	dim shared as integer	IOresult
	dim shared as string	Token_Sep


Arrays:
	redim as string	macroCodes(0)
	redim as string	macroNames(0)


Variables:
	dim as integer				_
		currentIndex, currentLine,	_
		each,				_
		i, inFile,			_
		outFile,			_
		tokenPos,			_
		value

	dim as string				_
		bfLine, bfToken, byteCode,	_
		ch, currentName,		_
		destFile,			_
		fetchResult, fileName,		_
		srcFile,			_
		theMacro, theName


Exceptions:
	IOresult = 0
	on error goto OnException


Begin:
	Token_Sep = chr$(CHAR_SPACE)

	byteCode = EMPTY
	bfLine = EMPTY
	currentLine = 0
	fileName = trim$(command$)
	srcFile = fileName + EXT_SEP + SRC_EXT
	destFile = fileName + EXT_SEP + DEST_EXT

	print
	print "Brainfuck Assembler v" + VERSION
	print "(c) 2023 by 'Der Robert'"
	print
	print

	print "Attempt to open: " + srcFile
	inFile = freefile
	open FOR_READING, inFile, srcFile
	if IOresult then
		print "Could not find: " + srcFile
		print "Check file and try again."
		close
		system
	endif

	print "Attempt to prepare: " + destFile
	outFile = freefile
	open FOR_WRITING, outFile, destFile
	if IOresult > 0 then
		print "Could not prepare output file: " + srcFile
		print "Check file access and try again."
		close
		system
	endif

	print
	print "Writing file ..."

	do until eof(inFile)
		gosub FetchToken
		bfToken = fetchResult

		select case lcase$(bfToken)
			case "call"
				gosub FetchToken
				theName = trim$(fetchResult)
				if IOresult then
					close
					kill destFile
					print "Unexpected end of file in line"; currentLine
					system
				endif
				theMacro	= EMPTY
				currentIndex	= ubound(macroNames)
				for each = 0 to currentIndex
					if macroNames(each) = theName then
						theMacro = theMacro + Token_Sep + macroCodes(each)
					endif
				next
				bfLine = trim$(theMacro) + Token_Sep + bfLine

			case "endm"
				print "WARNING: 'endm' is only allowed with 'macro'!"
				print "         Token will be ignored!"

			case "endp"
				print "WARNING: 'endp' is only allowed with 'proc'!"
				print "         Token will be ignored!"

			case "macro", "proc"
				gosub FetchToken
				theName = trim$(fetchResult)
				if IOresult then
					close
					kill destFile
					print "Unexpected end of file in line"; currentLine
					system
				endif
				currentIndex	= ubound(macroNames)
				currentName	= trim$(macroNames(currentIndex))
				if isNotEmpty(currentName) then
					redim preserve macroCodes(0 to currentIndex + 1)
					redim preserve macroNames(0 to currentIndex + 1)
					currentIndex = currentIndex + 1
				endif
				macroNames(currentIndex) = theName
				theMacro = EMPTY
				do
					gosub FetchToken
					if IOresult then
						close
						kill destFile
						print "Unexpected end of file in line"; currentLine
						system
					endif
					if lcase$(fetchResult) = "endm" then exit do
					if lcase$(fetchResult) = "endp" then exit do
					theMacro = theMacro + Token_Sep + fetchResult
				loop
				macroCodes(currentIndex) = trim$(theMacro)

			case "st_0", "nop"
				byteCode = "0" + byteCode

			case "st_1"
				byteCode = "1" + byteCode

			case "st_2"
				byteCode = "2" + byteCode

			case "st_3"
				byteCode = "3" + byteCode

			case "st_4"
				byteCode = "4" + byteCode

			case "st_5"
				byteCode = "5" + byteCode
			case "st_6"
				byteCode = "6" + byteCode

			case "st_7", "ret"
				byteCode = "7" + byteCode

			case "st_8", "push"
				byteCode = "8" + byteCode

			case "st_9", "pop"
				byteCode = "9" + byteCode

			case "st_a", "add", "inc"
				byteCode = "A" + byteCode

			case "st_b", "dec", "sub"
				byteCode = "B" + byteCode

			case "st_c", "if", "while"
				byteCode = "C" + byteCode

			case "st_d", "loop", "loopne", "loopnz"
				byteCode = "D" + byteCode

			case "st_e", "cout", "out"
				byteCode = "E" + byteCode

			case "st_f", "cin", "in", "inp"
				byteCode = "F" + byteCode

			case else
				if left$(bfToken, 1) = ";" then
					bfLine = EMPTY
				elseif bfToken <> EMPTY then
					close
					kill destFile
					print "Error in line:"; currentLine
					print "Unrecognized token: " + bfToken
					system
				endif
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

	print
	print "Compiled successfully."
	print

	system
End


FetchToken:
	if isEmpty(bfLine) then
		line input #inFile, bfLine
		currentLine = currentLine + 1
		bfLine = trim$(bfLine)
	endif

	for i = 1 to len(bfLine)
		ch = mid$(bfLine, i, 1)
		if asc(ch) < CHAR_SPACE then mid$(bfLine, i, 1) = Token_Sep
		if asc(ch) = CHAR_NBSP then mid$(bfLine, i, 1) = Token_Sep
	next

	tokenPos = instr(1, bfLine, Token_Sep)
	if tokenPos > 0 then
		fetchResult = rtrim$(left$(bfLine, tokenPos))
		bfLine = ltrim$(mid$(bfLine, tokenPos))
	else
		fetchResult = bfLine
		bfLine = EMPTY
	endif
return


OnException:
    IOresult = err
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
