@echo off
title Student Profile and Skill Development Management System
echo ========================================================
echo  Launching Spring Boot App (No Global Maven Required)
echo ========================================================
echo.

cd /d "%~dp0"

:: 1. Check if Maven is in PATH
where mvn >nul 2>nul
if %errorlevel% equ 0 (
    echo [OK] Global Maven found. Running Spring Boot...
    call mvn spring-boot:run
    goto :end
)

:: 2. Search common locations for Maven (VS Code extensions, IntelliJ, Program Files)
set "FOUND_MVN="

for /r "%USERPROFILE%\.vscode\extensions" %%f in (mvn.cmd) do (
    if exist "%%f" set "FOUND_MVN=%%f"
)

if not defined FOUND_MVN (
    for /d %%i in ("C:\Program Files\JetBrains\IntelliJ IDEA*") do (
        if exist "%%i\plugins\maven\lib\maven3\bin\mvn.cmd" (
            set "FOUND_MVN=%%i\plugins\maven\lib\maven3\bin\mvn.cmd"
        )
    )
)

if not defined FOUND_MVN (
    for /d %%i in ("C:\Program Files\Apache\maven*" "C:\apache-maven*") do (
        if exist "%%i\bin\mvn.cmd" (
            set "FOUND_MVN=%%i\bin\mvn.cmd"
        )
    )
)

if defined FOUND_MVN (
    echo [OK] Found bundled Maven at: "%FOUND_MVN%"
    call "%FOUND_MVN%" spring-boot:run
    goto :end
)

:: 3. Use the project's Maven Wrapper when Maven is not installed
if not exist "mvnw.cmd" (
    echo [ERROR] Maven is not installed and mvnw.cmd is missing.
    echo Install Maven or restore the Maven Wrapper files.
    goto :end
)

if not exist ".mvn\wrapper\maven-wrapper.properties" (
    echo [ERROR] Maven Wrapper configuration is missing:
    echo .mvn\wrapper\maven-wrapper.properties
    goto :end
)

echo [INFO] Maven not found on system. Starting with Maven Wrapper...
call mvnw.cmd spring-boot:run

:end
pause