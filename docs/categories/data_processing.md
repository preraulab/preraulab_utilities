# Data Processing

Generic signal and index manipulation — consecutive runs, chunk detection, interval arithmetic.

## When to use which

| Task | Use |
|---|---|
| Group contiguous true / equal runs in a vector | {mat:func}`consecutive_runs` |
| Find the index of the nearest value | {mat:func}`findclosest` |
| Detect chunks (valid vs NaN / flat stretches) | {mat:func}`get_chunks` |
| Intersect two sets of time intervals | {mat:func}`interval_intersect` |
| Rolling percentile filter | {mat:func}`percentile_filt` |
| Slice a signal by a list of `[start end]` intervals | {mat:func}`pick_from_time_segments` |

## Reference

```{toctree}
:maxdepth: 1

data_processing/consecutive_runs
data_processing/findclosest
data_processing/get_chunks
data_processing/interval_intersect
data_processing/percentile_filt
data_processing/pick_from_time_segments
```
