Includes:
    '$include:'./bfv.bi'


Options:
    $noprefix
    option explicit
    option explicitarray


Constants:
    const BF_DEC        = 11    'B
    const BF_EXT        = "bc"
    const BF_IF     = 12    'C
    const BF_IN     = 15    'F
    const BF_INC        = 10    'A
    const BF_LOOP       = 13    'D
    const BF_NOP        = 0 '0
    const BF_OUT        = 14    'E
    const BF_POP        = 9 '9
    const BF_PUSH       = 8 '8
    const BF_RET        = 7 '7
    const BF_TERM       = "00"
    const EMPTY     = ""
    const EXT_SEP       = "."
    const FOR_READING   = "I"
    const RESULT_NOP    = -1
    const RESULT_RET    = -8


GlobalVariables:
    dim shared as integer   bvmData(0 to 262143)    '256k of data memory
    dim shared as long  bvmDataPtr
    dim shared as long  bvmStack(0 to 65535)    '64k of stack memory
    dim shared as long  bvmStackPtr
    dim shared as integer   IOresult


Variables:
    dim as string               _
        bfFile, bvmCode, byteCode,  _
        fileName
    dim as integer      _
        hi,     _
        inFile,     _
        lo,     _
        result,     _
        value


Exceptions:
    IOresult = 0
    on error goto OnException


Begin:
    bvmCode = EMPTY
    fileName = trim$(command$)
    bfFile = fileName + EXT_SEP + BF_EXT

    title "BVM v" + VERSION
    locate, , 1
    print
    print "Brainfuck Virtual Machine v" + VERSION
    print "(c) 2023 by 'Der Robert'"
    print
    print

    print "Attempt to open: " + bfFile

    inFile = freefile
    open FOR_READING, inFile, bfFile
    if IOresult then
        print "Could not access: " + bfFile
        print "Check file and try again."
        close
        system
    endif

    do until eof(inFile)
        byteCode = input$(1, inFile)
        value = asc(byteCode)

        lo = value and 15
        hi = (value \ 16) and 15

        bvmCode = bvmCode + hex$(lo) + hex$(hi)
    loop
    close

    print "Executing ..."
    print
    bvmDataPtr = lbound(bvmData)
    bvmStackPtr = lbound(bvmStack)

    do
        result = bvm(bvmCode)
        if result = RESULT_NOP then exit do
        if result = RESULT_RET then exit do
    loop

    if pos(0) > 1 then print
    print
    print "Programme terminated with code: " + ltrim$(str$(result))
    print "> code '-1' means 'normal termination'"
    print "> code '-8' means 'normal return'"
    print
    print
    print "Hit any key to quit ..."
    while inkey$ = ""
    wend
    system
End


OnException:
    IOresult = err
resume next


function bvm%(theCode as string)
    dim as byte openLoops
    dim as integer  result, value
    dim as string   bvmCode, byteCode, currentKey, loopByte, loopCode

    bvmCode = theCode
    result = 0

    do
        if isEmpty(bvmCode) then exit do

        if left$(bvmCode, len(BF_TERM)) = BF_TERM then
            result = RESULT_NOP
            exit do
        endif

        byteCode = left$(bvmCode, 1)
        bvmCode = mid$(bvmCode, 2)
        
        result = val("&H" + ucase$(byteCode))

        select case result
            case BF_DEC
                bvmDecData

            case BF_IF
                loopCode = empty
                openLoops = 1
                do
                    loopByte = ucase$(left$(bvmCode, 1))
                    bvmCode = mid$(bvmCode, 2)

                    if loopByte = hex$(BF_IF) then openLoops = openLoops + 1
                    if loopByte = hex$(BF_LOOP) then openLoops = openLoops - 1
                    if openLoops < 1 then exit do

                    loopCode = loopCode + loopByte
                loop
                do
                    value = bvmGetData
                    if value = 0 then exit do
                    result = bvm(loopCode)
                loop

            case BF_IN
                do
                    currentKey = inkey$
                loop while isEmpty(currentKey)
                value = asc(right$(currentKey, 1))
                bvmSetData value

            case BF_INC
                bvmIncData

            case BF_LOOP
                exit do

            case BF_NOP
                'NOP

            case BF_OUT
                print chr$(bvmGetData%);

            case BF_POP
                bvmPopData

            case BF_PUSH
                bvmPushData

            case BF_RET
                result = RESULT_RET
                exit do

            'case else
            '   if pos(0) > 1 then print
            '   print "Illegal bytecode: " + hex$(result%)
            '   isRunning = 0

        end select
    loop

    bvm = result%
end function


sub bvmDecData
    bvmData(bvmDataPtr) = (bvmData(bvmDataPtr) - 1) and 255
end sub


function bvmGetData%()
    bvmGetData = bvmData(bvmDataPtr) and 255
end function


sub bvmIncData
    bvmData(bvmDataPtr) = (bvmData(bvmDataPtr) + 1) and 255
end sub


sub bvmPopData()
    if bvmDataPtr = lbound(bvmData) then
        bvmDataPtr = ubound(bvmData)
    else
        bvmDataPtr = bvmDataPtr - 1
    endif
end sub


function bvmPopStack%()
    if bvmStackPtr = lbound(bvmStack) then
        bvmStackPtr = ubound(bvmStack)
    else
        bvmStackPtr = bvmStackPtr - 1
    endif
    bvmPopStack = bvmStack(bvmStackPtr)
end function


sub bvmPushData
    if bvmDataPtr = ubound(bvmData) then
        bvmDataPtr = lbound(bvmData)
    else
        bvmDataPtr = bvmDataPtr + 1
    endif
end sub


sub bvmPushStack(stack as integer)
    bvmStack(bvmStackPtr) = stack and 255
    if bvmStackPtr = ubound(bvmStack) then
        bvmStackPtr = lbound(bvmStack)
    else
        bvmStackPtr = bvmStackPtr + 1
    endif
end sub


sub bvmSetData(value%)
    bvmData(bvmDataPtr) = value% and 255
end sub


function isEmpty%(st as string)
    isEmpty = (len(st) = 0)
end function


function reverse$(st as string)
    dim as integer  i
    dim as string   result
    :
    result = EMPTY
    for i = 1 to len(st)
        result = mid$(st, i, 1) + result
    next
    :
    reverse = result
end function
