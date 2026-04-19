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

```{eval-rst}
.. mat:module:: fig_tools

.. mat:autofunction:: clims
.. mat:autofunction:: climscale
.. mat:autofunction:: colorbar_noresize
.. mat:autofunction:: equalize_axes
.. mat:autofunction:: figdesign
.. mat:autofunction:: fullfig
.. mat:autofunction:: get_clicks
.. mat:autofunction:: letter_label
.. mat:autofunction:: linkaxes3d
.. mat:autofunction:: linkcaxes
.. mat:autofunction:: mergefigures
.. mat:autofunction:: outerlabels
.. mat:autofunction:: outertitle
.. mat:autofunction:: pagefig
.. mat:autofunction:: scaleline
.. mat:autofunction:: scrollzoompan
.. mat:autofunction:: shadow_axis
.. mat:autofunction:: slicepopup
.. mat:autofunction:: split_axis
.. mat:autofunction:: squarest_subplots
.. mat:autofunction:: stacked_plot
.. mat:autofunction:: topcolorbar
.. mat:autofunction:: zoom_fill
```
