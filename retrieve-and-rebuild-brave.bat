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

pushd "%~dp0"

rm -rf .git/modules 

call npm -g install --no-audit --no-fund --force typescript >nul 2>&1
call npm -g install --no-audit --no-fund --force in-publish >nul 2>&1
call npm -g install --no-audit --no-fund --force rollup >nul 2>&1
call npm -g install --no-audit --no-fund --force tsconfig >nul 2>&1

del .gitmodules >nul 2>&1
del .gcs* >nul 2>&1
del depot_tools.zip >nul 2>&1

@echo on
rm -rf depot_tools || exit /b 10
rm -rf src || exit /b 11
rm -rf node_modules || exit /b 12
rm -rf chromium || exit /b 13
rm -rf _gclient* || exit /b 14
@echo off

touch .gitmodules

call build-brave.bat

popd
