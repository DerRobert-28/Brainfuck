function compileFile%(sourceFile as string, targetFile as string)
	dim as integer	byteCode,	_
			inFile,		_
			outFile,	_
			result
	dim as long	each
	dim as string	bfToken, byteCodeBuffer,	_
			currentCode,			_
			loCode,				_
			hiCode

	Try
		inFile = File.open(sourceFile, FileMode.ForReading)
	Catch result
	EndTry

	if result then
		compileFile = result
		exit function
	endif

	byteCodeBuffer = String.Empty
	do until File.endOf(inFile)
		Try
			bfToken = File.read(inFile, 1)
			String.append byteCodeBuffer, mapToCode(bfToken)
		Catch result
			if result then exit do
		EndTry
	loop
	File.close inFile
	
	if result then
		compileFile = result
		exit function
	endif

	String.append byteCodeBuffer, HexToken_Return
	String.append byteCodeBuffer, HexToken_NoOperation
	String.append byteCodeBuffer, HexToken_NoOperation

	Try
		outFile = File.open(targetFile, FileMode.ForWriting)
	Catch result
	EndTry

	if result then
		compileFile = result
		exit function
	endif

	'prepare with reserved byte:
	currentCode = String.concat(HexToken_SwitchToTextMode, HexToken_SwitchToAsciiMode)
	byteCode = hex2dec(currentCode)
	File.write outFile, Char.from(byteCode)
	
	for each = 1 to String.length(byteCodeBuffer) step 2
		loCode = String.subStr(byteCodeBuffer, each - 1, 1)
		hiCode = String.subStr(byteCodeBuffer, each, 1)
		byteCode = hex2Dec(String.concat(hiCode, loCode))
		File.write outFile, Char.from(byteCode)
	next
	File.close outFile

	compileFile = result
end function
