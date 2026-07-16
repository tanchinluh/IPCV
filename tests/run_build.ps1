param(
    [Parameter(Mandatory = $true)]
    [string]$ScilabExecutable
)

$ErrorActionPreference = "Stop"
$scriptPath = Join-Path $PSScriptRoot "run_build.sce"
$statusPath = Join-Path ([System.IO.Path]::GetTempPath()) ("ipcv-build-" + [guid]::NewGuid().ToString("N") + ".txt")
$env:IPCV_BUILD_STATUS_FILE = $statusPath

try {
    & $ScilabExecutable -nb -f $scriptPath
    $processExitCode = $LASTEXITCODE
    $status = @()
    if (Test-Path -LiteralPath $statusPath) {
        $status = @(Get-Content -LiteralPath $statusPath)
    }
    if (($status.Count -gt 0) -and ($status[0].Trim() -eq "PASS")) {
        if ($processExitCode -ne 0) {
            Write-Warning "Scilab returned $processExitCode after the build runner reported PASS."
        }
        exit 0
    }
    if ($status.Count -gt 0) {
        Write-Error ($status -join [Environment]::NewLine)
    } else {
        Write-Error "IPCV build stopped without producing a status file. Scilab exit code: $processExitCode"
    }
    exit 1
}
finally {
    Remove-Item -LiteralPath $statusPath -Force -ErrorAction SilentlyContinue
    Remove-Item Env:IPCV_BUILD_STATUS_FILE -ErrorAction SilentlyContinue
}
