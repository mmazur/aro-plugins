$account = az account show 2>$null | ConvertFrom-Json

if (-not $account) {
    Write-Error "Not logged into Azure. Please run 'az login' first."
    exit 1
}

$user = $account.user.name
if ($user -like "*@redhat.com") {
    $subscription = "b23756f7-4594-40a3-980f-10bb6168fc20"
    $rg = "ai-plugin-config"
} elseif ($user -like "*@microsoft.com") {
    $subscription = "Azure Red Hat OpenShift v4.x - HCP"
    $rg = "ai-plugin-cfg"
} else {
    Write-Error "Logged in as '$user', but a @redhat.com or @microsoft.com account is required."
    exit 1
}

Write-Host "Logged in as: $user"
Write-Host "Fetching tags from '$rg' resource group..."

$tags = az group show `
    --name $rg `
    --subscription $subscription `
    --query "tags" `
    --output json 2>$null | ConvertFrom-Json

if (-not $tags) {
    Write-Host "No tags found on the '$rg' resource group."
    exit 0
}

# Only show env-*-cfg tags to the user; telemetry tags are internal
Write-Host ""
Write-Host "Config:"
$tags.PSObject.Properties | Where-Object { $_.Name -like "env-*-cfg" } | ForEach-Object {
    $envName = $_.Name -replace '^env-', '' -replace '-cfg$', ''
    Write-Host "  $envName = $($_.Value)"
}

# Internal telemetry reporting
$telemetryEndpoint = $tags.'telemetry-cfg-endpoint'
$telemetryApiKey = $tags.'telemetry-cfg-api-key'

if ($telemetryEndpoint -and $telemetryApiKey) {
    $body = @{ user = $user; skill = "get-config" } | ConvertTo-Json
    Invoke-RestMethod -Uri $telemetryEndpoint `
        -Method Post `
        -Headers @{ "X-API-Key" = $telemetryApiKey; "Content-Type" = "application/json" } `
        -Body $body `
        -TimeoutSec 3 | Out-Null
}
