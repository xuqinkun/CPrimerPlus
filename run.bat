@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion

rem Compile and run C sources
rem Output: <repo>\build\<source-relative-dir>\<name>.exe
rem   run.bat chapter03\const.c
rem   run.bat chapter03\const.c -v
rem   run.bat chapter12\12-1\extern.c chapter12\12-1\coal.c
rem   run.bat chapter13\13-1\count.c -- file.txt
rem   run.bat chapter03 --all

set "ROOT=%~dp0"
set "OUT_NAME="
set "RUN_ALL=0"
set "VERBOSE=0"
set "SRC_COUNT=0"
set "DIR_TARGET="
set "PROG_ARGS="

:parse_args
if "%~1"=="" goto after_args
if /I "%~1"=="-h" goto show_help
if /I "%~1"=="--help" goto show_help
if /I "%~1"=="-v" (
    set "VERBOSE=1"
    shift
    goto parse_args
)
if /I "%~1"=="--verbose" (
    set "VERBOSE=1"
    shift
    goto parse_args
)
if /I "%~1"=="--log" (
    set "VERBOSE=1"
    shift
    goto parse_args
)
if /I "%~1"=="-o" (
    if "%~2"=="" (
        echo Error: -o needs an argument
        exit /b 1
    )
    set "OUT_NAME=%~2"
    shift
    shift
    goto parse_args
)
if /I "%~1"=="--all" (
    set "RUN_ALL=1"
    shift
    goto parse_args
)
if "%~1"=="--" (
    shift
    goto collect_prog_args
)
if "%~1:~0,1%"=="-" (
    echo Unknown option: %~1
    goto show_help
)

rem Positional: one directory, or one/more .c files to link together
if exist "%~1\" (
    if defined DIR_TARGET (
        echo Error: only one directory is allowed
        exit /b 1
    )
    if !SRC_COUNT! gtr 0 (
        echo Error: cannot mix directory and source files
        exit /b 1
    )
    set "DIR_TARGET=%~1"
    shift
    goto parse_args
)

if /I "%~x1"==".c" (
    if defined DIR_TARGET (
        echo Error: cannot mix directory and source files
        exit /b 1
    )
    if not exist "%~1" (
        echo Error: file not found: %~1
        exit /b 1
    )
    set /a SRC_COUNT+=1
    set "SRC_!SRC_COUNT!=%~f1"
    shift
    goto parse_args
)

echo Error: expected a directory or .c file, got: %~1
echo Hint: to pass arguments to the program, use -- 
echo   Example: run.bat chapter13\13-1\count.c -- myfile.txt
exit /b 1

:collect_prog_args
if "%~1"=="" goto after_args
set "PROG_ARGS=!PROG_ARGS! "%~1""
shift
goto collect_prog_args

:after_args
where gcc >nul 2>&1
if errorlevel 1 (
    echo Error: gcc not found. Install it and add to PATH.
    exit /b 1
)

if defined DIR_TARGET goto is_dir
if !SRC_COUNT! equ 0 goto show_help

call :compile_and_run
exit /b %ERRORLEVEL%

:is_dir
if "%RUN_ALL%"=="1" goto run_all
call :pick_file "%DIR_TARGET%"
if errorlevel 1 exit /b 1
set "SRC_COUNT=1"
set "SRC_1=!SELECTED!"
call :compile_and_run
exit /b %ERRORLEVEL%

:run_all
set "FAILED=0"
set "FOUND=0"
for %%F in ("%DIR_TARGET%\*.c") do (
    set "FOUND=1"
    echo.
    set "SRC_COUNT=1"
    set "SRC_1=%%~fF"
    set "OUT_NAME="
    set "PROG_ARGS="
    call :compile_and_run
    if errorlevel 1 set "FAILED=1"
)
if "!FOUND!"=="0" (
    echo Error: no .c files in directory: %DIR_TARGET%
    exit /b 1
)
exit /b %FAILED%

