param(
    [string]$ReleaseDir = (Join-Path (Split-Path -Parent $PSScriptRoot) "build\windows\x64\runner\Release")
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ReleaseDir)) {
    throw "Windows release papkasi topilmadi: $ReleaseDir"
}

$systemDir = Join-Path $env:WINDIR "System32"
$runtimeFiles = @(
    "msvcp140.dll",
    "msvcp140_atomic_wait.dll",
    "vcruntime140.dll",
    "vcruntime140_1.dll"
)

foreach ($fileName in $runtimeFiles) {
    $sourcePath = Join-Path $systemDir $fileName
    if (-not (Test-Path -LiteralPath $sourcePath)) {
        throw "Microsoft Visual C++ runtime topilmadi: $sourcePath. Avval Microsoft.VCRedist.2015+.x64 ni o'rnating."
    }

    $destinationPath = Join-Path $ReleaseDir $fileName
    Copy-Item -LiteralPath $sourcePath -Destination $destinationPath -Force
    $version = (Get-Item -LiteralPath $sourcePath).VersionInfo.FileVersion
    Write-Host ("Bundled runtime: {0} ({1})" -f $fileName, $version)
}

Write-Host "Windows release uchun Visual C++ runtime DLL'lari app-local qilindi."
