@echo off
setlocal
set ESC=
set "RED=%ESC%[1;38;2;255;40;40m"
set "GREEN=%ESC%[1;38;2;10;255;10m"
set "DEFAULT=%ESC%[0m"

echo.
echo %RED%This will nuke existing sources^^!  Press ^^^^C to exit.%DEFAULT%
pause
echo.

cd /d "%~dp0"

del .gitmodules

@echo on
del depot_tools.zip
rmdir /s /q depot_tools
rmdir /s /q src
rmdir /s /q node_modules
rmdir /s /q chromium
rm -rf _gclient*
@echo off

touch .gitmodules

mkdir src

@echo on
git submodule add -f https://github.com/zlaski/brave-core.git src\brave
call npm install @types/webtorrent
@echo on
call npm install --verbose
@echo on
curl -o depot_tools.zip https://storage.googleapis.com/chrome-infra/depot_tools.zip
unzip depot_tools.zip -d depot_tools
@echo off

set "PATH=%CD%\depot_tools;%PATH%"
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set "vs2022_install=C:\Program Files\Microsoft Visual Studio\2022\Community"

@echo on
call gclient

ren depot_tools\git.bat git-disabled.bat
:: ren depot_tools\python3.bat python3-disabled.bat
@echo on
git config --global user.name "Ziemowit Łąski"
git config --global user.email "zlaski@ziemas.net"
git config --global core.autocrlf false
git config --global branch.autosetuprebase always
git config --global core.longpaths true
@echo off

goto :eof

:::::::::::::::::::::::::::::::::::::::::

:run
    echo %GREEN%%*%DEFAULT%
    %* >nul
    echo %GREEN%Returned code %ERRORLEVEL%%DEFAULT%
    exit /b 0

:err
    exit /b 1
