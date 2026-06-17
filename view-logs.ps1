#!/usr/bin/env pwsh
<#
.SYNOPSIS
    View recent server logs.
#>

param(
    [string]$LogDir = "logs",
    [int]$Lines = 100,
    [switch]$Follow
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $LogDir)) {
    Write-Error "Logs directory '$LogDir' not found."
    exit 1
}

$logFiles = Get-ChildItem -Path $LogDir -Filter "server-*.log" | Sort-Object LastWriteTime -Descending

if (-not $logFiles) {
    Write-Warning "No log files found in $LogDir"
    exit 0
}

$latestLog = $logFiles[0].FullName

Write-Host "📄 Viewing: $latestLog" -ForegroundColor Cyan
Write-Host "---" -ForegroundColor Gray

if ($Follow) {
    Get-Content $latestLog -Wait -Tail $Lines
}
else {
    Get-Content $latestLog -Tail $Lines
}