@echo off

rem set dev=1

if defined dev setlocal enableextensions enabledelayedexpansion

if "%~1"=="" (set INI_FILE_PATH=settings.ini) else (set INI_FILE_PATH="%~1")

if not exist %INI_FILE_PATH% exit /b

set INI_FETCH_AUTO=%~2
set INI_DEFAULT_SECTION_NAME=SETTINGS
set INI_SECTION=%INI_DEFAULT_SECTION_NAME%
for /f "usebackq delims== tokens=1,2" %%a in (%INI_FILE_PATH%) do (
	set INI_K=%%a
	if "!INI_K:~0,1!"=="[" (
		set INI_SECTION=!INI_K:~1,-1!
	) else (
		set INI.!INI_SECTION!.%%a=%%b
		if not "%INI_FETCH_AUTO%"=="" set !INI_SECTION!.%%a=%%b
	)
)

set INI_LENGTH=0

call :inini SAMPLE_0 icon "" "" icon.svg 1
call :inini SAMPLE_1 PROPERTY_0 1
call :inini SAMPLE_1 PROPERTY_1 1
call :inini SAMPLE_2 PROPERTY_0 1
call :inini SAMPLE_3 PROPERTY_0 1

set /a INI_LENGTH=INI_LENGTH - 1
for /l %%i in (0,1,%INI_LENGTH%) do (
	if defined INI_KEYS[%%i] if defined INI_VALUES[%%i] (
		set !INI_KEYS[%%i]!=!INI_VALUES[%%i]!
		echo !INI_KEYS[%%i]!=!INI_VALUES[%%i]!
	)
)
pause

if defined dev endlocal

exit /b

:inini

if "%~1"=="" (set INI_SECTION=%INI_DEFAULT_SECTION_NAME%) else (set INI_SECTION=%~1)

if not "%INI_FETCH_AUTO%"=="" set %INI_SECTION%.%~2=

set INI_KEYS[%INI_LENGTH%]=%INI_SECTION%.%~2
set INI_K=INI_KEYS[%INI_LENGTH%]
set INI_V=INI_VALUES[%INI_LENGTH%]

set INI_DEFAULT=%~3
set INI_WQ=%~4
set INI_FPATH=%~5
set INI_FEXISTS=%~6
set INI_CONST=%~7
set INI_LABEL=%~8
set INI_SW=%~9

if not "%INI_FPATH%"=="" call :confirm_file "%INI_FPATH%" "%INI_DEFAULT%" INI_DEFAULT

if defined INI.!%INI_K%! (set INI_CV=!INI.%INI_SECTION%.%~2!) else (set INI_CV=/)
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

if not "%INI_FPATH%"=="" if not "%INI_FEXISTS%"=="" (
	if "!%INI_V%!"=="" set %INI_V%=""
	call :confirm_file !%INI_V%! "%INI_DEFAULT%" %INI_V% !%INI_K%!
)

set /a INI_LENGTH=INI_LENGTH+1

exit /b


rem 簡易なファイルの存在確認
rem 第一引数に与えたファイル名を第二引数などと結合してファイルの存在を確認し、
rem 存在する場合は第三引数に与えた変数名が示す変数にパスを設定する。
:confirm_file

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
	call :confirm_file %1 %2 %3 %4
	
)

exit /b