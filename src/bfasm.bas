'$include:'bfasm.bi'


function Main%(cmdLine as string)
	dim as integer	outFile, result
	dim as string	binaryFile, fileName, messageBuffer, sourceFile, tempIncludesFile

	bfasmGreeting With(VERSION)

	fileName = String.trim(cmdLine)
	if String.isEmpty(fileName) then
		Main = Throw(CallingSyntaxException("Calling syntax: bfasm <srcFile>"))
		exit function
	endif

	Console.writeLine "Step 1: Processing includes ..."
	tempIncludesFile = fileType(fileName, "temp.includes")
	outFile = File.open(tempIncludesFile, FileMode.ForWriting)
	result = processIncludes(outFile, fileName)
	File.close outFile

	Console.writeLine "Step 2: Compiling assembly code ..."
	binaryFile = BF_BinaryFile(fileName)
	result = compileFile(tempIncludesFile, binaryFile)
	Invoke File.remove(tempIncludesFile)

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
