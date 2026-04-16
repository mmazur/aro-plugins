---
name: kusto-cluster-info
description: Get an overview of a kusto cluster. List databases and tables, get their schemas.
allowed-tools: shell
---

## Arguments

- **Cluster** (required): An URL to a kusto cluster (e.g. `https://my-cluster.kusto.windows.net`). Infer from context if obvious; otherwise ask the user.

## Instructions

1. Determine the Kusto cluster URL from context or by asking the user.
2. Detect the operating system and run the appropriate script, passing the URL as the first argument:
   - On **Windows (non-WSL)**: run `scripts/kusto.ps1` using `pwsh`.
   - On other OSes -- try running the pwsh script. If pwsh not available, say python version coming soon.
3. To get an overview of a cluster run the following script commands in the following order:
   - `list-databases -Cluster https://mycluster.kusto.windows.net`
   - for each db of interest: `show-schema-all -Cluster https://mycluster.kusto.windows.net -Database DB`

## Reference

```
SUBCOMMANDS:
    list-databases              List all databases on the cluster
                                  Required: -Cluster
    show-tables                 List all tables in a database
                                  Required: -Cluster, -Database
    show-schema                 Show schema for a single table (as JSON)
                                  Required: -Cluster, -Database, -Table
    show-schema-all             Show full database schema (as JSON)
                                  Required: -Cluster, -Database
    query -Kql <kql_string>     Run an arbitrary KQL query
                                  Required: -Cluster, -Database, -Kql

GLOBAL OPTIONS:
    -Cluster <url>              Kusto cluster URL (required)
                                  e.g. https://mycluster.region.kusto.windows.net
    -Database <name>            Database name (required except for list-databases)
    -Kql <kql_string>           KQL query string (required for query subcommand)
    -Table <name>               Table name (required for show-schema)
    -MaxRecords <int>           Row limit (default: 1000, 0 = unlimited)

EXAMPLES:
    .\kusto.ps1 list-databases -Cluster https://mycluster.region.kusto.windows.net
    .\kusto.ps1 show-tables -Cluster https://mycluster.region.kusto.windows.net -Database mydb
    .\kusto.ps1 show-schema -Cluster https://mycluster.region.kusto.windows.net -Database mydb -Table mytable
    .\kusto.ps1 show-schema-all -Cluster https://mycluster.region.kusto.windows.net -Database mydb
    .\kusto.ps1 query -Cluster https://mycluster.region.kusto.windows.net -Database mydb -Kql "StormEvents | take 10"
```
