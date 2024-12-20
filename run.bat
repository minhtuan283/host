@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
cls
echo ====================================
echo    Lua chon:
echo    1. Adobe
echo    2. Autodesk
echo ====================================
set /p choice=Chon 1 hoac 2: 

if "%choice%"=="1" goto adobe
if "%choice%"=="2" goto autodesk

:adobe
@echo off
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/scheduler.xml' -OutFile 'C:\scheduler.xml'"
schtasks /create /tn "AdobeHostBlock" /xml "C:\scheduler.xml" /f
del /f /q "C:\scheduler.xml"
echo Task da duoc import thanh cong!
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/scheduler.bat' -OutFile 'C:\Windows\scheduler.bat'"
echo da tai schedular windows!
pause
exit

:autodesk
@echo off
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/scheduler2.xml' -OutFile 'C:\scheduler.xml'"
schtasks /create /tn "AdobeHostBlock" /xml "C:\scheduler.xml" /f
del /f /q "C:\scheduler.xml"
echo Task da duoc import thanh cong!
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/scheduler2.bat' -OutFile 'C:\Windows\scheduler.bat'"
echo da tai schedular windows!
pause
exit
