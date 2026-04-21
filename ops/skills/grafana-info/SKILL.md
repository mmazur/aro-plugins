---
name: grafana-info
description: Discover datasources and available Prometheus (and other) metrics in an ARO-HCP Grafana instance. Use this when the user wants to know what metrics are being collected, find the right datasource UID, or explore available metric names before querying. Run this before `grafana-query` — it provides the datasource UIDs and metric names that queries require. Use `aro-hcp-env-info` first to get the Grafana URL.
allowed-tools: shell
---

When invoked, discover datasources and metrics in the target Grafana instance.

## Arguments

- **grafana-url** (required): The base URL of the Grafana instance (e.g. `https://my-grafana.region.grafana.azure.com`). Use the `aro-hcp-env-info` skill to discover the Grafana URL for a given environment if not already known.

## Instructions

1. Start with listing datasources.
2. If you know which datasources are of interests, list their metrics.
3. Now you can run queries with `grafana-query` skill.

### Listing datasources

Use this to discover datasource UIDs needed for queries.

1. Determine the Grafana endpoint URL from context or by asking the user.
2. Detect the operating system and run the appropriate script:
   - On **macOS**: run `scripts/list-datasources.sh -GrafanaUrl "<grafana-url>"` using `zsh`.
   - On **Linux/WSL2**: run `scripts/list-datasources.sh -GrafanaUrl "<grafana-url>"` using `bash`.
   - On **Windows (non-WSL)**: run `scripts/list-datasources.ps1 -GrafanaUrl "<grafana-url>"` using `pwsh`.
3. Report output to user, keep all datasource UIDs visible — they are needed for follow-up queries.
   - If there are prometheus datasources named like: hcps-cc/hcps-ccc or services-cc/services-ccc (two or three characters after '-'), report them as obsolete and not to be used.

### Listing metrics

Use this to discover what metrics exist for a datasource before building queries.

1. Determine the Grafana endpoint URL and datasource UID from context or by asking the user.
   - If the datasource UID is not known, list datasources first (see above).
2. Detect the operating system and run the appropriate script:
   - On **macOS**: run `scripts/list-metrics.sh -GrafanaUrl "<grafana-url>" -DatasourceUid "<datasource-uid>"` using `zsh`.
   - On **Linux/WSL2**: run `scripts/list-metrics.sh -GrafanaUrl "<grafana-url>" -DatasourceUid "<datasource-uid>"` using `bash`.
   - On **Windows (non-WSL)**: run `scripts/list-metrics.ps1 -GrafanaUrl "<grafana-url>" -DatasourceUid "<datasource-uid>"` using `pwsh`.
