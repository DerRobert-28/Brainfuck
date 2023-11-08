function processNumbers%(sourceFile as string, targetFile as string)
	const		DEFAULT_COUNTER = -1
	dim as integer	currentCounter, inFile, outFile, result
	dim as string	bfToken, lastToken, sequence

	Try
		inFile = File.open(sourceFile, FileMode.ForReading)
		outFile = File.open(targetFile, FileMode.ForWriting)
	Catch result
	EndTry
	
	if result then
		processNumbers = result
		exit function
	endif

	lastToken = String.Empty
	currentCounter = DEFAULT_COUNTER

	do until File.endOf(inFile)

		Try
			bfToken = File.read(inFile, 1)
		Catch result
			if result then exit do
		EndTry

		if String.contains(NumberList, bfToken) then

			if currentCounter < 0 then currentCounter = 0
			currentCounter = currentCounter + val(bfToken)

		elseif String.contains(TokenList, bfToken) then
			
			if String.isNotEmpty(lastToken) then
				sequence = String.repeat(lastToken, abs(currentCounter))
				File.write outFile, sequence
				currentCounter = DEFAULT_COUNTER
			endif
			lastToken = bfToken

		endif
	loop

	if String.isNotEmpty(lastToken) then
		sequence = String.repeat(lastToken, abs(currentCounter))
		File.write outFile, sequence
	endif

	File.close inFile
	File.close outFile

	processNumbers = result
end function
