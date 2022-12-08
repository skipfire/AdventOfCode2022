SETLOCAL EnableDelayedExpansion
ECHO OFF
for /f "Tokens=* Delims=" %%x in (D:\GitHub\AdventOfCode2022\day-6\input.txt) do set content=!content!%%x

call :strLen content contentlength
SET markersize=14
@SET /a "l1stop=%markersize%-2"
@SET /a "contentlength=%contentlength%-%markersize%+1"
for /l %%i in (1, 1, %contentlength%) do (
    ECHO i: %%i
    SET ChunkOk=1
    call :substring content %%i %markersize% _chunk
	call :innerloop1 %l1stop%
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

:innerloop1
for /l %%j in (0, 1, %1) do (
	call :substring _chunk %%j 1 c1
	@SET /a "l2stop=%markersize%-1"
	@SET /a "l2start=%%j+1"
	call :innerloop2 !l2start! !l2stop! !c1!
	if !ChunkOk! == 0 (
		GOTO :EOF
	)
)
GOTO :EOF

:innerloop2
for /l %%k in (%1, 1, %2) do (
	call :substring _chunk %%k 1 c2
	if %3 == !c2! (
		SET ChunkOk=0
		GOTO :EOF
	)
)
GOTO :EOF

