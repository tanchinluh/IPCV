param(
    [Parameter(Mandatory = $true)]
    [string]$ScilabExecutable,

    [ValidateSet("core", "integration", "gui", "network", "hardware", "stability", "release", "all")]
    [string]$Suite = "core",

    [string]$TestNames = "",

    [string]$ReportPath = "",

    [ValidateRange(1, 86400)]
    [int]$TimeoutSeconds = 600
)

$ErrorActionPreference = "Stop"
$scriptPath = Join-Path $PSScriptRoot "run_tests.sce"
$statusPath = Join-Path ([System.IO.Path]::GetTempPath()) ("ipcv-test-" + [guid]::NewGuid().ToString("N") + ".txt")
$progressPath = Join-Path ([System.IO.Path]::GetTempPath()) ("ipcv-progress-" + [guid]::NewGuid().ToString("N") + ".txt")

if (-not (Test-Path -LiteralPath $ScilabExecutable -PathType Leaf)) {
    throw "Scilab executable does not exist: $ScilabExecutable"
}

if ([string]::IsNullOrWhiteSpace($ReportPath)) {
    $resultsDirectory = Join-Path $PSScriptRoot "results"
    New-Item -ItemType Directory -Path $resultsDirectory -Force | Out-Null
    $ReportPath = Join-Path $resultsDirectory ("ipcv-" + $Suite + "-report.csv")
}

$env:IPCV_TEST_STATUS_FILE = $statusPath
$env:IPCV_TEST_REPORT_FILE = [System.IO.Path]::GetFullPath($ReportPath)
$env:IPCV_TEST_PROGRESS_FILE = $progressPath
$env:IPCV_TEST_SUITE = $Suite
$env:IPCV_TEST_NAMES = $TestNames

try {
    $process = Start-Process -FilePath $ScilabExecutable -ArgumentList @("-nb", "-f", ('"' + $scriptPath + '"')) -NoNewWindow -PassThru
    if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
        $progress = if (Test-Path -LiteralPath $progressPath) { (Get-Content -LiteralPath $progressPath -Raw).Trim() } else { "no progress reported" }
        Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
        Write-Error "IPCV test suite timed out after $TimeoutSeconds seconds at: $progress"
        exit 1
    }
    $process.WaitForExit()
    $process.Refresh()
    $processExitCode = $process.ExitCode
    if ($null -eq $processExitCode -or [string]::IsNullOrWhiteSpace([string]$processExitCode)) {
        $processExitCode = 0
    }
    $status = @()
    if (Test-Path -LiteralPath $statusPath) {
        $status = @(Get-Content -LiteralPath $statusPath)
    }

    if (($status.Count -gt 0) -and ($status[0].Trim() -eq "PASS")) {
        Write-Host ($status -join [Environment]::NewLine)
        if ($processExitCode -ne 0) {
            Write-Warning "Scilab returned $processExitCode after the test runner reported PASS."
        }
        exit 0
    }

    if ($status.Count -gt 0) {
        Write-Error ($status -join [Environment]::NewLine)
    } else {
        Write-Error "IPCV test runner terminated without producing a status file. Scilab exit code: $processExitCode"
    }
    exit 1
}
finally {
    Remove-Item -LiteralPath $statusPath -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $progressPath -Force -ErrorAction SilentlyContinue
    Remove-Item Env:IPCV_TEST_STATUS_FILE -ErrorAction SilentlyContinue
    Remove-Item Env:IPCV_TEST_REPORT_FILE -ErrorAction SilentlyContinue
    Remove-Item Env:IPCV_TEST_PROGRESS_FILE -ErrorAction SilentlyContinue
    Remove-Item Env:IPCV_TEST_SUITE -ErrorAction SilentlyContinue
    Remove-Item Env:IPCV_TEST_NAMES -ErrorAction SilentlyContinue
}
