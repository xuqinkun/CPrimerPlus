@echo off
chcp 936 >nul
setlocal EnableExtensions EnableDelayedExpansion

rem Compile and run C sources
rem Output: <repo>\build\<source-relative-dir>\<name>.exe
rem   run.bat chapter03\const.c
rem   run.bat chapter03\const.c -v
rem   run.bat chapter03 --all

set "ROOT=%~dp0"
set "TARGET="
set "OUT_NAME="
set "RUN_ALL=0"
set "VERBOSE=0"

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
        echo 错误: -o 需要参数
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
if "%~1:~0,1%"=="-" (
    echo 未知选项: %~1
    goto show_help
)
if defined TARGET (
    echo 错误: 只能指定一个目录或文件
    exit /b 1
)
set "TARGET=%~1"
shift
goto parse_args

:after_args
if not defined TARGET goto show_help

where gcc >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到 gcc，请先安装并加入 PATH
    exit /b 1
)

if exist "%TARGET%\" goto is_dir
if exist "%TARGET%" goto is_file
echo 错误: 路径不存在: %TARGET%
exit /b 1

:is_file
if /I not "%TARGET:~-2%"==".c" (
    echo 错误: 请指定 .c 源文件
    exit /b 1
)
call :compile_and_run "%TARGET%" "%OUT_NAME%"
exit /b %ERRORLEVEL%

:is_dir
if "%RUN_ALL%"=="1" goto run_all
call :pick_file "%TARGET%"
if errorlevel 1 exit /b 1
call :compile_and_run "!SELECTED!" "%OUT_NAME%"
exit /b %ERRORLEVEL%

:run_all
set "FAILED=0"
set "FOUND=0"
for %%F in ("%TARGET%\*.c") do (
    set "FOUND=1"
    echo.
    call :compile_and_run "%%~fF" ""
    if errorlevel 1 set "FAILED=1"
)
if "!FOUND!"=="0" (
    echo 错误: 目录中没有 .c 文件: %TARGET%
    exit /b 1
)
exit /b %FAILED%

:show_help
echo 用法: run.bat ^<目录或.c文件^> [选项]
echo.
echo 输出目录: <项目根>\build\<源文件相对目录>\
echo.
echo 选项:
echo   -o ^<name^>     指定可执行文件名（仅单文件模式，无需 .exe 后缀）
echo   --all         编译并运行目录下所有 .c 文件
echo   -v, --verbose 显示编译与运行日志（默认静默；失败时仍会打印编译错误）
echo   --log         显示编译与运行日志（默认静默；失败时仍会打印编译错误）
echo   -h, --help    显示帮助
echo.
echo 示例:
echo   run.bat chapter03\const.c
echo   run.bat chapter03\const.c -v
echo   run.bat chapter03 --all
exit /b 0

:compile_and_run
set "SRC=%~1"
set "CUSTOM_OUT=%~2"

if not exist "%SRC%" (
    echo 错误: 文件不存在: %SRC%
    exit /b 1
)

for %%I in ("%SRC%") do (
    set "ABS_SRC=%%~fI"
    set "BASE=%%~nI"
    set "SRCDIR=%%~dpI"
)

rem Mirror source parent dirs under <ROOT>\build\
set "RELDIR=!SRCDIR!"
set "RELDIR=!RELDIR:%ROOT%=!"
if "!RELDIR!"=="!SRCDIR!" (
    echo 错误: 源文件必须位于 run.bat 所在项目目录下
    exit /b 1
)

set "BDIR=!ROOT!build\!RELDIR!"
if not exist "!BDIR!" mkdir "!BDIR!"

if not "!CUSTOM_OUT!"=="" (
    set "OUT=!BDIR!!CUSTOM_OUT!.exe"
) else (
    set "OUT=!BDIR!!BASE!.exe"
)

set "CC_LOG=!BDIR!!BASE!.build.log"
if "!VERBOSE!"=="1" (
    echo ==^> 编译: !ABS_SRC!
    gcc -Wall -Wextra -std=c11 -g -o "!OUT!" "!ABS_SRC!"
) else (
    gcc -Wall -Wextra -std=c11 -g -o "!OUT!" "!ABS_SRC!" >"!CC_LOG!" 2>&1
)
if errorlevel 1 (
    echo 编译失败: %SRC%
    if exist "!CC_LOG!" (
        type "!CC_LOG!"
        del "!CC_LOG!" >nul 2>&1
    )
    exit /b 1
)
if exist "!CC_LOG!" del "!CC_LOG!" >nul 2>&1

if "!VERBOSE!"=="1" (
    echo ==^> 运行: !OUT!
    echo ----------------------------------------
)
"!OUT!"
set "CODE=!ERRORLEVEL!"
if "!VERBOSE!"=="1" (
    echo ----------------------------------------
    echo 退出码: !CODE!
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
    echo 错误: 目录中没有 .c 文件: %DIR%
    exit /b 1
)

echo 请选择要编译运行的文件:
for /L %%I in (1,1,!COUNT!) do (
    echo   [%%I] !NAME_%%I!
)

:ask_choice
set /p "CHOICE=输入编号 (1-!COUNT!): "
set "OK=0"
for /L %%I in (1,1,!COUNT!) do (
    if "!CHOICE!"=="%%I" set "OK=1"
)
if "!OK!"=="0" (
    echo 无效输入，请重试
    goto ask_choice
)
set "SELECTED=!FILE_%CHOICE%!"
exit /b 0
