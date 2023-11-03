function processMacros%(sourceFile as string, targetFile as string)
	dim as integer	inFile
	dim as integer	outFile
	dim as integer	result
	dim as string	bfToken
	dim as string	macroName
	dim as string	macroToken
	dim as string	macroCode
	dim as integer	currentIndex
	dim as integer	lastMacroIndex

	Try
		inFile = File.open(sourceFile, FileMode.ForReading)
		outFile = File.open(targetFile, FileMode.ForWriting)
	Catch result
	EndTry

	if result then
		processMacros = result
		exit function
	endif
	
	lastMacroIndex = 0

	do until File.endOf(inFile)
		bfToken = File.read(inFile, 1)

		'
		'Declare macro with "..."
		'
		if Char.equals(bfToken, 34) then
			macroName = String.Empty
			do
				Try
					macroToken = File.read(inFile, 1)
				Catch result
				EndTry
				if result then
					Console.writeLine "Unexpected end of file!"
					exit do
				elseif Char.equals(macroToken, 34) then
					exit do
				endif
				String.append macroName, macroToken
			loop
			if result then exit do
			
			currentIndex = addMacroName(macroName)
			if currentIndex >= 0 then lastMacroIndex = currentIndex
		'
		'Call macro with (...)
		'
		elseif Char.equals(bfToken, 40) then
			macroName = String.Empty
			do
				Try
					macroToken = File.read(inFile, 1)
				Catch result
				EndTry
				if result then
					Console.writeLine "Unexpected end of file!"
					exit do
				elseif Char.equals(macroToken, 41) then
					exit do
				endif
				String.append macroName, macroToken
			loop
			if result then exit do

			currentIndex = getMacroIndexOf(macroName)
			File.write outFile, getMacroCode(currentIndex)
		
		'
		'Wrongly placed ')' token will be ignored:
		'
		elseif Char.equals(bfToken, 41) then
			Console.writeLine "WARNING: ')' is only allowed with '('!"
			Console.writeLine "         Token will be ignored!"
		'
		'Define macro with {...}
		'
		elseif Char.equals(bfToken, 123) then
			macroCode = String.Empty

			do
				Try
					macroToken = File.read(inFile, 1)
				Catch result
				EndTry

				if result then
					Console.writeLine "Unexpected end of file!"
					exit do
				elseif Char.equals(macroToken, 123) then
					Console.writeLine "WARNING: Nested macros are not allowed!"
					Console.writeLine "         Token '{' will be ignoed!"
				elseif Char.equals(macroToken, 125) then
					exit do
				else
					String.append macroCode, macroToken
				endif
			loop
			if result then exit do

			addMacroCode lastMacroIndex, macroCode
			lastMacroIndex = getLastMacroIndex
		'
		'Wrongly placed '}' token will be ignored:
		'
		elseif Char.equals(bfToken, 125) then
			Console.writeLine "WARNING: '}' is only allowed with '{'!"
			Console.writeLine "         Token will be ignored!"
		'
		'Miscellaneous token:
		'
		else
			File.write outFile, bfToken
		endif
	loop

	Invoke File.close(inFile)
	Invoke File.close(outFile)

	processMacros = result
end function
