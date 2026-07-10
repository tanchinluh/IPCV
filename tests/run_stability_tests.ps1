param(
    [Parameter(Mandatory = $true)]
    [string]$ScilabExecutable
)

$ErrorActionPreference = "Stop"
$scriptPath = Join-Path $PSScriptRoot "run_stability_tests.sce"
$statusPath = Join-Path ([System.IO.Path]::GetTempPath()) ("ipcv-test-" + [guid]::NewGuid().ToString("N") + ".txt")
$env:IPCV_TEST_STATUS_FILE = $statusPath

try {
    & $ScilabExecutable -nb -f $scriptPath
    $processExitCode = $LASTEXITCODE

    if ((Test-Path -LiteralPath $statusPath) -and ((Get-Content -LiteralPath $statusPath -Raw).Trim() -eq "PASS")) {
        if ($processExitCode -ne 0) {
            Write-Warning "Scilab returned $processExitCode after all IPCV stability tests passed."
        }
        exit 0
    }

    Write-Error "IPCV stability tests failed or did not produce a status file. Scilab exit code: $processExitCode"
    exit 1
}
finally {
    Remove-Item -LiteralPath $statusPath -Force -ErrorAction SilentlyContinue
    Remove-Item Env:IPCV_TEST_STATUS_FILE -ErrorAction SilentlyContinue
}
