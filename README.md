# Brainfuck 0.4

This is a little project that I wrote in QB64.
It contains three CLI tools:

- the Brainfuck Compiler "BFC.exe"
- the Brainfuck Assembler "BFASM.exe"
- the Brainfuck Interbreter "BF.exe"

## The Brainfuck Compiler

"BFC.exe" compiles your Brainfuck source code into byte code.
The calling syntax is as follows: ```bfc <sourceFile>```
\
**Important:** Do not provide a file extension, because the compiler assumes source files having ".bf" and byte code file having ".bfc".
\
\
Before compiling the commands,
the Brainfuck pre-processor will be executed:

- **#**&lt;*file*&gt; = Include another Brainfuck source code.
- **"**&lt;*name*&gt;**"** = Define a macro called *name*.
- **(**&lt;*name*&gt;**)** = Call macro by its *name*.
- **{**&lt;*code*&gt;**}** = Provide the *code* linked to a macro.

Includes cannot be nested,
i.e. includes in include files will not be processed.
\
Also,
the include command must be the only or the last command in a line!
\
\
The macros will not be called like procedures,
but the code will be inserted as it is.
\
Macros can also be defined multiple times,
therefore multiple codes can be saved,
\
and therefore multiple codes will be inserted.
\
\
Brainfuck itself knows the following commands:

- "&gt;" = goto next cell
- "&lt;" = goto previous cell
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

"BFASM.exe" compiles your Brainfuck Assembler code into byte code.
The calling syntax is as follows: ```bfasm <sourceFile>```
\
**Important:** Do not provide a file extension, because the assembler assumes source files having ".bfa" and byte code file having ".bfc".
\
\
The Brainfuck Assembler knows the following pseudo-commands:

- "**;**": comment line
- "**@**&lt;*file*&gt;": include another assembler file
- "**.mode &lt;*mode*&gt;**": config one of the display modes:
  - "**ascii**" / "**byte**": input and output characters
  - "**digit**" / "**number**": input and output numbers
  - "**console**" / "**text**": input and output text
  - "**graphic**(**s**)" / "**video**": input and output pixels
- "**.ascii**": shortcut for "**.mode ascii**"
- "**.byte**": shortcut for "**.mode byte**"
- "**.console**": shortcut for "**.mode console**"
- "**.digit**": shortcut for "**.mode digit**"
- "**.graphic**": shortcut for "**.mode graphic**"
- "**.graphics**": shortcut for "**.mode graphics**"
- "**.text**": shortcut for "**.mode text**"
- "**.video**": shortcut for "**.mode video**"

\
The Brainfuck Assembler knows the following commands:

- "**add**" / "**inc**": increment current cell
- "**call**": insert macro code; the following token is used as the name
- "**cin**" / "**in**" / "**inp**": read in ASCII character
- "**cout**" / "**out**": print out ASCII character
- "**dec**" / "**sub**": decrement current cell
- "**endm**" / "**endp**": end of a macro definition
- "**if**" / "**while**": begin a loop, if current cell is not 0
- "**loop**" / "**loopne**" / "**loopnz**": repeat loop, if current cell is not 0
- "**macro** &lt;*name*&gt;" / "**proc** &lt;*name*&gt;": define a macro called *name*
- "**nop**": perform no operation
- "**pop**": goto previous cell
- "**push**": goto next cell
- "**ret**": return from subroutine
- "**st_X**": store byte code "**X**", where **X** is a hexadecimal digit (0-9,A-F)

## The Brainfuck Interpreter

"BF.exe" runs your compiled Brainfuck byte code.
The calling syntax is as follows: ```bf <sourceFile>```
\
**Important:** Do not provide a file extension, because the interpreter assumes files having ".bfc"
\
\
The code is running inside a BVM,
i.e. a Brainfuck Virtual Machine,
refering to JVM (Java Virtual Machine).
