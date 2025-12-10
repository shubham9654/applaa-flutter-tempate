@echo off
REM Docker Installation Checker for Windows
REM This script checks if Docker is installed and provides installation guidance

echo ==========================================
echo Docker Installation Checker
echo ==========================================
echo.

REM Check if Docker is installed
where docker >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Docker is installed!
    echo.
    docker --version
    echo.
    
    REM Check if Docker daemon is running
    docker info >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Docker daemon is running!
        echo.
        echo Docker is ready to use.
        echo.
        echo Next steps:
        echo   1. Login to Docker Hub: docker login
        echo   2. Build your image: docker build -t shubham9654/applaa-template:latest .
        echo   3. Push to Docker Hub: docker push shubham9654/applaa-template:latest
        echo.
    ) else (
        echo [WARNING] Docker is installed but daemon is not running.
        echo.
        echo Please start Docker Desktop:
        echo   1. Open Docker Desktop from Start menu
        echo   2. Wait for it to start (whale icon in system tray)
        echo   3. Run this script again to verify
        echo.
    )
) else (
    echo [ERROR] Docker is not installed!
    echo.
    echo ==========================================
    echo Installation Instructions
    echo ==========================================
    echo.
    echo Option 1: Download Docker Desktop
    echo   Visit: https://www.docker.com/products/docker-desktop/
    echo   Click "Download for Windows"
    echo.
    echo Option 2: Install using winget
    echo   Run: winget install Docker.DockerDesktop
    echo.
    echo Prerequisites:
    echo   - Windows 10/11 64-bit
    echo   - WSL 2 enabled
    echo   - Virtualization enabled in BIOS
    echo.
    echo Detailed guide: docs\DOCKER_INSTALLATION_WINDOWS.md
    echo.
    echo ==========================================
    echo Quick Install Commands (Run as Admin)
    echo ==========================================
    echo.
    echo Step 1: Enable WSL 2
    echo   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    echo   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    echo   (Then restart your computer)
    echo.
    echo Step 2: Set WSL 2 as default
    echo   wsl --set-default-version 2
    echo.
    echo Step 3: Install Docker Desktop
    echo   winget install Docker.DockerDesktop
    echo   (Or download from https://www.docker.com/products/docker-desktop/)
    echo.
    pause
)

