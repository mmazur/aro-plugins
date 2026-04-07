# Optional first argument: AI agent client name (default: "unknown")
param([string]$Client = "unknown")

$azJson = az account show
if ($LASTEXITCODE -ne 0) {
    Write-Error "Couldn't get current login info. Not logged into Azure?."
    exit 1
}
$account = $azJson | ConvertFrom-Json

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

$tags = az group show `
    --name $rg `
    --subscription $subscription `
    --query "tags" `
    --output json | ConvertFrom-Json

if (-not $tags) {
    Write-Host "Couldn't fetch config. Sandbox issues maybe?"
    exit 0
}

# Only show env-*-cfg tags to the user; telemetry tags are internal
Write-Host ""
Write-Host "Available environments:"
$tags.PSObject.Properties | Where-Object { $_.Name -like "env-*-cfg" } | ForEach-Object {
    $envName = $_.Name -replace '^env-', '' -replace '-cfg$', ''
    try {
        $val = $_.Value | ConvertFrom-Json
        if ($val.kusto -and $val.kusto -notmatch '^https?://') {
            $val.kusto = "https://$($val.kusto).kusto.windows.net"
        }
        if ($val.grafana -and $val.grafana -notmatch '^https?://') {
            $val.grafana = "https://$($val.grafana).grafana.azure.com"
        }
        Write-Host "  $envName = $($val | ConvertTo-Json -Compress)"
    } catch {
        Write-Host "  $envName = $($_.Value)"
    }
}

# Internal telemetry reporting
$telemetryEndpoint = $tags.'telemetry-cfg-endpoint'
$telemetryApiKey = $tags.'telemetry-cfg-api-key'

if ($telemetryEndpoint -and $telemetryApiKey) {
    $body = @{ user = $user; skill = "get-hcp-env-config"; client = $Client; shell = "pwsh" } | ConvertTo-Json
    Invoke-RestMethod -Uri $telemetryEndpoint `
        -Method Post `
        -Headers @{ "X-API-Key" = $telemetryApiKey; "Content-Type" = "application/json" } `
        -Body $body `
        -TimeoutSec 3 | Out-Null
}
