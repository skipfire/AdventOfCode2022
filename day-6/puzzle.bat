SETLOCAL EnableDelayedExpansion
ECHO OFF
for /f "Tokens=* Delims=" %%x in (D:\GitHub\AdventOfCode2022\day-6\input.txt) do set content=!content!%%x

call :strLen content contentlength
SET markersize=4
@SET /a "l1stop=%markersize%-2"
@SET /a "contentlength=%contentlength%-%markersize%+1"
for /l %%i in (1, 1, %contentlength%) do (
    ECHO i: %%i
    SET ChunkOk=1
    call :substring content %%i %markersize% _chunk
    for /l %%j in (0, 1, %l1stop%) do (
        call :substring _chunk %%j 1 c1
        @SET /a "l2stop=%markersize%-1"
        @SET /a "l2start=%%j+1"
        for /l %%k in (!l2start!, 1, !l2stop!) do (
            call :substring _chunk %%k 1 c2
            if !c1! == !c2! (
                SET ChunkOk=0
            )
        )
    )
    if !ChunkOk! == 1 (
        @set /a "result=%%i+%markersize%"
        ECHO Result: !result!
        GOTO :EOF
    )
)

exit /b
:strLen
setlocal enabledelayedexpansion

:strLen_Loop
if not "!%1:~%len%!"=="" set /A len+=1 & goto :strLen_Loop
(endlocal & set %2=%len%)
GOTO :EOF

:substring
SET %4=!%1:~%2,%3!
GOTO :EOF