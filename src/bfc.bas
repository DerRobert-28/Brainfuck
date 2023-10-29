Options:
    $console:only
    $noprefix
    option explicit


Constants:
    const CHAR_SPACE = 32
    const DEST_EXT = "bc"
    const EMPTY = ""
    const EXT_SEP = "."
    const FOR_READING = "i"
    const FOR_WRITING = "o"
    const NULL_BYTE = 0
    const NUMBER_LIST = "0123456789"
    const SRC_EXT = "bf"
    const TEMP_EXT = "bc.tmp"
    const TOKEN_LIST = "><+-[].,"


Globals:
    dim shared as integer   IOresult
    dim shared as string    Token_Sep


Variables:
    dim as string   bfToken
    dim as string   byteCode
    dim as integer  count
    dim as string   destFile
    dim as string   fileName
    dim as integer  inFile
    dim as string   kind
    dim as integer  outFile
    dim as string   push
    dim as string   srcFile
    dim as string   tempFile
    dim as integer  value


Exceptions:
    IOresult = 0
    on error goto OnException


Begin:
    byteCode = EMPTY
    push = EMPTY
    Token_Sep = chr$(CHAR_SPACE)

    fileName = trim$(command$)
    srcFile = fileName + EXT_SEP + SRC_EXT
    destFile = fileName + EXT_SEP + DEST_EXT
    tempFile = fileName + EXT_SEP + TEMP_EXT

    print
    print "Brainfuck Compiler 0.1"
    print "(c) 2023 by 'Der Robert'"
    print
    print

    print "Attempt to open: " + srcFile
    inFile = freefile
    open FOR_READING, inFile, srcFile
    if IOresult then
        print "Could not access: " + srcFile
        print "Check file and try again."
        close
        system
    endif

    print "Attempt to prepare: " + destFile
    outFile = freefile
    open FOR_WRITING, outFile, tempFile
    if IOresult then
        print "Could not access output file: " + destFile
        print "Check file access and try again."
        close
        system
    endif

    print
    print "Writing file ..."

    do until eof(inFile)

        bfToken = input$(1, inFile)

        if instr(TOKEN_LIST, bfToken) then

            if len(push) = 1 then
                print #outFile, push;
                push = EMPTY
            elseif len(push) > 1 then
                print #outFile, mid$(push, 2);
                push = EMPTY
            endif

            push = bfToken

        elseif instr(NUMBER_LIST, bfToken) then

            count = val(bfToken)
            if(len(push) = 1) and(count = 0) then
                push$ = EMPTY
            else
                kind = left$(push, 1)
                push = push + string$(count, kind)
            endif

        endif

    loop

    if len(push) = 1 then
        print #outFile, push;
        push = EMPTY
    elseif len(push) > 1 then
        print #outFile, mid$(push, 2);
        push = EMPTY
    endif

    close

    open FOR_READING, inFile, tempFile

    open FOR_WRITING, outFile, destFile

    do until eof(inFile)

        bfToken = input$(1, inFile)

        select case bfToken
            case ">": byteCode = "8" + byteCode
            case "<": byteCode = "9" + byteCode
            case "+": byteCode = "A" + byteCode
            case "-": byteCode = "B" + byteCode
            case "[": byteCode = "C" + byteCode
            case "]": byteCode = "D" + byteCode
            case ".": byteCode = "E" + byteCode
            case ",": byteCode = "F" + byteCode
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
    kill tempFile

    print
    print "Compiled successfully."
    print

    system
End

OnException:
    IOresult = err
resume next

