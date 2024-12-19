@echo off
:: Tải file hosts từ GitHub và lưu vào C:\Windows\System32\drivers\etc\hosts
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/hosts' -OutFile 'C:\Windows\System32\drivers\etc\hosts'"
pause
exit


