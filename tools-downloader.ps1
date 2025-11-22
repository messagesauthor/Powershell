# tools-downloader.ps1
$TargetFolder = "C:\ss1"

# Create directory
if (!(Test-Path $TargetFolder)) {
    New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null
}

# Download functions with progress
function Download-Tool {
    param($Url, $Output, $ProgressMessage)
    Write-Progress -Activity "Downloading Tools" -Status $ProgressMessage -PercentProgress $global:Progress
    Invoke-WebRequest -Uri $Url -OutFile $Output -UseBasicParsing
    $global:Progress += 33
}

$global:Progress = 0

# Download Everything
Download-Tool -Url "https://www.voidtools.com/Everything-1.4.1.1030.x64.zip" -Output "$TargetFolder\Everything.zip" -ProgressMessage "Downloading Everything..."

# Download WinPrefetchView  
Download-Tool -Url "https://www.nirsoft.net/utils/winprefetchview.zip" -Output "$TargetFolder\winprefetchview.zip" -ProgressMessage "Downloading WinPrefetchView..."

# System Informer via winget
Write-Progress -Activity "Downloading Tools" -Status "Installing System Informer..." -PercentProgress 66
winget install --id WinsiderSS.SystemInformer -e --accept-package-agreements --silent

Write-Progress -Activity "Downloading Tools" -Status "Complete!" -PercentProgress 100 -Completed
Write-Host "Tools downloaded to: $TargetFolder" -ForegroundColor Green
