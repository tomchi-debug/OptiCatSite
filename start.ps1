#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Starts the OptiCat Astro development server with automatic setup.

.DESCRIPTION
    This script:
    1. Installs npm dependencies if node_modules is missing
    2. Creates .env from .env.example if missing
    3. Starts the Astro dev server with --open flag
#>

param(
    [switch]$ForceInstall,
    [switch]$SkipOpen
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting OptiCat development server..." -ForegroundColor Cyan

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
else {
    Write-Host "✅ Dependencies already installed" -ForegroundColor Green
}

# Create .env from example if missing
if (-not (Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Write-Host "📝 Creating .env from .env.example..." -ForegroundColor Yellow
        Copy-Item ".env.example" ".env"
        Write-Host "⚠️  Please edit .env and add your Stripe keys!" -ForegroundColor Red
    }
    else {
        Write-Warning ".env.example not found, skipping .env creation"
    }
}
else {
    Write-Host "✅ .env already exists" -ForegroundColor Green
}

# Start dev server
Write-Host "🌐 Starting Astro dev server..." -ForegroundColor Cyan
if ($SkipOpen) {
    npx astro dev
}
else {
    npx astro dev --open
}