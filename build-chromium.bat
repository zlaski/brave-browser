@echo off
setlocal
set ESC=
set "RED=%ESC%[1;38;2;255;40;40m"
set "GREEN=%ESC%[1;38;2;10;255;10m"
set "DEFAULT=%ESC%[0m"

set "CHKERR=if errorlevel 1 goto :end_of_script"

set "PATH=%CD%\depot_tools;%PATH%"
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set "vs2022_install=C:\Program Files\Microsoft Visual Studio\2022\Community"

cd /d "%~dp0"

:: THIS BATCH FILE IS PART OF THE brave-browser CHECKOUT
:: THERE IS NO NEED TO CHECK OUT brave-core

:: origin  https://github.com/zlaski/brave-browser.git (fetch)
:: origin  https://github.com/zlaski/brave-browser.git (push)
:: upstream        https://github.com/brave/brave-browser.git (fetch)
:: upstream        https://github.com/brave/brave-browser.git (push)

mkdir chromium
cd chromium
@echo on
fetch --nohooks --no-history chromium
call gclient sync --nohooks
@echo off

cd src

@echo on
call gn gen out\Default
call gn args out\Default
@echo off
set NINJA_SUMMARIZE_BUILD=1
@echo on
call autoninja -v -C out\Default base
call autoninja -v -C out\Default chrome
@echo off

popd

goto :eof

:::::::::::::::::::::::::::::::::::::::::

:run
    echo %GREEN%%*%DEFAULT%
    %* >nul
    echo %GREEN%Returned code %ERRORLEVEL%%DEFAULT%
    exit /b 0

:err
    exit /b 1
