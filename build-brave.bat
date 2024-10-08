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

_r rmdir /s /q src
_r mkdir src
echo gitkeep >src\.gitkeep

:: install assorted node.js goo
_r -n npm install --no-audit --no-fund --force chalk
cd src\brave
if errorlevel 1 goto :eof
_r npm install --no-audit --no-fund --force
if errorlevel 1 goto :eof

pushd components\brave_wallet\browser\zcash\rust\librustzcash\src
git restore .
popd

pushd third_party\bip39wally-core-native
git restore .
popd

pushd third_party\reclient_configs\src
git restore .
popd

cd ..\..
pause

:: the 'init' step installs brave-core
::call :run_step init

:: the 'sync' step installs depot_tools and chromium,
:: some apache stuff, etc.
SET "RBE_service=remotebuildexecution.googleapis.com:443"

call :run_step sync

call :run_step build

call :run_step create_dist

call :run_step start

popd
goto :eof

::::::::

:run_step
echo %YELLOW%About to 'npm run %1'%DEFAULT%
pause
_r npm run %1
exit /b 0
