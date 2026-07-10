param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot),
    [switch]$RequireBuiltArtifacts
)

$ErrorActionPreference = "Stop"
$errors = [System.Collections.Generic.List[string]]::new()

function Add-ValidationError([string]$Message) {
    $script:errors.Add($Message)
}

$RepositoryRoot = [System.IO.Path]::GetFullPath($RepositoryRoot)
$version = (Get-Content -LiteralPath (Join-Path $RepositoryRoot "VERSION") -Raw).Trim()
$description = Get-Content -LiteralPath (Join-Path $RepositoryRoot "DESCRIPTION") -Raw
$changeLog = Get-Content -LiteralPath (Join-Path $RepositoryRoot "ChangeLog.txt") -Raw
$readme = Get-Content -LiteralPath (Join-Path $RepositoryRoot "README.MD") -Raw

if ($description -notmatch "(?m)^Version:\s+$([regex]::Escape($version))\s*$") {
    Add-ValidationError "DESCRIPTION version does not match VERSION ($version)."
}
if ($changeLog -notmatch "(?m)^Version\s+$([regex]::Escape($version))\s+\(") {
    Add-ValidationError "ChangeLog.txt has no top-level entry for $version."
}
if ($readme -notmatch "current development line is IPCV\s+$([regex]::Escape($version))") {
    Add-ValidationError "README.MD does not identify $version as the current development line."
}

$helpIds = @{}
$helpLinks = [System.Collections.Generic.List[object]]::new()
$helpFiles = Get-ChildItem -LiteralPath (Join-Path $RepositoryRoot "help\en_US") -Recurse -File -Filter "*.xml"
foreach ($file in $helpFiles) {
    $raw = Get-Content -LiteralPath $file.FullName -Raw
    try {
        [void][xml]$raw
    }
    catch {
        Add-ValidationError "Invalid help XML: $($file.FullName): $($_.Exception.Message)"
        continue
    }

    foreach ($match in [regex]::Matches($raw, 'xml:id="([^"]+)"')) {
        $id = $match.Groups[1].Value
        if ($helpIds.ContainsKey($id)) {
            Add-ValidationError "Duplicate help xml:id '$id' in $($file.FullName) and $($helpIds[$id])."
        } else {
            $helpIds[$id] = $file.FullName
        }
    }
    foreach ($match in [regex]::Matches($raw, 'linkend="([^"]+)"')) {
        $helpLinks.Add([pscustomobject]@{ Target = $match.Groups[1].Value; File = $file.FullName })
    }
}

foreach ($link in $helpLinks) {
    if (-not $helpIds.ContainsKey($link.Target)) {
        Add-ValidationError "Broken help link '$($link.Target)' in $($link.File)."
    }
}

$gatewayRoot = Join-Path $RepositoryRoot "sci_gateway\cpp"
foreach ($file in Get-ChildItem -LiteralPath $gatewayRoot -File -Filter "sci_*.cpp") {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $functionName = [regex]::Escape($file.BaseName)
    if ($content -notmatch "\bint\s+$functionName\s*\(") {
        Add-ValidationError "Gateway source does not export its filename-matched entry point: $($file.Name)."
    }
}

$nativeBuilders = @(
    (Join-Path $RepositoryRoot "src\cpp\builder_cpp.sce"),
    (Join-Path $RepositoryRoot "sci_gateway\cpp\builder_gateway_cpp.sce")
)
foreach ($builder in $nativeBuilders) {
    $content = Get-Content -LiteralPath $builder -Raw
    if ($content -notmatch 'elseif\s+getos\(\)\s*==\s*"Linux"') {
        Add-ValidationError "Native builder must keep the explicit -std=c++17 flag Linux-only for macOS compiler probing: $builder."
    }
}

$unitRoot = Join-Path $RepositoryRoot "tests\unit_tests"
foreach ($test in Get-ChildItem -LiteralPath $unitRoot -File -Filter "*.tst") {
    $reference = Join-Path $unitRoot ($test.BaseName + ".dia.ref")
    $content = Get-Content -LiteralPath $test.FullName -Raw
    if ((-not (Test-Path -LiteralPath $reference)) -and ($content -notmatch '<-- NO CHECK REF -->')) {
        Add-ValidationError "Test has neither a .dia.ref file nor NO CHECK REF marker: $($test.Name)."
    }
}

$trackedFiles = & git -C $RepositoryRoot ls-files
$machineSpecificRoot = "F:" + [System.IO.Path]::DirectorySeparatorChar + "ScilabModules"
if ($LASTEXITCODE -ne 0) {
    Add-ValidationError "git ls-files failed; tracked-path validation could not run."
} else {
    foreach ($relativePath in $trackedFiles) {
        $path = Join-Path $RepositoryRoot $relativePath
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            continue
        }
        $extension = [System.IO.Path]::GetExtension($path).ToLowerInvariant()
        if ($extension -in @(".png", ".jpg", ".jpeg", ".gif", ".tif", ".tiff", ".avi", ".pb", ".jar", ".zip", ".gz")) {
            continue
        }
        $content = Get-Content -LiteralPath $path -Raw -ErrorAction SilentlyContinue
        if ($null -ne $content -and $content.Contains($machineSpecificRoot)) {
            Add-ValidationError "Tracked source contains a machine-specific workspace root: $relativePath."
        }
    }
}

if ($RequireBuiltArtifacts) {
    $requiredFiles = @(
        "loader.sce",
        "src\cpp\libipcv_core.dll",
        "sci_gateway\cpp\gw_ipcv.dll"
    )
    foreach ($relativePath in $requiredFiles) {
        if (-not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $relativePath) -PathType Leaf)) {
            Add-ValidationError "Required built artifact is missing: $relativePath."
        }
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "PASS: repository metadata version $version"
Write-Host "PASS: $($helpFiles.Count) help XML files parsed; $($helpLinks.Count) links resolved"
Write-Host "PASS: gateway entry points and $((Get-ChildItem -LiteralPath $unitRoot -File -Filter '*.tst').Count) test references validated"
if ($RequireBuiltArtifacts) {
    Write-Host "PASS: required Windows build artifacts are present"
}
exit 0
