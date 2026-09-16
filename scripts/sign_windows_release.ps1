param(
    [Parameter(Mandatory = $true)]
    [string]$CertificatePath,
    [string]$ReleaseDir = (Join-Path (Split-Path -Parent $PSScriptRoot) "build\windows\x64\runner\Release"),
    [string]$DistDir = (Join-Path (Split-Path -Parent $PSScriptRoot) "dist\windows-installer"),
    [string]$TimestampServer = "http://timestamp.digicert.com"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $CertificatePath)) {
    throw "Signing certificate topilmadi: $CertificatePath"
}

function Get-SignTool {
    $candidates = @(
        "C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe",
        "C:\Program Files (x86)\Windows Kits\10\App Certification Kit\signtool.exe",
        "C:\Program Files\Windows Kits\10\bin\10.0.26100.0\x64\signtool.exe"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    $command = Get-Command signtool.exe -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    throw "signtool.exe topilmadi. Windows SDK o'rnating."
}

function Get-PlainPassword {
    if ($env:KET_SIGN_CERT_PASSWORD) {
        return $env:KET_SIGN_CERT_PASSWORD
    }

    $securePassword = Read-Host "PFX certificate password" -AsSecureString
    $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    try {
        return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer)
    }
    finally {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer)
    }
}

function Invoke-SignFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,
        [Parameter(Mandatory = $true)]
        [string]$SignToolPath,
        [Parameter(Mandatory = $true)]
        [string]$Password
    )

    Write-Host "Signing: $FilePath"
    & $SignToolPath sign /fd SHA256 /tr $TimestampServer /td SHA256 /f $CertificatePath /p $Password $FilePath
    if ($LASTEXITCODE -ne 0) {
        throw "Signing failed: $FilePath"
    }
}

$signTool = Get-SignTool
$password = Get-PlainPassword
$files = @()
$pubspecPath = Join-Path (Split-Path -Parent $PSScriptRoot) "pubspec.yaml"
$versionLine = Select-String -Path $pubspecPath -Pattern '^version:\s*([0-9]+\.[0-9]+\.[0-9]+)' | Select-Object -First 1
if (-not $versionLine) {
    throw "pubspec.yaml ichidan app version topilmadi."
}
$appVersion = $versionLine.Matches[0].Groups[1].Value

if (Test-Path -LiteralPath $ReleaseDir) {
    $files += Get-ChildItem -LiteralPath $ReleaseDir -Recurse -File |
        Where-Object { $_.Extension -in @(".exe", ".dll") } |
        Select-Object -ExpandProperty FullName
}

if (Test-Path -LiteralPath $DistDir) {
    $installerPath = Join-Path $DistDir ("ket-studio-setup-{0}.exe" -f $appVersion)
    $msixPath = Join-Path $DistDir "ket-studio-windows-x64.msix"
    foreach ($artifact in @($installerPath, $msixPath)) {
        if (Test-Path -LiteralPath $artifact) {
            $files += (Resolve-Path -LiteralPath $artifact).Path
        }
    }
}

$files = $files | Select-Object -Unique
if (-not $files) {
    throw "Imzolash uchun release artifact topilmadi. Avval build qiling."
}

foreach ($file in $files) {
    Invoke-SignFile -FilePath $file -SignToolPath $signTool -Password $password
}

Write-Host "Release artifact'lari SHA-256 code signing va timestamp bilan imzolandi."
