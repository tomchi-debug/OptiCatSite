#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Starts the OptiCat Astro development server with logging to file.

.DESCRIPTION
    This script starts the dev server and saves all output to a timestamped log file
    in the logs/ directory while also displaying it in the console.
#>

param(
    [switch]$ForceInstall,
    [switch]$SkipOpen,
    [string]$LogDir = "logs"
)

$ErrorActionPreference = "Stop"

# Create logs directory
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$logFile = Join-Path $LogDir "server-$timestamp.log"

Write-Host "🚀 Starting OptiCat development server with logging..." -ForegroundColor Cyan
Write-Host "📝 Log file: $logFile" -ForegroundColor Yellow

# Check if we're in the right directory
if (-not (Test-Path "package.json")) {
    Write-Error "package.json not found. Run this script from the project root."
    exit 1
}

# Install dependencies if needed
if ($ForceInstall -or -not (Test-Path "node_modules")) {
    Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
    npm install
}

# Create .env from example if missing
if (-not (Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Write-Host "📝 Creating .env from .env.example..." -ForegroundColor Yellow
        Copy-Item ".env.example" ".env"
        Write-Host "⚠️  Please edit .env and add your Stripe keys!" -ForegroundColor Red
    }
}

# Start dev server with tee to log file
Write-Host "🌐 Starting Astro dev server..." -ForegroundColor Cyan

if ($SkipOpen) {
    npx astro dev 2>&1 | Tee-Object -FilePath $logFile
}
else {
    npx astro dev --open 2>&1 | Tee-Object -FilePath $logFile
}