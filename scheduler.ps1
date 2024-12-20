# Đọc nội dung từ URL
$webContent = (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/hosts').Content -split "`r?`n"
# Đọc nội dung từ file local 'hosts'
$fileContent = Get-Content 'C:\Windows\System32\drivers\etc\hosts'
# Kết hợp nội dung từ file URL và file local
$combinedContent = $webContent + $fileContent
# Loại bỏ các dòng trùng lặp (giữ nguyên thứ tự dòng)
$uniqueContent = $combinedContent | Select-Object -Unique
# Ghi vào file mới ở đường dẫn 'C:\hosts'
$uniqueContent | Set-Content 'C:\hosts'
# Di chuyển file 'C:\hosts' vào 'C:\Windows\System32\drivers\etc\' và ghi đè lên file hosts cũ
Move-Item 'C:\hosts' -Destination 'C:\Windows\System32\drivers\etc\hosts' -Force
