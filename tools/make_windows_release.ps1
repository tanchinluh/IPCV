param(
    [Parameter(Mandatory = $true)]
    [string]$ScilabExecutable
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
Set-StrictMode -Version Latest

$Root = Split-Path -Parent $PSScriptRoot
$DistRoot = Join-Path $Root "dist"
$StageRoot = Join-Path $DistRoot ".stage"
$SourceStageZip = Join-Path $DistRoot ".source-stage.zip"

function Stop-Release([string]$Message) {
    throw "IPCV release: $Message"
}

function Get-SHA256Hex([string]$Path) {
    $stream = [IO.File]::OpenRead($Path)
    $algorithm = [Security.Cryptography.SHA256]::Create()
    try {
        return -join ($algorithm.ComputeHash($stream) | ForEach-Object { $_.ToString("x2") })
    }
    finally {
        $algorithm.Dispose()
        $stream.Dispose()
    }
}

function Copy-RequiredFile([string]$Source, [string]$Destination) {
    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) {
        Stop-Release "required file is missing: $Source"
    }
    $destinationDirectory = Split-Path -Parent $Destination
    if (-not (Test-Path -LiteralPath $destinationDirectory)) {
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
    }
    Copy-Item -LiteralPath $Source -Destination $Destination -Force
}

function Copy-RequiredDirectory([string]$Source, [string]$Destination) {
    if (-not (Test-Path -LiteralPath $Source -PathType Container)) {
        Stop-Release "required directory is missing: $Source"
    }
    Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force
}

