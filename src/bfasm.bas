'$include:'bfasm.bi'

function Main%(cmdLine as string)
	dim as integer	result
	dim as string	binaryFile, fileName, sourceFile

	bfasmGreeting With(VERSION)

	fileName = String.trim(cmdLine)
	if String.isEmpty(fileName) then
		Main = Throw(CallingSyntaxException("Calling syntax: bfasm <srcFile>"))
		exit function
	endif

	Console.writeLine "Compiling assembly code ..."
	sourceFile = BF_AssemblerFile(fileName)
	binaryFile = BF_BinaryFile(fileName)
	result = compileFile(sourceFile, binaryFile)

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