:show_help
echo Usage: run.bat ^<dir ^| .c files...^> [options] [-- prog-args...]
echo.
echo Output: ^<repo^>\build\^<source-relative-dir^>\
echo.
echo Options:
echo   -o ^<name^>     output exe name (default: first .c basename, no .exe)
echo   --all         compile and run each .c in a directory separately
echo   -v, --verbose show compile/run logs
echo   --log         same as -v
echo   --            pass remaining args to the program
echo   -h, --help    show help
echo.
echo Examples:
echo   run.bat chapter03\const.c
echo   run.bat chapter03\const.c -v
echo   run.bat chapter12\12-1\extern.c chapter12\12-1\coal.c
echo   run.bat chapter13\13-1\count.c -- myfile.txt
echo   run.bat chapter03 --all
exit /b 0

:compile_and_run
if !SRC_COUNT! lss 1 (
    echo Error: no source files
    exit /b 1
)

for %%I in ("!SRC_1!") do (
    set "BASE=%%~nI"
    set "SRCDIR=%%~dpI"
)

rem Mirror source parent dirs under <ROOT>\build\
set "RELDIR=!SRCDIR!"
set "RELDIR=!RELDIR:%ROOT%=!"
if "!RELDIR!"=="!SRCDIR!" (
    echo Error: source must be under the repo of run.bat
    exit /b 1
)

set "BDIR=!ROOT!build\!RELDIR!"
if not exist "!BDIR!" mkdir "!BDIR!"

if not "!OUT_NAME!"=="" (
    set "OUT=!BDIR!!OUT_NAME!.exe"
    set "LOGBASE=!OUT_NAME!"
) else (
    set "OUT=!BDIR!!BASE!.exe"
    set "LOGBASE=!BASE!"
)

set "GCC_SRCS="
set "SRC_LIST="
for /L %%I in (1,1,!SRC_COUNT!) do (
    if not exist "!SRC_%%I!" (
        echo Error: file not found: !SRC_%%I!
        exit /b 1
    )
    set "GCC_SRCS=!GCC_SRCS! "!SRC_%%I!""
    if defined SRC_LIST (
        set "SRC_LIST=!SRC_LIST! !SRC_%%I!"
    ) else (
        set "SRC_LIST=!SRC_%%I!"
    )
)

set "CC_LOG=!BDIR!!LOGBASE!.build.log"
if "!VERBOSE!"=="1" (
    echo ==^> compile: !SRC_LIST!
    echo ==^> output: !OUT!
    gcc -Wall -Wextra -std=c11 -g -o "!OUT!" !GCC_SRCS!
) else (
    gcc -Wall -Wextra -std=c11 -g -o "!OUT!" !GCC_SRCS! >"!CC_LOG!" 2>&1
)
if errorlevel 1 (
    echo Compile failed: !SRC_LIST!
    if exist "!CC_LOG!" (
        type "!CC_LOG!"
        del "!CC_LOG!" >nul 2>&1
    )
    exit /b 1
)
if exist "!CC_LOG!" del "!CC_LOG!" >nul 2>&1

if "!VERBOSE!"=="1" (
    echo ==^> run: !OUT! !PROG_ARGS!
    echo ----------------------------------------
)
"!OUT!" !PROG_ARGS!
set "CODE=!ERRORLEVEL!"
if "!VERBOSE!"=="1" (
    echo ----------------------------------------
    echo exit code: !CODE!
)
exit /b !CODE!

:pick_file
set "DIR=%~1"
set "COUNT=0"
for %%F in ("%DIR%\*.c") do (
    set /a COUNT+=1
    set "FILE_!COUNT!=%%~fF"
    set "NAME_!COUNT!=%%~nxF"
)

if !COUNT!==0 (
    echo Error: no .c files in directory: %DIR%
    exit /b 1
)

echo Select a file to compile and run:
for /L %%I in (1,1,!COUNT!) do (
    echo   [%%I] !NAME_%%I!
)

:ask_choice
set /p "CHOICE=Enter number (1-!COUNT!): "
set "OK=0"
for /L %%I in (1,1,!COUNT!) do (
    if "!CHOICE!"=="%%I" set "OK=1"
)
if "!OK!"=="0" (
    echo Invalid input, try again
    goto ask_choice
)
set "SELECTED=!FILE_%CHOICE%!"
exit /b 0
