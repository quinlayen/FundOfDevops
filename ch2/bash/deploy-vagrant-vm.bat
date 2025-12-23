@echo off
REM This script automates Vagrant VM deployment on Windows
REM Equivalent to deploy-ec2-instance.sh in the AWS example

echo ===================================================
echo Deploying Vagrant VM with sample Node.js app
echo ===================================================

REM Check if Vagrant is installed
where vagrant >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Vagrant is not installed!
    echo Please install Vagrant from https://www.vagrantup.com/downloads
    exit /b 1
)

REM Check if VirtualBox is installed
where VBoxManage >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: VirtualBox is not installed!
    echo Please install VirtualBox from https://www.virtualbox.org/wiki/Downloads
    exit /b 1
)

REM Navigate to the directory containing this script
cd /d "%~dp0"

REM Check if VM exists and destroy it
vagrant status | findstr /C:"running" >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Existing VM found. Destroying it...
    vagrant destroy -f
)

REM Start and provision the VM
echo Creating and provisioning new VM...
vagrant up

echo.
echo ===================================================
echo Deployment Complete!
echo ===================================================
echo.
echo You can access the app at: http://localhost:8080
echo.
echo Useful commands:
echo   vagrant ssh           - SSH into the VM
echo   vagrant status        - Check VM status
echo   vagrant halt          - Stop the VM
echo   vagrant destroy       - Delete the VM
echo ===================================================
