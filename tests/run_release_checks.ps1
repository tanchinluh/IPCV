param(
    [Parameter(Mandatory = $true)]
    [string]$ScilabExecutable,

    [switch]$Build
)

$ErrorActionPreference = "Stop"

& (Join-Path $PSScriptRoot "validate_repository.ps1")
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

if ($Build) {
    & (Join-Path $PSScriptRoot "run_build.ps1") -ScilabExecutable $ScilabExecutable
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
    & (Join-Path $PSScriptRoot "validate_repository.ps1") -RequireBuiltArtifacts
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

& (Join-Path $PSScriptRoot "run_tests.ps1") -ScilabExecutable $ScilabExecutable -Suite "release"
exit $LASTEXITCODE
