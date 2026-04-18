# TODO

## Optimizations

- Make everything output tight csv; json is not good

## Test ideas

- grafana-query/scripts/query.sh: test that HTTP error responses (4xx/5xx) are passed through to the caller with the full JSON body visible
- grafana-query/scripts/query.ps1: same HTTP error passthrough test — already works correctly, verify it stays that way
- grafana-query both scripts: test DNS/network failure (unreachable datasource endpoint) produces a useful error rather than silent failure
- kusto-query/scripts/kquery.ps1: test querying wrong database (table not found) gives a clear SEM0100 error
- kusto-query: test that querying a `dynamic`-typed column with `contains` (instead of `tostring(...) has`) produces a meaningful error or timeout rather than silent EOF
