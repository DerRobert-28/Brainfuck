'$include:'./bfv.bi'


Options:
    $console:only
    $noprefix
    option explicit


Constants:
    const CHAR_SPACE = 32
    const CHAR_NBSP = 255
    const DEST_EXT = "bc"
    const EMPTY = ""
    const FOR_READING = "i"
    const FOR_WRITING = "o"
    const NULL_BYTE = 0
    const SRC_EXT = "bfa"


Globals:
    dim shared as integer   IOresult
    dim shared as string    Token_Sep


Variables:
    dim as string   bfLine
    dim as string   bfToken
    dim as string   byteCode
    dim as string   ch
    dim as integer  currentLine
    dim as string   destFile
    dim as string   fileName
    dim as integer  i
    dim as integer  inFile
    dim as integer  outFile
    dim as string   srcFile
    dim as integer  tokenPos
    dim as integer  value


Exceptions:
    IOresult = 0
    on error goto OnException


Begin:
    byteCode = EMPTY
    bfLine = EMPTY
    Token_Sep = chr$(CHAR_SPACE)
    currentLine = 0
    fileName = trim$(command$)
    srcFile = fileName + "." + SRC_EXT
    destFile = fileName + "." + DEST_EXT

    print
    print "Brainfuck Assembler 0.1"
    print "(c) 2023 by 'Der Robert'"
    print
    print

    print "Attempt to open: " + srcFile
    inFile = freefile
    open FOR_READING, inFile, srcFile
    if IOresult then
        print "Could not find: " + srcFile
        print "Check file and try again."
        close
        system
    endif

    print "Attempt to prepare: " + destFile
    outFile = freefile
    open FOR_WRITING, outFile, destFile
    if IOresult > 0 then
        print "Could not prepare output file: " + srcFile
        print "Check file access and try again."
        close
        system
    endif

    print
    print "Writing file ..."

    do until eof(inFile)

        if bfLine = EMPTY then
            line input #inFile, bfLine
            currentLine = currentLine + 1
            bfLine = trim$(bfLine)
        endif

        for i = 1 to len(bfLine)
            ch = mid$(bfLine, i, 1)
            if asc(ch) < CHAR_SPACE then mid$(bfLine, i, 1) = Token_Sep
            if asc(ch) = CHAR_NBSP then mid$(bfLine, i, 1) = Token_Sep
        next

        tokenPos = instr(1, bfLine, Token_Sep)
        if tokenPos > 0 then
            bfToken = rtrim$(left$(bfLine, tokenPos))
            bfLine = ltrim$(mid$(bfLine, tokenPos))
        else
            bfToken = bfLine
            bfLine = EMPTY
        endif

        select case lcase$(bfToken)
            case "st_0", "nop"
                byteCode = "0" + byteCode
            case "st_1"
                byteCode = "1" + byteCode
            case "st_2"
                byteCode = "2" + byteCode
            case "st_3"
                byteCode = "3" + byteCode
            case "st_4"
                byteCode = "4" + byteCode
            case "st_5"
                byteCode = "5" + byteCode
            case "st_6"
                byteCode = "6" + byteCode
            case "st_7", "ret"
                byteCode = "7" + byteCode
            case "st_8", "push"
                byteCode = "8" + byteCode
            case "st_9", "pop"
                byteCode = "9" + byteCode
            case "st_a", "add", "inc"
                byteCode = "A" + byteCode
            case "st_b", "dec", "sub"
                byteCode = "B" + byteCode
            case "st_c", "if", "while"
                byteCode = "C" + byteCode
            case "st_d", "loop", "loopne", "loopnz"
                byteCode = "D" + byteCode
            case "st_e", "cout", "out"
                byteCode = "E" + byteCode
            case "st_f", "cin", "in", "inp"
                byteCode = "F" + byteCode
            case else
                if left$(bfToken, 1) = ";" then
                    bfLine = EMPTY
                elseif bfToken <> EMPTY then
                    close
                    kill destFile
                    print "Error in line:"; currentLine
                    print "Unrecognized token: " + bfToken
                    system
                endif
        end select

        if len(byteCode) = 2 then
            print byteCode + Token_Sep;
            value = val("&H" + byteCode)
            print #outFile, chr$(value);
            byteCode = EMPTY
        endif

    loop

    if len(byteCode) = 1 then
        print "0" + byteCode + Token_Sep;
        value = val("&H0" + byteCode)
        print #outFile, chr$(value);
    endif

    print "00"
    print #outFile, chr$(NULL_BYTE);

    close

    print
    print "Compiled successfully."
    print

    system
End

OnException:
    IOresult = err
resume next

