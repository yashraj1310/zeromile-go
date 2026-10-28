@echo off
title ZeroMile Go - Local Server
echo ========================================================
echo   Starting ZeroMile Go Local Production Server...
echo ========================================================
echo.
cd /d "%~dp0"
echo Server is running on: http://localhost:8080
start http://localhost:8080
node server.js
pause
