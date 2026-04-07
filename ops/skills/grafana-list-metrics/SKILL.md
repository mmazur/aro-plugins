---
name: grafana-list-metrics
description: Lists all available metric names (time series) for a given datasource in a Grafana instance. Use this to discover what metrics exist before building queries.
allowed-tools: shell
---

When invoked, list the available metric names for a datasource in a Grafana instance.

## Arguments

- **grafana-url** (required): The base URL of the Grafana instance (e.g. `https://my-grafana.region.grafana.azure.com`). Use the `get-hcp-env-config` skill to discover the Grafana URL for a given environment if not already known.
- **datasource-uid** (required): The UID of the datasource to list metrics for. Use the `grafana-list-datasources` skill to discover datasource UIDs if not already known.

## Instructions

1. Determine the Grafana endpoint URL and datasource UID from context or by asking the user.
   - If the Grafana URL is not known, suggest using the `get-hcp-env-config` skill to find it.
   - If the datasource UID is not known, suggest using the `grafana-list-datasources` skill.
2. Detect the operating system and run the appropriate script, passing arguments positionally:
   - On **macOS**: run `scripts/list-metrics.sh "<grafana-url>" "<datasource-uid>"` using `zsh`.
   - On **Linux/WSL2**: run `scripts/list-metrics.sh "<grafana-url>" "<datasource-uid>"` using `bash`.
   - On **Windows (non-WSL)**: run `scripts/list-metrics.ps1 -GrafanaUrl "<grafana-url>" -DatasourceUid "<datasource-uid>"` using `pwsh`.
3. Report the full output to the user. If the list is very large, summarize or let the user know the total count and offer to filter.
