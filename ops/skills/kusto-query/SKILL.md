---
name: kusto-query
description: Run KQL queries against ARO-HCP kusto clusters to search logs, investigate errors, and debug issues. Use this whenever the user wants to check ARO HCP underlay (mgmt/svc clusters) and data plane (HCPs) provisioning logs, find error messages, investigate cluster lifecycle events, query resource status, or analyze operational data. Requires a cluster URL and database name — use `aro-hcp-env-info` to get the cluster URL and `kusto-info` to explore available tables if needed.
allowed-tools: shell
---

## Arguments

- **Cluster** (required): An URL to a kusto cluster (e.g. `https://my-cluster.kusto.windows.net`).
- **Database** (required): Database to run the query against.
- **Kql** (required): The KQL query to run.

## Instructions

1. Determine the Kusto cluster URL and Database from context. If not present, use the `kusto-info` skill.
2. Prepare a KQL query.
2. Detect the operating system and run the appropriate script:
   - On **macOS**: run `scripts/kquery.sh -Cluster CLUSTER -Database DB -Kql QUERY` using `zsh`.
   - On **Linux/WSL2**: run `scripts/kquery.sh -Cluster CLUSTER -Database DB -Kql QUERY` using `bash`.
   - On **Windows (non-WSL)**: run `scripts/kquery.ps1 -Cluster CLUSTER -Database DB -Kql QUERY` using `pwsh`.

### Output

The raw JSON response from the Kusto REST API is returned as-is. If the result set is truncated due to `-MaxRecords` being hit, the response will contain an additional row entry with a `OneApiErrors` field indicating truncation.

## Reference

```
kquery (.ps1 and .sh) — Run arbitrary KQL queries against Kusto

USAGE:
    kquery -Cluster <url> -Database <name> -Kql <kql_string> [options]

REQUIRED:
    -Cluster <url>              Kusto cluster URL
                                  e.g. https://mycluster.region.kusto.windows.net
    -Database <name>            Database name
    -Kql <kql_string>           KQL query or control command

OPTIONS:
    -MaxRecords <int>           Row limit (default: 1000, 0 = unlimited)

EXAMPLES:
    .\kquery -Cluster https://mycluster.region.kusto.windows.net -Database mydb -Kql "MyTable | take 10"
    .\kquery -Cluster https://mycluster.region.kusto.windows.net -Database mydb -Kql "MyTable | summarize count() by col" -MaxRecords 0
```
