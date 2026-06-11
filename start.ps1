# Startar Astro dev-server i bakgrunden och öppnar webbläsaren
Write-Host "Startar OptiCat dev-server..." -ForegroundColor Cyan
Start-Process npm -ArgumentList "run dev" -WindowStyle Hidden
Write-Host "Servern körs nu i bakgrunden. Webbläsaren öppnas strax." -ForegroundColor Green
