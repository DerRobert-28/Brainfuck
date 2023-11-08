function processIncludes%(outFile as integer, includeFile as string)
	dim as integer	inFile, result
	dim as string	currentLine, incFile

	incFile = BF_AssemblerFile(includeFile)
	Try
		inFile = File.open(incFile, FileMode.ForReading)
	Catch result
	EndTry

	if result then
		processIncludes = result
		exit function
	endif
	
	do until File.endOf(inFile)
		currentLine = String.trim(File.readLine(inFile))
		'
		'Include file with @<fileName>
		'
		if String.startsWith(currentLine, Char.AtSign) then

			incFile = String.trim(String.subString(currentLine, 1))
			result = 0

			if String.isNotEmpty(incFile) then

				result = processIncludes(outFile, incFile)
				if result then exit do
			endif

		elseif String.isNotEmpty(currentLine) then

		 	File.writeLine outFile, currentLine

		endif
	loop
	File.close inFile

	processIncludes = result
end function
