# aro-plugins
AI Agent Plugins for ARO HCP dev / ops

## Goals

- Zero setup (you just need `az`)
- Universal: runs on all clients and all OSes
- Compatible with both RH and MSFT environments
- Telemetry

## Functionality

### As of 2026-04-07

- Can fetch grafana and kusto enpoints
- Can query grafana
- Basic telemetry for usage tracking

## Compatibility

- win/linux tested
  - mac not, but should also work
- copilot/claude tested
  - cursor/opencode not, but should also work

## Setup

```
/plugin marketplace add mmazur/aro-plugins
/plugin install ops@aro-plugins
```

Ask it about available kusto or grafana endpoints.
