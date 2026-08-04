@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion

rem Compile and run C sources
rem Output: <repo>\build\<source-relative-dir>\<name>.exe
rem   run.bat chapter03\const.c
rem   run.bat chapter03\const.c -v
rem   run.bat chapter12\12-1\extern.c chapter12\12-1\coal.c
rem   run.bat chapter03 --all

set "ROOT=%~dp0"
set "OUT_NAME="
set "RUN_ALL=0"
set "VERBOSE=0"
set "SRC_COUNT=0"
set "DIR_TARGET="

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

rem 位置参数：目录或 .c 文件（可多个 .c 一起链接）
if exist "%~1\" (
    if defined DIR_TARGET (
        echo 错误: 只能指定一个目录
        exit /b 1
    )
    if !SRC_COUNT! gtr 0 (
        echo 错误: 不能同时指定目录和源文件
        exit /b 1
    )
    set "DIR_TARGET=%~1"
    shift
    goto parse_args
)

if /I "%~x1"==".c" (
    if defined DIR_TARGET (
        echo 错误: 不能同时指定目录和源文件
        exit /b 1
    )
    if not exist "%~1" (
        echo 错误: 文件不存在: %~1
        exit /b 1
    )
    set /a SRC_COUNT+=1
    set "SRC_!SRC_COUNT!=%~f1"
    shift
    goto parse_args
)

echo 错误: 请指定目录或 .c 文件: %~1
exit /b 1

:after_args
where gcc >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到 gcc，请先安装并加入 PATH
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
    call :compile_and_run
    if errorlevel 1 set "FAILED=1"
)
if "!FOUND!"=="0" (
    echo 错误: 目录中没有 .c 文件: %DIR_TARGET%
    exit /b 1
)
exit /b %FAILED%

:show_help
echo 用法: run.bat ^<目录^| .c文件...^> [选项]
echo.
echo 输出目录: ^<项目根^>\build\^<源文件相对目录^>\
echo.
echo 选项:
echo   -o ^<name^>     指定可执行文件名（默认取第一个 .c 的基名，无需 .exe）
echo   --all         分别编译并运行目录下每个 .c（仅目录模式）
echo   -v, --verbose 显示编译与运行日志（默认静默；失败时仍会打印编译错误）
echo   --log         同 -v
echo   -h, --help    显示帮助
echo.
echo 示例:
echo   run.bat chapter03\const.c
echo   run.bat chapter03\const.c -v
echo   run.bat chapter12\12-1\extern.c chapter12\12-1\coal.c
echo   run.bat chapter12\12-1\extern.c chapter12\12-1\coal.c -o extern -v
echo   run.bat chapter03 --all
exit /b 0

:compile_and_run
if !SRC_COUNT! lss 1 (
    echo 错误: 未指定源文件
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
    echo 错误: 源文件必须位于 run.bat 所在项目目录下
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
        echo 错误: 文件不存在: !SRC_%%I!
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
    echo ==^> 编译: !SRC_LIST!
    echo ==^> 输出: !OUT!
    gcc -Wall -Wextra -std=c11 -g -o "!OUT!" !GCC_SRCS!
) else (
    gcc -Wall -Wextra -std=c11 -g -o "!OUT!" !GCC_SRCS! >"!CC_LOG!" 2>&1
)
if errorlevel 1 (
    echo 编译失败: !SRC_LIST!
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
