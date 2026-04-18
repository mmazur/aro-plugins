---
name: grafana-query
description: Runs a query against any datasource in a Grafana instance. Works with Prometheus (promql) and any other connected datasource.
allowed-tools: shell
---

When invoked, execute a query against a datasource via the Grafana unified query API.

## Arguments

- **grafana-url** (required): The base URL of the Grafana instance (e.g. `https://my-grafana.region.grafana.azure.com`). Use the `aro-hcp-env-info` skill to discover the Grafana URL for a given environment if not already known.
- **query-json** (required): A JSON string containing the full query body to send. The structure depends on the datasource type. See example below.

## Query JSON example

**Prometheus / Thanos:**
```json
{"queries":[{"refId":"A","datasource":{"uid":"DATASOURCE_UID","type":"prometheus"},"expr":"up","instant":true}],"from":"now-1h","to":"now"}
```

## Instructions

1. Determine the Grafana endpoint URL and query from context or by asking the user.
   - If the Grafana URL is not known, use `aro-hcp-env-info` skill.
   - If `DATASOURCE_UID` (`uid`) is not known, use `grafana-info` skill to list datasources.
   - If metrics to query aren't known, use `grafana-info` skill to list metrics — it's more efficient than a raw query.
2. Build the query JSON appropriate for the datasource type.
3. Detect the operating system and run the appropriate script, passing arguments positionally:
   - On **macOS**: run `scripts/query.sh "<grafana-url>" '<query-json>'` using `zsh`.
   - On **Linux/WSL2**: run `scripts/query.sh "<grafana-url>" '<query-json>'` using `bash`.
   - On **Windows (non-WSL)**: run `scripts/query.ps1 -GrafanaUrl "<grafana-url>" -QueryJson '<query-json>'` using `pwsh`.
