@echo off

rem This code does not work in standalone.

set dev=2
rem any except 2 = enter debugging mode
rem 2 = delete settings.ini after launch and then enter debugging mode.

if defined dev if "%~1"=="" setlocal enableextensions enabledelayedexpansion

set INI_DEFAULT_INI_PATH=settings.ini
set INI_DEFAULT_SECTION_NAME=settings

if "%~1"=="" (set INI_FILE_PATH=%INI_DEFAULT_INI_PATH%) else (set INI_FILE_PATH="%~1")

if "%dev%"=="2" del %INI_FILE_PATH%

if not exist %INI_FILE_PATH% (
	
	if defined dev (
		
		set INI_CREATE_PRESET=y
		
	) else (
		
		echo No specified INI file %INI_FILE_PATH%. Would you like to create it? Type "y" then.
		set /p INI_CREATE_PRESET=
		if not "!INI_CREATE_PRESET!"=="y" exit /b
		
	)
	
)

set INI_SECTION=%INI_DEFAULT_SECTION_NAME%

if defined INI_CREATE_PRESET (
	
	set INI_SECTIONS=0
	
) else (
	
	set INI_FETCH_AUTO=%~2
	set INI_LENGTH=0
	
	for /f "usebackq delims== tokens=1,2" %%a in (%INI_FILE_PATH%) do (
		
		set INI_K=%%a
		
		if "!INI_K:~0,1!"=="[" (
			set INI_SECTION=!INI_K:~1,-1!
		) else if not "%%a"=="" (
			set INI.!INI_SECTION!.%%a=%%b
			if defined INI_FETCH_AUTO set !INI_SECTION!.%%a=%%b
		)
		
	)
	
)

if "%dev%"=="2" call :INISUB_DEV&goto INISUB_OUTPUT

rem beginning of INI values

rem end of INI values

:INISUB_OUTPUT

if defined INI_CREATE_PRESET (
	
	copy /-Y nul %INI_FILE_PATH%
	
	set /a INI_SECTIONS=INI_SECTIONS - 1
	for /l %%i in (0,1,!INI_SECTIONS!) do (
echo %INI_COMMENT%
pause
		
		set INI_CATEGORY=!INI_SECTIONS[%%i]!
		echo [!INI_CATEGORY!]>>%INI_FILE_PATH%
		:: https://qiita.com/plcherrim/items/c7c477cacf8c97792e17
		call set l0=%%INIS.!INI_CATEGORY!%%
		
		for /l %%j in (0,1,!l0!) do (
			call set INI_K=%%INIS.!INI_CATEGORY![%%j].k%%
			call set INI_V=%%INIS.!INI_CATEGORY![%%j].v%%
			rem https://stackoverflow.com/questions/20484151/redirecting-output-from-within-batch-file
			call :INISUB_THATS_WHY_I_CANT_STOP_TO_LOVE_BATCH_AKA_ECHO_PARAMETER !INI_K! !INI_V! null>>%INI_FILE_PATH%
			call set INI_COMMENT=%%INIS.!INI_CATEGORY![%%j].c%%
			if defined INI_COMMENT call :INISUB_ECHO_COMMENT !INI_COMMENT! null>>%INI_FILE_PATH%
		)
		
	)
	
) else (
	
	set /a INI_LENGTH=INI_LENGTH - 1
	for /l %%i in (0,1,%INI_LENGTH%) do (
		if defined INI_KEYS[%%i] if defined INI_VALUES[%%i] (
			set !INI_KEYS[%%i]!=!INI_VALUES[%%i]!
			if defined dev echo !INI_KEYS[%%i]!=!INI_VALUES[%%i]!
		)
	)
	
)

if defined dev (
	if "%~1"=="" endlocal
	pause
)

exit /b


:inini

if "%~1"=="" (set INI_SECTION=%INI_DEFAULT_SECTION_NAME%) else (set INI_SECTION=%~1)

set INI_VALUE_NAME=%~2

if defined INI_FETCH_AUTO set %INI_SECTION%.%INI_VALUE_NAME%=

set INI_KEYS[%INI_LENGTH%]=%INI_SECTION%.%INI_VALUE_NAME%
set INI_K=INI_KEYS[%INI_LENGTH%]
set INI_V=INI_VALUES[%INI_LENGTH%]

set INI_DEFAULT=%~3
set INI_WQ=%~4
set INI_ASFILE=%~5
set INI_FEXISTS=%~6
set INI_CONST=%~7
set INI_LABEL=%~8
set INI_SW=%~9
shift
set INI_COMMENT=%~9

if not "%INI_ASFILE%"=="" (
	call :INISUB_CONFIRM_FILE "%INI_ASFILE%" "%INI_DEFAULT%" INI_DEFAULT
	call :INISUB_REMOVE_WQ "!INI_DEFAULT!" INI_DEFAULT
	set INI_WQ=0
)

