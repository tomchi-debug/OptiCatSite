# Stoppar alla Node-processer som kör Astro
Write-Host "Stoppar OptiCat dev-server..." -ForegroundColor Yellow

$processes = Get-Process node -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*astro*" -or $_.CommandLine -like "*vite*" }

if ($processes) {
    $processes | Stop-Process -Force
    Write-Host "Dev-servern har stoppats." -ForegroundColor Green
} else {
    Write-Host "Ingen aktiv dev-server hittades." -ForegroundColor Gray
}
