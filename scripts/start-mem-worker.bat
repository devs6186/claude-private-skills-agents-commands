@echo off
:: claude-mem worker auto-start
:: Placed in Windows Startup folder to run on login
set PATH=%PATH%;%USERPROFILE%\.bun\bin
cd /d %USERPROFILE%
npx claude-mem start
