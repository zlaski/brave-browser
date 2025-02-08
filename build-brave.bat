@echo off
cls
setlocal
set "SCRIPT=%~n0"
set ESC=
set "RED=%ESC%[1;38;2;255;40;40m"
set "GREEN=%ESC%[1;38;2;10;255;10m"
set "DEFAULT=%ESC%[0m"
set "YELLOW=%ESC%[1;38;2;255;255;0m"
set "BLUE=%ESC%[1;38;2;40;40;255m"
set "MAGENTA=%ESC%[1;38;2;255;0;255m"
set "CYAN=%ESC%[1;38;2;0;255;255m"

call "%~dp0clean-source-tree"

echo %CYAN%%SCRIPT%: About to build and install PoltoonLtd browser%DEFAULT%
set /p "inp=%CYAN%Do you wish to continue? [Yes/No]:%DEFAULT% "
if "%inp%" == "" goto :abort_build
if /i '%inp:~0,3%'=='Yes' goto :perform_build

:abort_build

echo %GREEN%%SCRIPT%: Build aborted%DEFAULT%
exit /b 10

:perform_build

pushd "%~dp0"

echo %GREEN%%SCRIPT%: Building . . .%DEFAULT%

if exist src (
    pushd src
    _r -n -q rmdir /s /q out
    _r git pull --autostash
    popd
)
if not exist src (
    _r git clone --single-branch --branch=hybrid-chunk-store https://github.com/zlaski/chromium.git src
    if errorlevel 1 exit /b 11
)

if exist src\brave (
    pushd src\brave
    _r git pull --autostash
    popd
)
if not exist src\brave (
    _r git clone --single-branch --branch=hybrid-chunk-store https://github.com/zlaski/brave-core.git src\brave
    if errorlevel 1 exit /b 11
)

if not exist src\brave\vendor\depot_tools (
    _r git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git src\brave\vendor\depot_tools    pushd src\brave\vendor\depot_tools
    if errorlevel 1 exit /b 11
)

:: Install dependencies
echo %PATH%
_r -n -q rmdir /s /q node_modules
_r npm install --force --no-fund --no-audit
pushd src\brave
_r -n -q rmdir /s /q node_modules
_r npm install --force --no-fund --no-audit
popd

_r npm install --force --no-fund
if errorlevel 1 goto :finish_build
cd src\brave
_r npm install --force --no-fund
popd
if errorlevel 1 goto :finish_build

SET "RBE_service=remotebuildexecution.googleapis.com:443"

:: the 'init' step installs brave-core
echo %PATH%
_r -q npm run init

:: the 'sync' step installs depot_tools and chromium,
:: some apache stuff, etc.
echo %PATH%
_r npm run sync
if errorlevel 1 popd & exit /b 11

_r npm run build
if errorlevel 1 popd & exit /b 11

_r npm run create_dist
if errorlevel 1 popd & exit /b 11

_r npm run start
if errorlevel 1 popd & exit /b 11

popd
