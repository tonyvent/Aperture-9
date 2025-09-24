param(
    [string]$Message = "update",
    [string]$Remote = ""
)

function Write-Info($t){ Write-Host "[git-sync] $t" -ForegroundColor Cyan }
function Write-Warn($t){ Write-Host "[git-sync] $t" -ForegroundColor Yellow }
function Write-Err($t){ Write-Host "[git-sync] $t" -ForegroundColor Red }

$repoTop = (git rev-parse --show-toplevel) 2>$null
if (-not $repoTop) {
    Write-Err "Not inside a Git repository."
    exit 1
}
Set-Location $repoTop
Write-Info "Repo: $repoTop"

$branch = (git rev-parse --abbrev-ref HEAD).Trim()
if (-not $branch) { $branch = "main" }
Write-Info "Branch: $branch"

$hasOrigin = (& git remote) -contains "origin"
if (-not $hasOrigin) {
    if ([string]::IsNullOrWhiteSpace($Remote)) {
        Write-Warn "No 'origin' remote. Provide -Remote git@github.com:user/repo.git"
        exit 2
    } else {
        git remote add origin $Remote | Out-Null
        Write-Info "Added remote 'origin' -> $Remote"
    }
}

git add -A
if ($LASTEXITCODE -eq 0) {
    $staged = git diff --cached --quiet; $changed = $LASTEXITCODE -ne 0
    if ($changed) {
        Write-Info "Committing changes..."
        git commit -m $Message | Out-Null
    } else {
        Write-Info "No changes to commit."
    }
}

git fetch origin | Out-Null
$upstream = (git rev-parse --abbrev-ref --symbolic-full-name "@{u}" 2>$null)
if ($upstream) {
    Write-Info "Pulling (rebase) from $upstream ..."
    git pull --rebase
} else {
    Write-Warn "No upstream set; skipping pull."
}

Write-Info "Pushing to origin/$branch ..."
git push -u origin $branch

Write-Host "`n✅ Sync complete." -ForegroundColor Green
