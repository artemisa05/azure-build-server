@echo off
powershell -NoProfile -ExecutionPolicy unrestricted -File "%~dp0Stop-BuildServer.ps1"
echo.
echo.
pause