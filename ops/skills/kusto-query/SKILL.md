---
name: kusto-query
description: Run KQL queries against kusto clusters.
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
   - On **Windows (non-WSL)**: run `scripts/kquery.ps1 -Cluster CLUSTER -Database DB -Kql QUERY` using `pwsh`.
   - On other OSes -- try running the pwsh script. If pwsh not available, say python version coming soon.

## Reference

```
kquery.ps1 — Run arbitrary KQL queries against Kusto

USAGE:
    kquery.ps1 -Cluster <url> -Database <name> -Kql <kql_string> [options]

REQUIRED:
    -Cluster <url>              Kusto cluster URL
                                  e.g. https://mycluster.region.kusto.windows.net
    -Database <name>            Database name
    -Kql <kql_string>           KQL query or control command

OPTIONS:
    -MaxRecords <int>           Row limit (default: 1000, 0 = unlimited)

EXAMPLES:
    .\kquery.ps1 -Cluster https://mycluster.region.kusto.windows.net -Database mydb -Kql "MyTable | take 10"
    .\kquery.ps1 -Cluster https://mycluster.region.kusto.windows.net -Database mydb -Kql "MyTable | summarize count() by col" -MaxRecords 0
```
