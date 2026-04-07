set -euo pipefail

if [[ $# -lt 2 || -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 <grafana-url> <datasource-uid>" >&2
    echo "Example: $0 https://my-grafana.region.grafana.azure.com my-prom-uid" >&2
    exit 1
fi

GRAFANA_URL="${1%/}"
DATASOURCE_UID="$2"
GRAFANA_APP_ID="ce34e7e5-485f-4d76-964f-b3d2b16d1e4f"

TOKEN=$(az account get-access-token --resource "$GRAFANA_APP_ID" --query accessToken -o tsv 2>/dev/null)

if [[ -z "$TOKEN" ]]; then
    echo "Error: Could not get access token. Are you logged in to Azure?" >&2
    exit 1
fi

result=$(curl -s -f -H "Authorization: Bearer $TOKEN" \
    "$GRAFANA_URL/api/datasources/uid/$DATASOURCE_UID/resources/api/v1/label/__name__/values")

status=$(echo "$result" | jq -r '.status // empty')
if [[ "$status" != "success" ]]; then
    echo "Error: unexpected response from Grafana:" >&2
    echo "$result" >&2
    exit 1
fi

count=$(echo "$result" | jq '.data | length')
echo "Datasource: $DATASOURCE_UID"
echo "Metric count: $count"
echo ""
echo "$result" | jq -r '.data[]'
