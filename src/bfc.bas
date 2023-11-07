'$include:'bfc.bi'


function Main%(cmdLine as string)
	dim as integer	outFile, result
	dim as string	binaryFile, currentInputFile, fileName, messageBuffer
	dim as string	tempIncludesFile, tempMacrosFile, tempNumbersFile

	bfcGreeting With(VERSION)

	fileName = String.trim(cmdLine)
	if String.isEmpty(fileName) then
		Main = Throw(CallingSyntaxException("Calling syntax: bfc <srcFile>"))
		exit function
	endif
	
	Console.writeLine "Step 1: Processing includes ..."
	tempIncludesFile = fileType(fileName, "temp.includes")
	outFile = File.open(tempIncludesFile, FileMode.ForWriting)
	result = processIncludes(outFile, fileName)
	File.close outFile

	if result then
		Invoke File.remove(tempIncludesFile)
		Buffer messageBuffer, "Error processing includes."
		Buffer.writeLine messageBuffer, "Check source file(s) and try again."
		Main = Throw(FileProcessingException(messageBuffer))
		exit function
	endif

	Console.writeLine "Step 2: Processing macros ..."
	tempMacrosFile = fileType(fileName, "temp.macros")
	result = processMacros(tempIncludesFile, tempMacrosFile)
	Invoke File.remove(tempIncludesFile)

	if result then
		Invoke File.remove(tempMacrosFile)
		Buffer messageBuffer, "Processing macros was not successful."
		Buffer.writeLine messageBuffer, "Check source file(s) and try again."
		Main = Throw(MacroProcessingException(messageBuffer))
		exit function
	endif

	Console.writeLine "Step 3: Processing numbers ..."
	tempNumbersFile = fileType(fileName, "temp.numbers")
	result = processNumbers(tempMacrosFile, tempNumbersFile)
	Invoke File.remove(tempMacrosFile)
	
	if result then
		Invoke File.remove(tempNumbersFile)
		Buffer messageBuffer, "Processing numbers was not successful."
		Buffer.writeLine messageBuffer, "Check source file(s) and try again."
		Main = Throw(NumberProcessingException(messageBuffer))
		exit function
	endif

	Console.writeLine "Step 4: Compiling source code ..."
	binaryFile = BF_BinaryFile(fileName)
	result = compileFile(tempNumbersFile, binaryFile)
	Invoke File.remove(tempNumbersFile)
	
	if result then
		Invoke File.remove(binaryFile)
		Buffer messageBuffer, "Compiling file was not successful."
		Buffer.writeLine messageBuffer, "Check source file(s) and try again."
		Main = Throw(CompilerException(messageBuffer))
		exit function
	endif

	Console.newLine
	Console.writeLine "Compiled successfully."
	Console.newLine

	Main = COMPILED_SUCCESSFULLY
end function
