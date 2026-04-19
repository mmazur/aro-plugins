---
name: kusto-info
description: Get an overview of a kusto cluster. List databases and tables, get their schemas. Use this for ARO-HCP debugging when you need to discover what log data is available — which databases exist, what tables they contain, and their column schemas. Run this before writing KQL queries if you don't already know the table structure. Use the `aro-hcp-env-info` skill first to get the kusto cluster URL.
allowed-tools: shell
---

## Instructions

1. Determine the Kusto cluster URL from context or by asking the user.
2. Detect the operating system and run the appropriate script:
   - On **macOS**: run `scripts/kusto.sh <subcommand> -Cluster CLUSTER [options]` using `zsh`.
   - On **Linux/WSL2**: run `scripts/kusto.sh <subcommand> -Cluster CLUSTER [options]` using `bash`.
   - On **Windows (non-WSL)**: run `scripts/kusto.ps1 <subcommand> -Cluster CLUSTER [options]` using `pwsh`.
3. To get an overview of a cluster run the following script commands in the following order:
   - `list-databases -Cluster https://mycluster.kusto.windows.net`
   - for each db of interest: `show-schema-all -Cluster https://mycluster.kusto.windows.net -Database DB`

## Reference

```
kusto (.ps1 and .sh) — Kusto cluster metadata (list databases, tables, schemas)

USAGE:
    kusto <subcommand> -Cluster <url> [-Database <name>] [options]

SUBCOMMANDS:
    list-databases              List all databases on the cluster
                                  Required: -Cluster
    show-tables                 List all tables in a database
                                  Required: -Cluster, -Database
    show-schema                 Show schema for a single table (as JSON)
                                  Required: -Cluster, -Database, -Table
    show-schema-all             Show full database schema (as JSON)
                                  Required: -Cluster, -Database

GLOBAL OPTIONS:
    -Cluster <url>              Kusto cluster URL (required)
                                  e.g. https://mycluster.region.kusto.windows.net
    -Database <name>            Database name (required except for list-databases)
    -Table <name>               Table name (required for show-schema)
    -MaxRecords <int>           Row limit (default: 1000, 0 = unlimited)

EXAMPLES:
    kusto list-databases -Cluster https://mycluster.region.kusto.windows.net
    kusto show-tables -Cluster https://mycluster.region.kusto.windows.net -Database mydb
    kusto show-schema -Cluster https://mycluster.region.kusto.windows.net -Database mydb -Table mytable
    kusto show-schema-all -Cluster https://mycluster.region.kusto.windows.net -Database mydb
```
