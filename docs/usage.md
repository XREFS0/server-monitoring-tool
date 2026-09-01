# Usage Guide

The Server Monitoring Tool provides multiple modes of operation.

## Dashboard Mode

Run without arguments or with `--dashboard` to view the interactive real-time dashboard.

```bash
server-monitor --dashboard
```

## Watch Mode

To continuously monitor the dashboard, use `--watch`.

```bash
server-monitor --watch --interval 2
```

## CLI Metrics

You can query individual components:

- `--cpu`
- `--memory`
- `--disk`
- `--network`
- `--processes`
- `--services`
- `--ports`
- `--health`

## JSON Output

To get machine-readable output:

```bash
server-monitor --json
```

## Exit Codes

- 0 = OK
- 1 = Warning
- 2 = Critical
- 3 = Argument Error
- 4 = Runtime Error
