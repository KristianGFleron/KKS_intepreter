@echo off
setlocal enabledelayedexpansion

:: Initialize flags
set fastFlag=0
set softFlag=0
set uninstallFlag=0

:: Process command line arguments
:parse_args
if "%~1"=="" goto args_passed

:: Check against known flags
set "flag_found="
for %%i in (fast soft uninstall) do (
    if /I "%~1"=="--%%i" (
        set %%iFlag=1
        set flag_found=1
    )
)
:: Handle unknown flags
if not defined flag_found (
    echo Unknown option: %1
    exit /b 1
)
shift
goto parse_args
:args_passed

if !fastFlag! equ 1 if !uninstallFlag! equ 0 goto install_req
echo  #############################################################
echo  #                                                           #
echo  #                 Remove installed packages                 #
echo  #                                                           #
echo  #############################################################
.env\Scripts\pip.exe freeze > installed_packages_to_be_uninstalled.txt
set size=0
:: Check for unempty file
for /f %%i in ("installed_packages_to_be_uninstalled.txt") do set size=%%~zi 
if %size% gtr 0 .env\Scripts\pip.exe uninstall -r installed_packages_to_be_uninstalled.txt -y
del installed_packages_to_be_uninstalled.txt
if !uninstallFlag! equ 1 goto activate_environment

:install_req
echo  #############################################################
echo  #                                                           #
echo  #                     Install packages                      #
echo  #                                                           #
echo  #############################################################
.env\Scripts\python.exe -m pip install --upgrade pip
if !softFlag! equ 1 goto soft_requirements
:: Install hard requirements
.env\Scripts\pip.exe install -r requirements-dev.txt
.env\Scripts\pip.exe install -r requirements.txt
pre-commit install
goto activate_environment

:soft_requirements
:: Install soft (enversioned requirements)
:: Create an empty output file
set "outputFile=packages.txt"
type nul > %outputFile%

for %%f in (.txt -dev.txt) do (
    set "inputFile=requirements%%f"
    for /f "tokens=1,* delims==" %%a in (%inputFile%) do (
        set "packageName=%%a"
        echo !packageName!>>%outputFile%
    )
)
pip install -r %outputFile%
del %outputFile%
pre-commit install

:activate_environment
.env\Scripts\activate.bat
