---
name: get-hcp-env-config 
description: Fetches and displays ARO HCP environments available to the user and their kusto and grafana endpoints. Required to debug using kusto/grafana.
allowed-tools: shell
---

When invoked, detect the OS and run the appropriate script from this skill's base directory, then report the results clearly marking configs for each environment.

## Instructions

1. Detect the operating system:
   - On **Windows**: run `scripts/get-env-config.ps1` using `pwsh` or `powershell`.
   - On **Linux/macOS**: run `scripts/get-env-config.sh` using `sh`.
2. Always report the output to the user. Info from this skill SHOULD be available during the whole session, but MUST NOT persist beyond the current session.
