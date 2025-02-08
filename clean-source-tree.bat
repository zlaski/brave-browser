@echo off
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

echo %CYAN%%SCRIPT%: About to clean PoltoonLtd tree%DEFAULT%
set /p "inp=%CYAN%Do you wish to continue? [Yes/No]:%DEFAULT% "
if "%inp%" == "" goto :abort_cleaning
if /i "%inp:~0,3%" == "Yes" goto :perform_clean

:abort_cleaning

echo %GREEN%%SCRIPT%: Cleaning aborted%DEFAULT%
exit /b 10

:perform_clean

echo %GREEN%%SCRIPT%: Cleaning . . .%DEFAULT%

pushd "%~dp0"

_r -n -q del package-lock.json
_r -n -q del src\brave\package-lock.json
if exist _gclient* for /f %%G in ('dir /b _gclient*') do _r -n rmdir /s /q %%G

if /i "%1" == "--deep" (
    _r -n -q rmdir /s /q src
    _r -n -q rmdir /s /q node_modules
    _r -n -q rmdir /s /q %APPDATA%\npm\node_modules
    _r -n -q rmdir /s /q %APPDATA%\npm-cache
)

if /i not "%1" == "--deep" (
    echo [%GREEN%Use '--deep' to delete all dependent modules and sources]%DEFAULT%
    _r -n -q rmdir /s /q src\out
    _r -n -q rmdir /s /q node_modules
    _r -n -q rmdir /s /q src\brave\node_modules
    _r -n -q del src\gitkeep
)

popd
exit /b 0
