# Figure Tools

Figure layout, axes linking, interactive controls — the plumbing for good-looking multi-panel figures.

## Layout

| Task | Use |
|---|---|
| Lay out an `M × N` grid with controlled margins | {mat:func}`figdesign` |
| Open a full-screen figure | {mat:func}`fullfig` |
| Add panel labels (A, B, C, …) | {mat:func}`letter_label` |
| Add a figure-level title/labels across subplots | {mat:func}`outertitle`, {mat:func}`outerlabels` |
| Merge multiple figures into one | {mat:func}`mergefigures` |
| Prep a figure for print / page export | {mat:func}`pagefig` |
| Find the most-square subplot grid for N panels | {mat:func}`squarest_subplots` |

## Axes linking & limits

| Task | Use |
|---|---|
| Link color axes across a set of axes | {mat:func}`linkcaxes` |
| Link 3-D camera + xyz limits across axes | {mat:func}`linkaxes3d` |
| Match X/Y limits across axes | {mat:func}`equalize_axes` |
| Scale color limits to an inner percentile | {mat:func}`climscale` |
| Set color limits manually | {mat:func}`clims` |

## Colorbars & annotations

| Task | Use |
|---|---|
| Add a colorbar that doesn't resize the parent axes | {mat:func}`colorbar_noresize` |
| Add a colorbar along the top | {mat:func}`topcolorbar` |
| Draw a scale bar on an axis | {mat:func}`scaleline` |
| Add a shadow / secondary axis | {mat:func}`shadow_axis` |
| Split an axis into multiple panels | {mat:func}`split_axis` |

## Interaction

| Task | Use |
|---|---|
| Interactive scroll/zoom/pan with mouse + keyboard | {mat:func}`scrollzoompan` |
| Capture user clicks on a figure | {mat:func}`get_clicks` |
| Pop up a slice picker UI | {mat:func}`slicepopup` |
| Zoom so content fills the axes | {mat:func}`zoom_fill` |
| Build a stacked-plot control | {mat:func}`stacked_plot` |

## Reference

```{toctree}
:maxdepth: 1

fig_tools/clims
fig_tools/climscale
fig_tools/colorbar_noresize
fig_tools/equalize_axes
fig_tools/figdesign
fig_tools/fullfig
fig_tools/get_clicks
fig_tools/letter_label
fig_tools/linkaxes3d
fig_tools/linkcaxes
fig_tools/mergefigures
fig_tools/outerlabels
fig_tools/outertitle
fig_tools/pagefig
fig_tools/scaleline
fig_tools/scrollzoompan
fig_tools/shadow_axis
fig_tools/slicepopup
fig_tools/split_axis
fig_tools/squarest_subplots
fig_tools/stacked_plot
fig_tools/topcolorbar
fig_tools/zoom_fill
```
