set -euo pipefail

if [[ $# -lt 1 || -z "$1" ]]; then
    echo "Usage: $0 <grafana-url>" >&2
    echo "Example: $0 https://my-grafana.region.grafana.azure.com" >&2
    exit 1
fi

GRAFANA_URL="${1%/}"  # strip trailing slash
GRAFANA_APP_ID="ce34e7e5-485f-4d76-964f-b3d2b16d1e4f"

# Make 'az' play nice with sandboxes
export AZURE_LOGGING_ENABLE_LOG_FILE=false

TOKEN=$(az account get-access-token --resource "$GRAFANA_APP_ID" --query accessToken -o tsv 2>/dev/null)

if [[ -z "$TOKEN" ]]; then
    echo "Error: Could not get access token. Are you logged in to Azure?" >&2
    exit 1
fi

result=$(curl -s -f -H "Authorization: Bearer $TOKEN" "$GRAFANA_URL/api/datasources")

if [[ -z "$result" || "$result" == "null" ]]; then
    echo "No datasources returned. Check the URL and your permissions." >&2
    exit 1
fi

echo "Grafana: $GRAFANA_URL"
echo ""
{ echo $'uid\ttype\tname'; echo $'---\t----\t----'; echo "$result" | jq -r '.[] | "\(.uid)\t\(.type)\t\(.name)"'; } | column -t -s $'\t'
