# Binning

Bin values or events onto regular grids, in 1-D or N-D, with fixed edges or a sliding window.

## When to use which

| Need | Use |
|---|---|
| Count values in fixed 1-D bins | {mat:func}`create_bins` |
| Count values on a multi-dimensional grid | {mat:func}`create_NDbins` |
| Count in overlapping windows (non-disjoint bins) | {mat:func}`hist_slide` |

## Reference

```{eval-rst}
.. mat:module:: binning

.. mat:autofunction:: create_bins
.. mat:autofunction:: create_NDbins
.. mat:autofunction:: hist_slide
```
