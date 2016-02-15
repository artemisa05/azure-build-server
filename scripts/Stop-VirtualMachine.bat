@echo off
powershell -NoProfile -ExecutionPolicy unrestricted -File "%~dp0Stop-VirtualMachine.ps1"
echo.
echo.
pause