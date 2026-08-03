@echo off
chcp 65001 >nul
setlocal
set "ROOT=%~dp0..\..\"
set "OUT=%ROOT%build\chapter12\12-1"
if not exist "%OUT%" mkdir "%OUT%"
gcc -Wall -Wextra -std=c11 -g -o "%OUT%\extern.exe" "%~dp0extern.c" "%~dp0coal.c"
if errorlevel 1 exit /b 1
"%OUT%\extern.exe"
exit /b %ERRORLEVEL%
