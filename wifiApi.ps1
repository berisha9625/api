# FTP bilgileri
$ftpHost = "ftp://ftpupload.net/"
$ftpUser = "if0_39536575"
$ftpPass = $env:FTP_PASS

if (-not $ftpPass) {
    Write-Error "FTP_PASS ortam değişkeni ayarlı değil!"
    exit 1
}

# FTP'den dosya listesini al
try {
    $ftpRequest = [System.Net.FtpWebRequest]::Create($ftpHost)
    $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectory
    $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)

    $response = $ftpRequest.GetResponse()
    $reader = New-Object System.IO.StreamReader $response.GetResponseStream()
    $fileList = @()
    while (-not $reader.EndOfStream) {
        $fileList += $reader.ReadLine()
    }
    $reader.Close()
    $response.Close()

    Write-Host "FTP Dosya Listesi:"
    $fileList | ForEach-Object { Write-Host " - $_" }

    # wifipass dosyalarını filtrele
    $existingFiles = $fileList | Where-Object { $_ -match '^wifipass(\d*)\.txt$' }

    Write-Host "`nBulunan wifipass dosyaları:"
    $existingFiles | ForEach-Object { Write-Host " * $_" }

    # Dosya numaralarını çıkar
    $numbers = $existingFiles | ForEach-Object {
        if ($_ -match '^wifipass(\d+)\.txt$') {
            [int]$matches[1]
        } elseif ($_ -eq "wifipass.txt") {
            1
        } else {
            0
        }
    }

    $maxNum = if ($numbers.Count -gt 0) { ($numbers | Measure-Object -Maximum).Maximum } else { 0 }

    # Yeni dosya adı
    $newFileName = if ($maxNum -eq 0) { "wifipass.txt" } else { "wifipass$($maxNum + 1).txt" }

    Write-Host "`nYeni dosya adı: $newFileName"

} catch {
    Write-Error "FTP dosya listesi alınırken hata: $_"
    exit 1
}

