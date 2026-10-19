@echo off
setlocal
echo ========================================================
echo   Panchang App - 1-Click Production Deployment
echo ========================================================

:: Check if flutter is in PATH, otherwise use C:\src\flutter\bin
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    set "PATH=C:\src\flutter\bin;%PATH%"
)

echo [1/3] Running Automated Tests...
call flutter test
if %errorlevel% neq 0 (
    echo [ERROR] Tests failed! Aborting deployment.
    exit /b %errorlevel%
)

echo [2/3] Building Flutter Web for Release...
call flutter build web --release
if %errorlevel% neq 0 (
    echo [ERROR] Web build failed! Aborting deployment.
    exit /b %errorlevel%
)

echo [3/3] Deploying to Vercel Production...
call npx vercel --prod --yes
if %errorlevel% neq 0 (
    echo [ERROR] Vercel deployment failed!
    exit /b %errorlevel%
)

echo ========================================================
echo   Deployment Successful! Live URL:
echo   https://panchang-app-eta.vercel.app
echo ========================================================
