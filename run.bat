powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/scheduler.xml' -OutFile 'C:\scheduler.xml'"
schtasks /create /tn "AdobeHostBlock" /xml "C:\scheduler.xml" /f
Remove-Item "C:\scheduler.xml" -Force
Write-Host "Task đã được import thanh cong!" 
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/scheduler.bat" -OutFile "C:\Windows\scheduler.bat"
Write-Host "da tai schedular windows!" 

