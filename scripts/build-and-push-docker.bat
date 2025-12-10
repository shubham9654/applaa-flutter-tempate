@echo off
REM Docker Build and Push Script for Applaa Template (Windows)
REM Usage: build-and-push-docker.bat [tag]
REM Example: build-and-push-docker.bat latest
REM Example: build-and-push-docker.bat v1.0.0

setlocal

REM Configuration
set DOCKER_USERNAME=shubham9654
set IMAGE_NAME=applaa-template
set TAG=%1
if "%TAG%"=="" set TAG=latest
set FULL_IMAGE_NAME=%DOCKER_USERNAME%/%IMAGE_NAME%:%TAG%

echo ==========================================
echo Building Docker Image
echo ==========================================
echo Image: %FULL_IMAGE_NAME%
echo.

REM Build the Docker image (from project root)
echo Step 1: Building Docker image...
cd ..
docker build -t %FULL_IMAGE_NAME% -f Dockerfile --target web-server .
cd scripts

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    exit /b 1
)

echo.
echo Build completed successfully!
echo.

REM Tag as latest if not already
if not "%TAG%"=="latest" (
    echo Step 2: Tagging as latest...
    docker tag %FULL_IMAGE_NAME% %DOCKER_USERNAME%/%IMAGE_NAME%:latest
    echo Tagged as latest
    echo.
)

REM Check if logged in to Docker Hub
echo Step 3: Checking Docker Hub login...
docker info | findstr /C:"Username" >nul
if errorlevel 1 (
    echo WARNING: Not logged in to Docker Hub
    echo Please login first:
    echo   docker login
    echo.
    pause
)

REM Push the image
echo Step 4: Pushing to Docker Hub...
docker push %FULL_IMAGE_NAME%

if not "%TAG%"=="latest" (
    docker push %DOCKER_USERNAME%/%IMAGE_NAME%:latest
)

if errorlevel 1 (
    echo.
    echo ERROR: Push failed!
    exit /b 1
)

echo.
echo ==========================================
echo Successfully pushed to Docker Hub!
echo ==========================================
echo.
echo Image: %FULL_IMAGE_NAME%
echo.
echo Pull command:
echo   docker pull %FULL_IMAGE_NAME%
echo.
echo Run command:
echo   docker run -d -p 8080:80 %FULL_IMAGE_NAME%
echo.

endlocal

