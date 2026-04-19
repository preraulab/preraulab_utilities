---
hide-toc: false
---

# utils

General-purpose MATLAB utilities used across the Prerau Lab codebase — binning, conversions, figure layout, plotting helpers, statistics, file and workspace management.

A toolbox of small, composable functions that smooth over MATLAB's rough edges and give us a consistent vocabulary across projects.

```{admonition} Standalone + bundled
:class: tip
This repository is a self-contained submodule of
[`labcode_main`](https://github.com/preraulab/labcode_main). It can also be
cloned and used on its own — it has no dependencies on the rest of the
codebase.
```

## Browse by category

::::{grid} 2 2 3 3
:gutter: 3
:class-container: sd-mb-4

:::{grid-item-card} Binning
:link: categories/binning
:link-type: doc

1-D and N-D binning, sliding-window histograms.

**Functions:** `create_bins`, `create_NDbins`, `hist_slide`
:::

:::{grid-item-card} Conversion
:link: categories/conversion
:link-type: doc

Type, format, and representation conversions — numbers to strings, structs to name-value cells, tables ↔ CSV.

**11 functions**
:::

:::{grid-item-card} Data Processing
:link: categories/data_processing
:link-type: doc

Generic signal and index manipulation — consecutive runs, chunk detection, interval arithmetic.

**6 functions**
:::

:::{grid-item-card} Figure Tools
:link: categories/fig_tools
:link-type: doc

Figure layout, axes linking, interactive controls — the plumbing for good-looking multi-panel figures.

**23 functions**
:::

:::{grid-item-card} File
:link: categories/file
:link-type: doc

File I/O helpers.

**Functions:** `remove_copyright_lines`
:::

:::{grid-item-card} Graphical
:link: categories/graphical
:link-type: doc

Higher-level plot primitives — shaded bounds, Gantt charts, phase histograms, wireframes.

**10 functions**
:::

:::{grid-item-card} Statistics
:link: categories/stats
:link-type: doc

NaN-aware statistical helpers.

**Functions:** `nanzscore`, `nanpow2db`
:::

:::{grid-item-card} Workspace
:link: categories/workspace
:link-type: doc

Workspace management — clear, close, package.

**Functions:** `ccc`, `clear_all_except`, `packagecode`
:::

:::{grid-item-card} External Authors
:link: categories/external_authors
:link-type: doc

Vendored third-party utilities from MATLAB File Exchange.

**10 functions**
:::

::::

## Quick examples

### Consistent multi-panel figures

```matlab
ax = figdesign(2, 3);
letter_label(ax, 'A', 'TopLeft');
linkcaxes(ax);
scrollzoompan(ax(1), 'x');
```

### Bin and plot a point process

```matlab
[counts, edges] = create_bins(spike_times, 0.050);  % 50 ms bins
shadebounds((edges(1:end-1)+edges(2:end))/2, counts, counts+sqrt(counts), counts-sqrt(counts));
```

### Round-trip a struct to a command-line string

```matlab
opts = struct('Fs', 200, 'thresh', 3.5, 'verbose', true);
disp(struct2nvpstr(opts));
% -> 'Fs', 200, 'thresh', 3.5, 'verbose', true
```

## Install

```{code-block} matlab
addpath(genpath('/path/to/utils'));
savepath;   % optional
```

## Design principles

- **R2020a-compatible.** No `arguments` blocks, no name=value syntax, no `dictionary`.
- **Small, composable.** Each function does one thing; complex behavior comes from combinations.
- **NaN-aware where sensible.** Anything named `nan*` handles NaN gracefully.
- **No hidden state.** Interactive controls store per-axes `appdata`, never globals.
- **Canonical docstrings.** Every `.m` file uses the lab's `Usage`/`Inputs`/`Outputs`/`See also` format — readable with `help <function>`.

## Documentation map

```{toctree}
:maxdepth: 1
:caption: Categories

categories/binning
categories/conversion
categories/data_processing
categories/fig_tools
categories/file
categories/graphical
categories/stats
categories/workspace
categories/external_authors
```

## Repository

Source code: <https://github.com/preraulab/utils>

Parent codebase: <https://github.com/preraulab/labcode_main>
