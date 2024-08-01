@echo off
setlocal
set ESC=
set "RED=%ESC%[1;38;2;255;40;40m"
set "GREEN=%ESC%[1;38;2;10;255;10m"
set "DEFAULT=%ESC%[0m"

pushd "%~dp0"

if not exist depot_tools (
    @echo on
    curl -o depot_tools.zip https://storage.googleapis.com/chrome-infra/depot_tools.zip || exit /b 16
    unzip -q depot_tools.zip -d depot_tools || exit /b 17
    call depot-tools\gclient || exit /b 18
    rem ren depot_tools\git.bat git-disabled.bat
    rem ren depot_tools\python3.bat python3-disabled.bat
    @echo off
)

set "PATH=%CD%\depot_tools;%PATH%"
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set "vs2022_install=C:\Program Files\Microsoft Visual Studio\2022\Community"

:: git submodule add -b main -f https://github.com/chromium/chromium.git src
if not exist src (
    @echo on
    git submodule add -b master -f https://github.com/zlaski/brave-core.git src\brave || exit /b 15
    @echo off
) else (
    @echo on
    rm -rf src/out
    @echo off
    cd src\brave
    @echo on
    git fetch origin
    rem git fetch --refetch origin
    @echo off
    cd ..
    @echo on
    git fetch origin
    rem git fetch --refetch origin
    @echo off
    cd ..
)

@echo on
call npm install --force || exit /b 20
@echo off

cd "src\brave"

@echo on
call npm install --force || exit /b 21
@echo on
call npm run init || exit /b 22
@echo on
call npm run build || exit /b 23
@echo on
call npm run create_dist || exit /b 24
@echo off

popd
goto :eof
