@echo off
setlocal EnableExtensions

cd /d "%~dp0"

set "SCILAB_EXE=%~1"
if not defined SCILAB_EXE set "SCILAB_EXE=%IPCV_SCILAB_EXECUTABLE%"
if not defined SCILAB_EXE set "SCILAB_EXE=%SystemDrive%\Tools\scilab-2026.1.0\bin\WScilex-cli.exe"

if not exist "%SCILAB_EXE%" (
    echo ERROR: Scilab CLI was not found:
    echo   %SCILAB_EXE%
    echo.
    echo Pass its path as the first argument or set IPCV_SCILAB_EXECUTABLE.
    goto :failed
)

set "VCVARS="
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" (
    for /f "usebackq tokens=*" %%I in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
        set "VCVARS=%%I\VC\Auxiliary\Build\vcvars64.bat"
    )
)
if not defined VCVARS set "VCVARS=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

if not exist "%VCVARS%" (
    echo ERROR: Visual Studio 2022 x64 build environment was not found.
    echo Install the Desktop development with C++ workload.
    goto :failed
)

echo Initializing the Visual Studio x64 compiler environment...
call "%VCVARS%"
if errorlevel 1 goto :failed

echo.
echo Building and packaging IPCV for ATOMS...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\make_windows_release.ps1" -ScilabExecutable "%SCILAB_EXE%"
if errorlevel 1 goto :failed

echo.
echo IPCV release package created successfully.
echo See the dist folder for the ZIP and SHA256 file.
pause
exit /b 0

:failed
echo.
echo IPCV release creation FAILED. Review the error above.
pause
exit /b 1
