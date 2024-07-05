@echo off
setlocal
set ESC=
set "RED=%ESC%[1;38;2;255;40;40m"
set "GREEN=%ESC%[1;38;2;10;255;10m"
set "DEFAULT=%ESC%[0m"


call :run pushd %~dp0

if "%1"=="clean" (
    call :run del .gitmodules
    call :run rmdir /s /q src\brave
    call :run rmdir /s /q node_modules
    call :run touch .gitmodules
)

call :run git submodule add -f https://github.com/zlaski/brave-core.git src\brave
call :run call npm install @types/webtorrent
call :run call npm install --verbose
:: npm install brave
call :run popd

goto :eof

:::::::::::::::::::::::::::::::::::::::::

:run
    echo %GREEN%%*%DEFAULT%
    %* >nul
    echo %GREEN%Returned code %ERRORLEVEL%%DEFAULT%
    exit /b 0

:err
    exit /b 1
