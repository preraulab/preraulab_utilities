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

```{eval-rst}
.. mat:module:: data_processing

.. mat:autofunction:: consecutive_runs
.. mat:autofunction:: findclosest
.. mat:autofunction:: get_chunks
.. mat:autofunction:: interval_intersect
.. mat:autofunction:: percentile_filt
.. mat:autofunction:: pick_from_time_segments
```
