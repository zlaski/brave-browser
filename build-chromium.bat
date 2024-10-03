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

git config --global user.name "Ziemowit Łąski"
git config --global user.email "zlaski@ziemas.net"
git config --global core.autocrlf false
git config --global branch.autosetuprebase always
git config --global core.longpaths true
git config --global core.longpaths true

if not exist chromium (
    mkdir chromium
    cd chromium

    fetch --nohooks --no-history chromium
    %CHKERR%

    gclient sync --nohooks
    %CHKERR%
    
    cd src
    
    gn gen out\Default
    %CHKERR%

    gn args out\Default
    %CHKERR%

    set NINJA_SUMMARIZE_BUILD=1
    autoninja -v -C out\Default base
    %CHKERR%

    autoninja -v -C out\Default chrome
    %CHKERR%
    
    cd ..\..
)

:end_of_script
popd
