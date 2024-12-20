powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/scheduler.xml' -OutFile 'C:\scheduler.xml'"
schtasks /create /tn "AdobeHostBlock" /xml "C:\scheduler.xml" /f
del /f /q "C:\scheduler.xml"
echo Task đã được import thành công!
