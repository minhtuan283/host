:: Tải file scheduler.xml từ GitHub về C:\scheduler.xml
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/scheduler.xml' -OutFile 'C:\scheduler.xml'"

:: Import Task vào Task Scheduler
schtasks /create /tn "AdobeHostBlock" /xml "C:\scheduler.xml" /f

echo Task đã được import thành công!