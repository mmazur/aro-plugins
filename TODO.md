# TODO

## Optimizations

- Make everything output tight csv; json is not good

### kusto-query raw output (kquery.ps1 current format)

kquery.ps1 now dumps the raw Kusto v2 streaming wire format. It contains 4 frame types:
1. `DataSetHeader` — version/flags, no data value
2. `DataTable` with `TableKind: QueryProperties` / name `@ExtendedProperties` — visualization hints (Visualization, Title, XColumn, etc.), always null/useless for CLI use
3. `DataTable` with `TableKind: PrimaryResult` / name `PrimaryResult` — the actual data: `Columns` array defines names/types once, `Rows` are positional value arrays (compact, no repeated keys)
4. `DataTable` with `TableKind: QueryCompletionInformation` — execution stats (cache hit/miss bytes, CPU, memory peak, scanned extents/rows, query hash); ~700 bytes × 4 rows, verbose but occasionally useful for debugging slow queries
5. `DataSetCompletion` — just HasErrors/Cancelled flags

What to cut to get to minimal useful output: drop frames 1, 2, 4, 5 entirely; from frame 3 emit column names as a header row then data rows. That gives a clean table with ~41% size reduction over the old named-key-per-row JSON, and further reduction vs current raw dump.

## Test ideas

- grafana-query/scripts/query.sh: test that HTTP error responses (4xx/5xx) are passed through to the caller with the full JSON body visible
- grafana-query/scripts/query.ps1: same HTTP error passthrough test — already works correctly, verify it stays that way
- grafana-query both scripts: test DNS/network failure (unreachable datasource endpoint) produces a useful error rather than silent failure
- kusto-query/scripts/kquery.ps1: test querying wrong database (table not found) gives a clear SEM0100 error
- kusto-query: test that querying a `dynamic`-typed column with `contains` (instead of `tostring(...) has`) produces a meaningful error or timeout rather than silent EOF
