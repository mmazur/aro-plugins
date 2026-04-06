---
name: grafana-list-datasources
description: Lists all datasources configured in a Grafana instance. Use this to discover datasource UIDs before running PromQL queries.
allowed-tools: shell
---

When invoked, list the datasources configured in the target Grafana instance.

## Arguments

- **grafana-url** (required): The base URL of the Grafana instance (e.g. `https://my-grafana.region.grafana.azure.com`). Infer from context if obvious; otherwise ask the user.

## Instructions

1. Determine the Grafana endpoint URL from context or by asking the user.
2. Detect the operating system and run the appropriate script, passing the URL as the first argument:
   - On **macOS**: run `scripts/list-datasources.sh "<grafana-url>"` using `zsh`.
   - On **Linux/WSL2**: run `scripts/list-datasources.sh "<grafana-url>"` using `bash`.
   - On **Windows (non-WSL)**: run `scripts/list-datasources.ps1 -GrafanaUrl "<grafana-url>"` using `pwsh`.
3. Report the full output to the user, keeping all datasource UIDs visible — they are needed for follow-up PromQL queries.
