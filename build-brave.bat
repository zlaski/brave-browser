@echo off
cls
setlocal
set ESC=
set "RED=%ESC%[1;38;2;255;40;40m"
set "GREEN=%ESC%[1;38;2;10;255;10m"
set "DEFAULT=%ESC%[0m"
set "YELLOW=%ESC%[1;38;2;255;255;0m"
set "BLUE=%ESC%[1;38;2;40;40;255m"
set "MAGENTA=%ESC%[1;38;2;255;0;255m"
set "CYAN=%ESC%[1;38;2;0;255;255m"

echo.
echo %CYAN%About to install and build Brave%DEFAULT%
pause
echo.

:: git clone --single-branch https://github.com/zlaski/brave-browser.git

pushd "%~dp0"

_r -n -q del package-lock.json
_r -q rmdir /s /q node_modules
_r -q rmdir /s /q src
_r mkdir src
echo gitkeep >src\.gitkeep

:: Install dependencies
_r npm install --force --no-fund
if errorlevel 1 goto :eof

SET "RBE_service=remotebuildexecution.googleapis.com:443"

:: the 'init' step installs brave-core
_r -q npm run init

:: the 'sync' step installs depot_tools and chromium,
:: some apache stuff, etc.
_r npm run sync
if errorlevel 1 goto :eof

_r npm run build
if errorlevel 1 goto :eof

_r npm run create_dist
if errorlevel 1 goto :eof

_r npm run start
if errorlevel 1 goto :eof

popd
goto :eof

::::::::

:run_step
echo %YELLOW%About to 'npm run %1'%DEFAULT%
_r npm run %1
exit /b %ERRORLEVEL%
