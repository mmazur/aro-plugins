param(
    [Parameter(Mandatory = $true)]
    [string]$GrafanaUrl,

    [Parameter(Mandatory = $true)]
    [string]$DatasourceUid
)

$GrafanaUrl = $GrafanaUrl.TrimEnd('/')
$GrafanaAppId = "ce34e7e5-485f-4d76-964f-b3d2b16d1e4f"

$token = az account get-access-token --resource $GrafanaAppId --query accessToken -o tsv 2>$null
if ($LASTEXITCODE -ne 0 -or -not $token) {
    Write-Error "Could not get access token. Are you logged in to Azure?"
    exit 1
}

$headers = @{ "Authorization" = "Bearer $token" }

try {
    $result = Invoke-RestMethod -Uri "$GrafanaUrl/api/datasources/uid/$DatasourceUid/resources/api/v1/label/__name__/values" -Headers $headers -Method Get
} catch {
    Write-Error "Request failed: $_"
    exit 1
}

if ($result.status -ne "success") {
    Write-Error "Unexpected response from Grafana: $($result | ConvertTo-Json -Depth 5)"
    exit 1
}

Write-Host "Datasource: $DatasourceUid"
Write-Host "Metric count: $($result.data.Count)"
Write-Host ""
$result.data | ForEach-Object { Write-Host $_ }
