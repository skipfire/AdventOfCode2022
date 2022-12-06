SETLOCAL EnableDelayedExpansion
ECHO OFF
for /f "Tokens=* Delims=" %%x in (D:\GitHub\AdventOfCode2022\day-6\input.txt) do set content=!content!%%x
call :strLen content contentlength
for /l %%i in (1, 1, %contentlength%) do (
    REM SET _chunk=!content:~%i%,4!
    call :substring content %%i 4 _chunk
    call :substring _chunk 0 1 c1
    call :substring _chunk 1 1 c2
    call :substring _chunk 2 1 c3
    call :substring _chunk 3 1 c4
    ECHO %%i
    if NOT !c1! == !c2! (
        if NOT !c1! == !c3! (
            if NOT !c1! == !c4! (
                if NOT !c2! == !c3! (
                    if NOT !c2! == !c4! (
                        if NOT !c3! == !c4! (
                            @set /a "result=%%i+4"
                            ECHO Result: !result!
                            GOTO :EOF
                        )
                    )
                )
            )
        )
    )
    REM ECHO !c1!
    REM ECHO !c2!
    REM ECHO !c3!
    REM ECHO !c4!
    REM ECHO !_chunk!
)
REM ECHO %_chunk%




exit /b
:strLen
setlocal enabledelayedexpansion

:strLen_Loop
if not "!%1:~%len%!"=="" set /A len+=1 & goto :strLen_Loop
(endlocal & set %2=%len%)
goto :eof

:substring
SET %4=!%1:~%2,%3!