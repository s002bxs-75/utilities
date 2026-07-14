@echo off
setlocal enabledelayedexpansion

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script must be run as an Administrator!
    echo Please right-click the file and select "Run as administrator".
    pause
    exit /b
)

:: Core Variables
set "VHD_DIR=C:\Temp"
set "BASE_NAME=Data"
set "EXT=.vhd"
set "VHD_SIZE_MB=8192"
set "DRIVE_LETTER=V"
set "VOLUME_LABEL=Data"

echo ===================================================
echo   1. Enforcing Target Directory
echo ===================================================
if not exist "%VHD_DIR%" mkdir "%VHD_DIR%"

echo ===================================================
echo   2. Checking for Existing Files and Renaming
echo ===================================================
set "FINAL_VHD_PATH=%VHD_DIR%\%BASE_NAME%%EXT%"

if exist "%FINAL_VHD_PATH%" (
    echo "%BASE_NAME%%EXT%" already exists. Initiating sequential rename loop...
    set "count=1"
    :RenameLoop
    set "NEW_VHD_PATH=%VHD_DIR%\%BASE_NAME%!count!%EXT%"
    if exist "!NEW_VHD_PATH!" (
        set /a count+=1
        goto RenameLoop
    )
    echo Renaming existing file to: %BASE_NAME%!count!%EXT%
    ren "%FINAL_VHD_PATH%" "%BASE_NAME%!count!%EXT%"
)

echo Target file path verified: %FINAL_VHD_PATH%

echo ===================================================
echo   3, 4, 5. Creating VHD, Initializing GPT, Formatting exFAT
echo ===================================================
set "SCRIPT_FILE=%temp%\vhd_secure_script.txt"

(
echo create vdisk file="%FINAL_VHD_PATH%" maximum=%VHD_SIZE_MB% type=fixed
echo select vdisk file="%FINAL_VHD_PATH%"
echo attach vdisk
echo convert gpt
echo create partition primary
echo format fs=exfat quick label="%VOLUME_LABEL%"
echo assign letter=%DRIVE_LETTER%
) > "%SCRIPT_FILE%"

diskpart /s "%SCRIPT_FILE%"
del "%SCRIPT_FILE%"

echo Waiting for the operating system to bind drive letter %DRIVE_LETTER%: ...
timeout /t 5 >nul

echo ===================================================
echo   6. Initializing BitLocker Encryption
echo ===================================================
manage-bde -on %DRIVE_LETTER%: -Password

:CheckStatus
:: Wait 15 seconds between progress updates
timeout /t 5 /nobreak >nul

:: Initialize a fallback variable
set "CurrentPercent=0.0"

:: Loop through manage-bde output to isolate the Percentage line
for /f "tokens=2 delims=:" %%A in ('manage-bde -status %DriveLetter% ^| findstr /C:"Percentage Encrypted"') do (
    :: Remove the trailing percentage sign (%) and any stray spaces
    set "RawVal=%%A"
    set "RawVal=!RawVal:%%=!"
    
    :: Strip leading spaces by leveraging an internal for loop
    for /f "tokens=1" %%B in ("!RawVal!") do set "CurrentPercent=%%B"
)

echo Current Progress: !CurrentPercent!%%

:: Check if the cleaned value equals 100.0 (or 100)
if "!CurrentPercent!"=="100.0" goto :EncryptionComplete
if "!CurrentPercent!"=="100" goto :EncryptionComplete

:: If not 100, loop back
goto :CheckStatus

:EncryptionComplete
echo.
echo [SUCCESS] BitLocker encryption is 100%% complete!

echo ===================================================
echo   7. Locking and Detaching VHD File
echo ===================================================
echo Flushing data buffers and locking BitLocker drive...
manage-bde -lock %DRIVE_LETTER%: -ForceDismount

echo Generating detachment instructions...
set "DETACH_SCRIPT=%temp%\vhd_detach_script.txt"
(
echo select vdisk file="%FINAL_VHD_PATH%"
echo detach vdisk
) > "%DETACH_SCRIPT%"

diskpart /s "%DETACH_SCRIPT%"
del "%DETACH_SCRIPT%"

echo ===================================================
echo   PROCESS COMPLETED: VHD Created, Encrypted, and Detached
echo ===================================================
pause
