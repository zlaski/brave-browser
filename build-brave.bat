setlocal
pushd "%~dp0"

:: THIS BATCH FILE IS PART OF THE brave-browser CHECKOUT
:: THERE IS NO NEED TO CHECK OUT brave-core

:: origin  https://github.com/zlaski/brave-browser.git (fetch)
:: origin  https://github.com/zlaski/brave-browser.git (push)
:: upstream        https://github.com/brave/brave-browser.git (fetch)
:: upstream        https://github.com/brave/brave-browser.git (push)

set "CHKERR=if errorlevel 1 goto :end_of_script"

set "PATH=%CD%\depot_tools;%PATH%"
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set "vs2022_install=C:\Program Files\Microsoft Visual Studio\2022\Community"

if not exist depot_tools.zip (
    curl -o depot_tools.zip https://storage.googleapis.com/chrome-infra/depot_tools.zip
    %CHKERR%

    unzip depot_tools.zip -d depot_tools
    %CHKERR%
)

gclient
%CHKERR%

ren depot_tools\git.bat git-disabled.bat
ren depot_tools\python3.bat python3-disabled.bat

git config --global user.name "Ziemowit Łąski"
git config --global user.email "zlaski@ziemas.net"
git config --global core.autocrlf false
git config --global branch.autosetuprebase always
git config --global core.longpaths true
git config --global core.longpaths true

cd src\brave

npm install
%CHKERR%

npm run init
%CHKERR%

npm run build
%CHKERR%

:end_of_script
popd
