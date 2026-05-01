param (
    [string]$Message
)

# 1. Bump version in pubspec.yaml
$pubspecPath = "pubspec.yaml"
$content = Get-Content $pubspecPath -Raw
$versionRegex = 'version: (\d+)\.(\d+)\.(\d+)\+(\d+)'
$match = [regex]::Match($content, $versionRegex)

if ($match.Success) {
    $major = $match.Groups[1].Value
    $minor = $match.Groups[2].Value
    $patch = [int]$match.Groups[3].Value + 1
    $build = [int]$match.Groups[4].Value + 1
    $newVersion = "$major.$minor.$patch+$build"
    $content = $content -replace $versionRegex, "version: $newVersion"
    Set-Content $pubspecPath $content
    Write-Host "[OK] Version bumped to $newVersion" -ForegroundColor Green
} else {
    Write-Error "Could not find version in pubspec.yaml"
    exit
}

# 2. Commit message
if (-not $Message) {
    Write-Host "[!] No commit message provided. Using 'chore: release $newVersion'" -ForegroundColor Yellow
    $Message = "chore: release $newVersion"
}

# 3. Git dance
Write-Host "[GIT] Running git commands..." -ForegroundColor Cyan
git add .
git commit -m "$Message"
git push
Write-Host "[GIT] Changes pushed!" -ForegroundColor Green

# 4. Build AAB
Write-Host "[BUILD] Building Android App Bundle (AAB)..." -ForegroundColor Cyan
flutter build appbundle --release
Write-Host "[OK] AAB generated successfully!" -ForegroundColor Green
Write-Host "[OK] Location: build\app\outputs\bundle\release\app-release.aab" -ForegroundColor Cyan
