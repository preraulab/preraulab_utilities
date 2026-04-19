# Graphical

Higher-level plot primitives — line + shaded bounds, Gantt charts, phase histograms, 3-D wireframes.

## When to use which

| Task | Use |
|---|---|
| Line plot with shaded confidence / error bounds | {mat:func}`shadebounds` |
| Circular / phase histogram (0–2π) | {mat:func}`phasehistogram` |
| Gantt-style timeline of events | {mat:func}`gantt` |
| Grouped box-charts with sensible defaults | {mat:func}`group_boxchart` |
| Linear-model fit + scatter plot | {mat:func}`lm_plot` |
| Matrix → RGB image (arbitrary colormap) | {mat:func}`mat2rgbpic` |
| Plot highlighted above/below a threshold | {mat:func}`threshold_plot` |
| Horizontal "number line" with a range marker | {mat:func}`range_numberline` |
| 3-D wireframe surface | {mat:func}`wireframe` |
| Smooth-and-decimate for fast plotting of very long signals | {mat:func}`conv_downsample` |

## Reference

```{toctree}
:maxdepth: 1

graphical/conv_downsample
graphical/gantt
graphical/group_boxchart
graphical/lm_plot
graphical/mat2rgbpic
graphical/phasehistogram
graphical/range_numberline
graphical/shadebounds
graphical/threshold_plot
graphical/wireframe
```