try {
    Set-Location $Root

    if (-not (Test-Path -LiteralPath $ScilabExecutable -PathType Leaf)) {
        Stop-Release "Scilab CLI was not found: $ScilabExecutable"
    }

    $runningScilab = @(Get-Process -Name "WScilex", "WScilex-cli" -ErrorAction SilentlyContinue)
    if ($runningScilab.Count -ne 0) {
        $processList = ($runningScilab | ForEach-Object { "$($_.ProcessName) ($($_.Id))" }) -join ", "
        Stop-Release "close all running Scilab processes before building: $processList"
    }

    $version = (Get-Content -LiteralPath (Join-Path $Root "VERSION") -Raw).Trim()
    if ($version -notmatch '^\d+\.\d+\.\d+$') {
        Stop-Release "VERSION must contain a three-part version number; found '$version'."
    }

    $descriptionVersion = Select-String -LiteralPath (Join-Path $Root "DESCRIPTION") -Pattern '^Version:\s*(\S+)' | Select-Object -First 1
    if (-not $descriptionVersion -or $descriptionVersion.Matches[0].Groups[1].Value -ne $version) {
        Stop-Release "DESCRIPTION and VERSION do not contain the same version."
    }

    $trackedChanges = @(& git status --porcelain --untracked-files=no)
    if ($LASTEXITCODE -ne 0) {
        Stop-Release "git status failed."
    }
    if ($trackedChanges.Count -ne 0) {
        Write-Host "Tracked changes:" -ForegroundColor Yellow
        $trackedChanges | ForEach-Object { Write-Host "  $_" }
        Stop-Release "commit or restore tracked changes before creating a reproducible package."
    }

    $versionHeader = Join-Path $Root "thirdparty\Windows\AMD64\include\opencv2\core\version.hpp"
    if (-not (Test-Path -LiteralPath $versionHeader -PathType Leaf)) {
        Stop-Release "OpenCV is not installed under thirdparty\Windows\AMD64. Run thirdparty\build\build.bat first."
    }
    $headerText = Get-Content -LiteralPath $versionHeader -Raw
    $major = [regex]::Match($headerText, '#define\s+CV_VERSION_MAJOR\s+(\d+)').Groups[1].Value
    $minor = [regex]::Match($headerText, '#define\s+CV_VERSION_MINOR\s+(\d+)').Groups[1].Value
    $revision = [regex]::Match($headerText, '#define\s+CV_VERSION_REVISION\s+(\d+)').Groups[1].Value
    if ("$major.$minor.$revision" -ne "5.1.0") {
        Stop-Release "OpenCV 5.1.0 is required; the installed headers report $major.$minor.$revision."
    }

    $opencvLib = Join-Path $Root "thirdparty\Windows\AMD64\lib"
    $runtimeNames = @(
        "opencv_world510.dll",
        "opencv_img_hash510.dll",
        "opencv_videoio_ffmpeg510_64.dll"
    )
    foreach ($runtimeName in $runtimeNames) {
        if (-not (Test-Path -LiteralPath (Join-Path $opencvLib $runtimeName) -PathType Leaf)) {
            Stop-Release "OpenCV 5.1 runtime is missing: $runtimeName"
        }
    }

    Write-Host "Running repository validation, a clean IPCV build, and release tests..." -ForegroundColor Cyan
    & (Join-Path $Root "tests\run_release_checks.ps1") -ScilabExecutable $ScilabExecutable -Build
    if ($LASTEXITCODE -ne 0) {
        Stop-Release "build or release tests failed."
    }

    $packageName = "IPCV_${version}.bin.x64.Windows"
    $stageDirectory = Join-Path $StageRoot $packageName
    $archivePath = Join-Path $DistRoot "$packageName.zip"
    $checksumPath = "$archivePath.sha256"

    if (Test-Path -LiteralPath $StageRoot) {
        Remove-Item -LiteralPath $StageRoot -Recurse -Force
    }
    if (Test-Path -LiteralPath $SourceStageZip) {
        Remove-Item -LiteralPath $SourceStageZip -Force
    }
    New-Item -ItemType Directory -Path $stageDirectory -Force | Out-Null

    Write-Host "Staging committed source files..." -ForegroundColor Cyan
    & git archive --format=zip --output=$SourceStageZip HEAD
    if ($LASTEXITCODE -ne 0) {
        Stop-Release "git archive failed."
    }
    Expand-Archive -LiteralPath $SourceStageZip -DestinationPath $stageDirectory -Force

    $releaseOnlyExclusions = @(
        (Join-Path $stageDirectory ".gitattributes"),
        (Join-Path $stageDirectory ".gitignore"),
        (Join-Path $stageDirectory "make_release.bat"),
        (Join-Path $stageDirectory "tools"),
        (Join-Path $stageDirectory "thirdparty\build")
    )
    foreach ($excludedPath in $releaseOnlyExclusions) {
        if (Test-Path -LiteralPath $excludedPath) {
            Remove-Item -LiteralPath $excludedPath -Recurse -Force
        }
    }

    Write-Host "Adding generated Scilab and native artifacts..." -ForegroundColor Cyan
    foreach ($topLevelFile in @("loader.sce", "unloader.sce", "cleaner.sce")) {
        Copy-RequiredFile (Join-Path $Root $topLevelFile) (Join-Path $stageDirectory $topLevelFile)
    }
    Copy-RequiredDirectory (Join-Path $Root "jar") (Join-Path $stageDirectory "jar")
    $helpIndex = "inline\en_US\links.json"
    if (Test-Path -LiteralPath (Join-Path $Root $helpIndex) -PathType Leaf) {
        Copy-RequiredFile (Join-Path $Root $helpIndex) (Join-Path $stageDirectory $helpIndex)
    }

    Get-ChildItem -LiteralPath (Join-Path $Root "macros") -Recurse -File | Where-Object {
        $_.Extension -eq ".bin" -or $_.Name -eq "lib"
    } | ForEach-Object {
        $relativePath = $_.FullName.Substring($Root.Length + 1)
        Copy-RequiredFile $_.FullName (Join-Path $stageDirectory $relativePath)
    }

    foreach ($generatedFile in @(
        "src\cpp\libipcv_core.dll",
        "src\cpp\loader.sce",
        "src\cleaner_src.sce",
        "sci_gateway\cpp\gw_ipcv.dll",
        "sci_gateway\cpp\loader.sce",
        "sci_gateway\cleaner_gateway.sce"
    )) {
        Copy-RequiredFile (Join-Path $Root $generatedFile) (Join-Path $stageDirectory $generatedFile)
    }

    $thirdpartyStage = Join-Path $stageDirectory "thirdparty\Windows\AMD64"
    New-Item -ItemType Directory -Path (Join-Path $thirdpartyStage "lib") -Force | Out-Null
    Copy-RequiredDirectory (Join-Path $Root "thirdparty\Windows\AMD64\etc") (Join-Path $thirdpartyStage "etc")
    Copy-RequiredFile (Join-Path $Root "thirdparty\Windows\AMD64\LICENSE") (Join-Path $thirdpartyStage "LICENSE")
    foreach ($runtimeName in $runtimeNames) {
        Copy-RequiredFile (Join-Path $opencvLib $runtimeName) (Join-Path $thirdpartyStage "lib\$runtimeName")
    }

    $obsoleteFiles = @(Get-ChildItem -LiteralPath $stageDirectory -Recurse -File | Where-Object {
        $_.Name -match 'opencv_.*500' -or $_.Name -match 'opencv_videoio_ffmpeg500'
    })
    if ($obsoleteFiles.Count -ne 0) {
        Stop-Release "obsolete OpenCV 5.0 files entered the staged package."
    }

    foreach ($requiredPackageFile in @(
        "DESCRIPTION",
        "VERSION",
        "loader.sce",
        "macros\lib",
        "src\cpp\libipcv_core.dll",
        "sci_gateway\cpp\gw_ipcv.dll",
        "thirdparty\Windows\AMD64\lib\opencv_world510.dll"
    )) {
        if (-not (Test-Path -LiteralPath (Join-Path $stageDirectory $requiredPackageFile))) {
            Stop-Release "staged package is incomplete: $requiredPackageFile"
        }
    }

    if (Test-Path -LiteralPath $archivePath) {
        Remove-Item -LiteralPath $archivePath -Force
    }
    if (Test-Path -LiteralPath $checksumPath) {
        Remove-Item -LiteralPath $checksumPath -Force
    }

    Write-Host "Creating $archivePath..." -ForegroundColor Cyan
    Compress-Archive -LiteralPath $stageDirectory -DestinationPath $archivePath -CompressionLevel Optimal
    $hash = Get-SHA256Hex $archivePath
    "$hash  $([IO.Path]::GetFileName($archivePath))" | Set-Content -LiteralPath $checksumPath -Encoding ASCII

    $archiveSize = (Get-Item -LiteralPath $archivePath).Length
    Write-Host "Release archive: $archivePath" -ForegroundColor Green
    Write-Host ("Archive size: {0:N1} MiB" -f ($archiveSize / 1MB)) -ForegroundColor Green
    Write-Host "SHA256: $hash" -ForegroundColor Green
    Write-Host "Install on another Windows x64 computer with:" -ForegroundColor Green
    Write-Host "  atomsInstall(`"$archivePath`")" -ForegroundColor Green
}
finally {
    if (Test-Path -LiteralPath $StageRoot) {
        Remove-Item -LiteralPath $StageRoot -Recurse -Force
    }
    if (Test-Path -LiteralPath $SourceStageZip) {
        Remove-Item -LiteralPath $SourceStageZip -Force
    }
}
