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

@echo off
npm install -g --no-audit --no-fund --force typescript
npm install -g --no-audit --no-fund --force in-publish
npm install -g --no-audit --no-fund --force rollup
npm install -g --no-audit --no-fund --force tsconfig
@echo on

cd /d "%~dp0"

@echo on
del .gitmodules
del .gcs*
del depot_tools.zip
rm -rf depot_tools || exit /b 10
rm -rf src || exit /b 11
rm -rf node_modules || exit /b 12
rm -rf chromium || exit /b 13
rm -rf _gclient* || exit /b 14
@echo off

touch .gitmodules

mkdir src

@echo on
git submodule add -f https://github.com/zlaski/brave-core.git src\brave
pushd src\brave
call npm install
popd
call npm install
@echo off

goto :eof

@echo on
curl -o depot_tools.zip https://storage.googleapis.com/chrome-infra/depot_tools.zip
unzip -q depot_tools.zip -d depot_tools
@echo off

set "PATH=%CD%\depot_tools;%PATH%"
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set "vs2022_install=C:\Program Files\Microsoft Visual Studio\2022\Community"

@echo on
call gclient
ren depot_tools\git.bat git-disabled.bat
ren depot_tools\python3.bat python3-disabled.bat
@echo off

@echo on
:: call npm install @types/webtorrent
call npm install --force
@echo off

pushd src\brave

@echo on
:: call npm install storybook@8.2.5
call npm install --force 
@echo off

popd

git config --global user.name "Ziemowit Łąski"
git config --global user.email "zlaski@ziemas.net"
git config --global core.autocrlf false
git config --global branch.autosetuprebase always
git config --global core.longpaths true

goto :eof

:::::::::::::::::::::::::::::::::::::::::

:run
    echo %GREEN%%*%DEFAULT%
    %* >nul
    echo %GREEN%Returned code %ERRORLEVEL%%DEFAULT%
    exit /b 0

:err
    exit /b 1
