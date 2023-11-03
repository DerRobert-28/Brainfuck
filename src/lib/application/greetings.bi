sub bfasmGreeting(withVersion as string)
	generalGreeting "Brainfuck Assembler", withVersion
end sub


sub bfcGreeting(withVersion as string)
	generalGreeting "Brainfuck Compiler", withVersion
end sub


sub bvmGreeting(withVersion as string)
	generalGreeting "Brainfuck Virtual Machine", withVersion
end sub


sub generalGreeting(message as string, withVersion as string)
	print
	print message + " v" + withVersion
	print "(c) 2023 by 'Der Robert'"
	print
	print
end sub
