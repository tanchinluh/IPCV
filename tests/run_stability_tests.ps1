param(
    [Parameter(Mandatory = $true)]
    [string]$ScilabExecutable
)

$runner = Join-Path $PSScriptRoot "run_tests.ps1"
& $runner -ScilabExecutable $ScilabExecutable -Suite "stability"
exit $LASTEXITCODE
