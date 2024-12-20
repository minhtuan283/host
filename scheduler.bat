set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
powershell -Command "$web='https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/hosts';$urlContent=(Invoke-WebRequest -Uri $web).Content;$filePath='C:\Windows\System32\drivers\etc\hosts';$localContent=Get-Content $filePath;$combined=($urlContent -split \"`r?`n\") + $localContent | Select-Object -Unique;Set-Content $filePath $combined -Encoding UTF8"
exit
