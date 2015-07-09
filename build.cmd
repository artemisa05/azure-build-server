@echo off
rem ----------------------------------------------------------------------------
rem Builds an Azure Virtual Machine capable of compiling, testing & deploying 
rem .NET applications.
rem
rem Usage:
rem
rem		build
rem
rem ----------------------------------------------------------------------------

pushd %~dp0

:start
cls

powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile .\source\build.ps1

echo.
echo.
choice /m "Do you want to re-run the build?"
if errorlevel 2 goto finish
if errorlevel 1 goto start

:finish
popd
