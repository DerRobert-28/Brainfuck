function compileFile%(sourceFile as string, targetFile as string)
	dim as integer	result
	dim as integer	inFile
	dim as integer	outFile
	dim as string	bfToken
	dim as long	each
	dim as integer	byteCode
	dim as string	hexCode
	dim as string	byteCodeBuffer

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
	String.append byteCodeBuffer, "000"

	Try
		outFile = File.open(targetFile, FileMode.ForWriting)
	Catch result
	EndTry

	if result then
		compileFile = result
		exit function
	endif

	for each = 1 to String.length(byteCodeBuffer) step 2
		hexCode = String.subStr(byteCodeBuffer, each - 1, 2)
		byteCode = hex2Dec(hexCode)
		File.write outFile, Char.from(byteCode)
	next
	File.close outFile

	compileFile = result
end function
