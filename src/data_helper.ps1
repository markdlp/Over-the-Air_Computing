param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

if (-not (Test-Path $FilePath)) {
    Write-Error "File not found: $FilePath"
    exit 1
}

$lines = Get-Content $FilePath
$lineNumber = 1

foreach ($line in $lines) {
    "$lineNumber`t$line"
    $lineNumber++
}