param(
    [Parameter(Mandatory = $true)]
    [string]$GrafanaUrl
)

$GrafanaUrl = $GrafanaUrl.TrimEnd('/')
$GrafanaAppId = "ce34e7e5-485f-4d76-964f-b3d2b16d1e4f"

# Make 'az' play nice with sandboxes
$env:AZURE_LOGGING_ENABLE_LOG_FILE = "false"

$token = az account get-access-token --resource $GrafanaAppId --query accessToken -o tsv 2>$null
if ($LASTEXITCODE -ne 0 -or -not $token) {
    Write-Error "Could not get access token. Are you logged in to Azure?"
    exit 1
}

$headers = @{ "Authorization" = "Bearer $token" }

try {
    $result = Invoke-RestMethod -Uri "$GrafanaUrl/api/datasources" -Headers $headers -Method Get
} catch {
    Write-Error "Request failed: $_"
    exit 1
}

if (-not $result) {
    Write-Error "No datasources returned. Check the URL and your permissions."
    exit 1
}

Write-Host "Grafana: $GrafanaUrl"
Write-Host ""
$result | Select-Object uid, type, name | Format-Table -AutoSize
