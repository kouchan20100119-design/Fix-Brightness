@echo off

:: ====================================
:: Administrator privilege check & Self-elevation
:: ====================================
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb runAs"
    EXIT /B
)

:: ====================================
:: Restart NVIDIA NvContainerLocalSystem 
:: ====================================
sc stop "NvContainerLocalSystem" >nul 2>&1
timeout /t 3 /nobreak >nul
sc start "NvContainerLocalSystem" >nul 2>&1

:: Automatic termination
exit