if defined INI.!%INI_K%! (set INI_CV=!INI.%INI_SECTION%.%INI_VALUE_NAME%!) else (set INI_CV=/)
if not "%INI_CV%"=="" (
	
	if "%INI_CV%"=="/" (set %INI_V%=%INI_DEFAULT%) else (set %INI_V%=%INI_CV%)
	
	if not "%INI_SW%"=="" (
		if "%INI_SW%"=="1" set INI_SW=%INI_K%
		if not defined %INI_SW%[%INI_V%] set %INI_V%=%INI_DEFAULT%
		if defined %INI_SW%[%INI_V%] (set %INI_V%=!%INI_SW%[%INI_V%]!) else (set %INI_V%=)
	)
	
	if not "!%INI_V%!"=="" (
		if "%INI_CONST%"=="1" set %INI_K%=%INI_DEFAULT%
		if "%INI_WQ%"=="1" set %INI_V%="!%INI_V%!"
		if not "%INI_LABEL%"=="" set %INI_V%=%INI_LABEL% !%INI_V%!
	)
	
)

if not "%INI_FEXISTS%"=="" (
	if "!%INI_V%!"=="" set %INI_V%=""
	call :INISUB_CONFIRM_FILE !%INI_V%! "%INI_DEFAULT%" %INI_V% !%INI_K%!
)

set /a INI_LENGTH=INI_LENGTH + 1

if defined INI_CREATE_PRESET (
	
	rem Categorize all values.
	if defined INIS.%INI_SECTION% (
		set /a INIS.%INI_SECTION%=INIS.%INI_SECTION% + 1
	) else (
		set INIS.%INI_SECTION%=0
	)
	set INIS.%INI_SECTION%[!INIS.%INI_SECTION%!].k=%INI_VALUE_NAME%
	set INIS.%INI_SECTION%[!INIS.%INI_SECTION%!].v=!%INI_V%!
	if defined INI_COMMENT set INIS.%INI_SECTION%[!INIS.%INI_SECTION%!].c="%INI_COMMENT%"

	rem Collect all section names.
	for /l %%i in (0,1,%INI_SECTIONS%) do (
		if "!INI_SECTIONS[%%i]!"=="%INI_SECTION%" goto INISUB_BREAK_SECTION_COLLECTOR
	)
	set INI_SECTIONS[!INI_SECTIONS!]=%INI_SECTION%
	set /a INI_SECTIONS=INI_SECTIONS + 1
	
)

:INISUB_BREAK_SECTION_COLLECTOR

exit /b


rem 簡易なファイルの存在確認
rem 第一引数に与えたファイル名を第二引数などと結合してファイルの存在を確認し、
rem 存在する場合は第三引数に与えた変数名が示す変数にパスを設定する。
:INISUB_CONFIRM_FILE

set INI_USER_CONFIRM_FILE_PATH="%~2\%~1"

if not "%~2"=="" if exist %INI_USER_CONFIRM_FILE_PATH% set %~3=%INI_USER_CONFIRM_FILE_PATH%

if not exist %INI_USER_CONFIRM_FILE_PATH% (
	if exist "%~1" (
		set %~3="%~1"
	) else if exist "%PROGRAMFILES%\%~1" (
		set %~3="%PROGRAMFILES%\%~1"
	) else if exist "%PROGRAMFILES(X86)%\%~1" (
		set %~3="%PROGRAMFILES(X86)%\%~1"
	)
)

if not "%~4"=="" if not exist "!%~3!" (
	
	echo Please input a certin path for "%~4".
	set /p %~3=
	call :INISUB_CONFIRM_FILE %1 %2 %3 %4
	
)

exit /b

:INISUB_THATS_WHY_I_CANT_STOP_TO_LOVE_BATCH_AKA_ECHO_PARAMETER
set INI_K=%~1
set INI_V=%~2
rem https://stackoverflow.com/questions/562038/escaping-double-quotes-in-batch-script
call :INISUB_REMOVE_WQ %INI_K% INI_K
call :INISUB_REMOVE_WQ %INI_V% INI_V
echo %INI_K%=%INI_V%
exit /b

:INISUB_ECHO_COMMENT
echo # %~1
exit /b

:INISUB_REMOVE_WQ
set INI_REMOVE_WQ_V=%~1
if %INI_REMOVE_WQ_V:~0,1%%INI_REMOVE_WQ_V:~0,1%=="" if %INI_REMOVE_WQ_V:~-1%%INI_REMOVE_WQ_V:~-1%=="" set %~2=%INI_REMOVE_WQ_V:~1,-1%
exit /b

:INISUB_DEV
call :inini SAMPLE_0 icon "" "" icon.svg 1 "" "" "" "hi"
call :inini SAMPLE_1 PROPERTY_0 1
call :inini SAMPLE_1 PROPERTY_1 1
call :inini SAMPLE_2 PROPERTY_0 1
call :inini SAMPLE_3 PROPERTY_0 1 "" "" "" "" "" "" "ho"
exit /b