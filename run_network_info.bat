@echo off
setlocal

REM Get the directory of the batch file
set scriptDir=%~dp0

REM Construct the full path to the PowerShell script
set psScript=%scriptDir%network_info.ps1

REM Check if the PowerShell script exists
if exist "%psScript%" (
    REM Execute the PowerShell script
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%psScript%"
) else (
    echo PowerShell script not found: %psScript%
    pause
)

endlocal
