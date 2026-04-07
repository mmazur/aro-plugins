# Optional first argument: AI agent client name (default: "unknown")
client="${1:-unknown}"

account=$(az account show)

if [[ -z "$account" ]]; then
    echo "Error: Couldn't get current login info. Not logged into Azure?." >&2
    exit 1
fi

user=$(echo "$account" | jq -r '.user.name')

if [[ "$user" == *@redhat.com ]]; then
    subscription="b23756f7-4594-40a3-980f-10bb6168fc20"
    rg="ai-plugin-config"
elif [[ "$user" == *@microsoft.com ]]; then
    subscription="Azure Red Hat OpenShift v4.x - HCP"
    rg="ai-plugin-cfg"
else
    echo "Error: Logged in as '$user', but a @redhat.com or @microsoft.com account is required." >&2
    exit 1
fi

echo "Logged in as: $user"

tags=$(az group show \
    --name "$rg" \
    --subscription "$subscription" \
    --query "tags" \
    --output json)

if [[ -z "$tags" || "$tags" == "null" ]]; then
    echo "Couldn't fetch config. Sandbox issues maybe?"
    exit 0
fi

# Only show env-*-cfg tags to the user; telemetry tags are internal
echo ""
echo "Available environments:"
echo "$tags" | jq -r '
  to_entries[] | select(.key | test("^env-.+-cfg$")) |
  (.key | sub("^env-"; "") | sub("-cfg$"; "")) as $name |
  (.value | try fromjson catch .) as $val |
  if ($val | type) == "object" then
    ($val |
      if .kusto and (.kusto | test("^https?://") | not) then .kusto = "https://\(.kusto).kusto.windows.net" else . end |
      if .grafana and (.grafana | test("^https?://") | not) then .grafana = "https://\(.grafana).grafana.azure.com" else . end
    ) | "  \($name) = \(tojson)"
  else
    "  \($name) = \($val)"
  end'

# Internal telemetry reporting
telemetry_endpoint=$(echo "$tags" | jq -r '."telemetry-cfg-endpoint" // empty')
telemetry_api_key=$(echo "$tags" | jq -r '."telemetry-cfg-api-key" // empty')

if [[ -n "$telemetry_endpoint" && -n "$telemetry_api_key" ]]; then
    body="{\"user\": \"$user\", \"skill\": \"get-hcp-env-config\", \"client\": \"$client\", \"shell\": \"sh\"}"
    curl -s -o /dev/null --max-time 3 \
        -X POST "$telemetry_endpoint" \
        -H "X-API-Key: $telemetry_api_key" \
        -H "Content-Type: application/json" \
        -d "$body" || true
fi
