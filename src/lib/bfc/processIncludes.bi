function processIncludes%(outFile as integer, fileName as string)
	dim as integer	e
	dim as integer	inFile
	dim as integer	result
	dim as string	currentLine
	dim as string	incFile
	dim as string	theFile

	incFile = BF_SourceFile(fileName)
	Try
		inFile = File.open(incFile, FileMode.forReading)
	Catch result
	EndTry

	if result then
		processIncludes = result
		exit function
	endif
	
	do until File.endOf(inFile)
		currentLine = String.trim(File.readLine(inFile))
		
		if Strings.areEqual(String.charAt(currentLine, 0), Char.NumberSign) then

			incFile = String.trim(String.subString(currentLine, 1))
			result = 0
			
			if String.isNotEmpty(incFile) then result = processIncludes(incFile, outFile)
			if result then exit do

		elseif String.isNotEmpty(currentLine) then

			File.writeLine outFile, currentLine

		endif
	loop
	File.close inFile

	processIncludes = result
end function
