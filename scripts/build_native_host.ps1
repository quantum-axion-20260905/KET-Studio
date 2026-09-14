[CmdletBinding()]
param(
  [ValidateSet('Debug', 'Release')]
  [string]$Configuration = 'Release'
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceDir = Join-Path $repoRoot 'native\ket_host'
$buildDir = Join-Path $sourceDir 'build'

$cmakeCommand = Get-Command cmake -ErrorAction SilentlyContinue
if ($cmakeCommand) {
  $cmakePath = $cmakeCommand.Source
} else {
  $cmakeCandidates = @(
    'C:\Program Files\CMake\bin\cmake.exe',
    'C:\Program Files (x86)\CMake\bin\cmake.exe',
    'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe',
    'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe'
  )
  $cmakePath = $cmakeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $cmakePath) {
  throw 'CMake was not found. Install CMake and the C++ desktop toolchain first.'
}

& $cmakePath -S $sourceDir -B $buildDir
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& $cmakePath --build $buildDir --config $Configuration
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$hostPath = Join-Path $buildDir "$Configuration\ket_host.exe"
Write-Host "Native terminal host built: $hostPath"
