# Brainfuck 0.1

This is a little project that I wrote in QB64.
It contains three CLI tools:
- the Brainfuck Compiler "BFC.exe"
- the Brainfuck Assembler "BFASM.exe"
- the Brainfuck Interbreter "BF.exe"

## The Brainfuck Compiler
"BFC.exe" compiles your Brainfuck source code into byte code. The calling syntax is as follows: <code>bfc &lt;sourceFile&gt;</code>
\
**Important:** Do not provide a file extension, because the compiler assumes source files having ".bf" and byte code file having ".bfc".
\
Brainfuck knows 8 commands:
- ">" = goto next cell
- "<" = goto previous cell
- "+" = increment current cell
- "-" = decrement current cell
- "[" = begin a loop if current cell is not 0
- "]" = repeat loop if current cell is not 0
- "." = print out an ASCII character
- "," = read in an ASCII character

You can also provide a number, to multiply the number of executions. Following numbers will be added together.
\
Examples:
- "+7" = increment seven times
- "+0" = do not increment at all
- "-55" = decrement ten (5+5) times

## The Brainfuck Assembler
"BFASM.exe" compiles your Brainfuck Assembler code into byte code. The calling syntax is as follows: <code>bfasm &lt;sourceFile&gt;</code>
\
**Important:** Do not provide a file extension, because the assembler assumes source files having ".bfa" and byte code file having ".bfc".
\
The Brainfuck Assembler knows the following commands:
- "st_X": byte code "X", where X is a hexadecimal digit (0-9,A-F)
- "add" / "inc": increment current cell
- "cin" / "in" / "inp": read in an ASCII character
- "cout" / "out": print out an ASCII character
- "dec" / "sub": decrement current cell
- "if" / "while": begin a loop, if current cell is not 0
- "loop" / "loopne" / "loopnz": repeat loop, if current cell is not 0
- "nop": perform no operation
- "pop": goto previous cell
- "push": goto next cell
- "ret": return from subroutine

## The Brainfuck Interpreter
"BF.exe" runs your compiled Brainfuck byte code. The calling syntax is as follows: <code>bf &lt;sourceFile&gt;</code>
\
**Important:** Do not provide a file extension, because the interpreter assumes files having ".bc"
\
The code is running inside a BVM, i.e. a Brainfuck Virtual Machine, refering to JVM (Java Virtual MAchine).
