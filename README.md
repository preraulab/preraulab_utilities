# utils

General-purpose MATLAB utilities used across the Prerau Lab codebase — binning, conversions, figure layout, plotting helpers, statistics, file and workspace management. A toolbox of small, composable functions that smooth over MATLAB's rough edges and give us a consistent vocabulary across projects.

This is one of several submodules of [`labcode_main`](https://github.com/preraulab/labcode_main). It can also be used standalone.

## What's here

The repo is organized by function type. Each directory is a self-contained category:

| Directory | What's in it | Example |
|---|---|---|
| [`binning/`](#binning) | 1-D and N-D binning, sliding-window histograms | `create_bins`, `create_NDbins`, `hist_slide` |
| [`conversion/`](#conversion) | Type, format, and representation conversions | `struct2nvp`, `double2pifracstr`, `csv2table` |
| [`data_processing/`](#data-processing) | Generic signal / index manipulation | `consecutive_runs`, `get_chunks`, `percentile_filt` |
| [`fig_tools/`](#fig-tools) | Figure layout, axes linking, interactive controls | `figdesign`, `scrollzoompan`, `letter_label` |
| [`graphical/`](#graphical) | Higher-level plot primitives | `shadebounds`, `gantt`, `phasehistogram` |
| [`stats/`](#stats) | Statistical helpers robust to NaN | `nanzscore`, `nanpow2db` |
| [`workspace/`](#workspace) | Workspace management | `ccc`, `clear_all_except`, `packagecode` |

> **Third-party utilities.** File Exchange / community utilities that `utils` code depends on (e.g., `suptitle`, `progressbar`, `sigstar`) live in the private [`external_utils`](https://github.com/preraulab/external_utils) repo to keep this repo entirely lab-owned BSD-3. If `suptitle` is missing when you call a lab function, add `external_utils` to your path.

## Install

Clone the repo and add it to your MATLAB path:

```matlab
addpath(genpath('/path/to/utils'));
savepath;   % optional, persists across sessions
```

When used as part of `labcode_main`, the top-level path setup handles this automatically.

### Dependencies

- **MATLAB R2020a or later** (uses `string`/`char` interoperability, `arguments`-free style).
- **No required toolboxes** for the core. Signal Processing Toolbox improves a few plotting helpers.

## Quick tour

### Binning

Need to bin spikes, events, or values by time or some other continuous variable?

```matlab
% 1-D binning
[counts, edges, bin_idx] = create_bins(values, bin_width);

% N-D binning
[counts, edges, bin_idx] = create_NDbins(points, bin_widths_per_dim);

% Sliding-window histogram — counts in overlapping windows
[counts, centers] = hist_slide(x, window, step);
```

### Conversion

Format numbers, structs, and tables cleanly for display, logging, or round-tripping between code and data:

```matlab
struct2nvp(s)          % struct -> {'k1', v1, 'k2', v2, ...} name-value cell
struct2nvpstr(s)       % struct -> "'k1', v1, 'k2', v2" string (code-ready)
struct2codestr(s)      % struct -> literal 'struct(''k'', v, ...)' code text
double2pifracstr(x)    % 3.14159 -> 'π', 1.5708 -> 'π/2', etc.
double2fracstr(x)      % 0.3333 -> '1/3'
double2estr(x)         % 1e-5 -> '10^{-5}' for axis labels
csv2table / table2csv  % quick MATLAB table <-> CSV round-trips
```

### Data processing

Utility functions that come up over and over in time-series work:

```matlab
[runs, inds] = consecutive_runs(logical_vec);   % group contiguous runs
ix = findclosest(array, query);                 % nearest-neighbor index
chunks = get_chunks(signal, Fs);                % find NaN/flat/valid chunks
out = interval_intersect(a, b);                 % interval arithmetic
out = percentile_filt(x, window, ptile);        % rolling percentile filter
```

### Figure tools

Consistent, good-looking multi-panel figures with ergonomic interactivity:

```matlab
ax = figdesign(2, 3, 'margins', [0.05 0.05 0.05 0.05 0.05]);  % clean multi-axis layout
letter_label(ax, 'A', 'TopLeft');                              % panel labels A/B/C...
linkcaxes(ax);                                                 % shared color axes
scrollzoompan(ax(1), 'x');                                     % scroll/pan/zoom via mouse + keys
climscale(ax, 0.01);                                           % robust color limits
equalize_axes(ax, 'xy');                                       % match x/y lims across panels
```

### Graphical primitives

Plot types that aren't quite built-in but come up constantly:

```matlab
shadebounds(x, y, upper, lower);     % line + shaded confidence band
phasehistogram(phases, nbins);       % circular/phase histogram
gantt(starts, durations, groups);    % Gantt-style event timeline
group_boxchart(data, groups);        % grouped box plots with sensible defaults
wireframe(X, Y, Z);                  % clean 3-D wireframe surface
conv_downsample(y, target_N);        % smooth + decimate for fast large-data plotting
```

### Stats

```matlab
z   = nanzscore(x);     % z-score ignoring NaNs
dB  = nanpow2db(power); % dB conversion ignoring NaNs
```

### Workspace

```matlab
ccc;                                    % clear all; close all hidden; clc
clear_all_except({'keep_this', ...});  % selective clear
packagecode(entry_fn);                 % bundle entry_fn + its deps into a folder
```

## Design conventions

- **Canonical docstring format.** Every function uses the lab's canonical format: `Usage`, `Inputs`, `Name-Value Pairs`, `Outputs`, `See also`. Run `help <function_name>` at the MATLAB prompt.
- **R2020a-compatible.** No `arguments` blocks, no name=value call syntax, no `dictionary`. Input validation uses `inputParser`.
- **NaN-aware where sensible.** Anything named `nan*` handles NaN input gracefully (e.g., `nanzscore`).
- **Small, composable.** Functions do one thing. Complex behavior comes from combining them, not from mega-functions with 20 name-value pairs.
- **No hidden state.** Utilities don't rely on or mutate globals. Interactive controls (e.g., `linkcaxes`, `scrollzoompan`) store their state in figure/axes `appdata`, not in globals.

## Contributing

Before adding a new utility:

1. **Check for an existing function.** `grep -r 'your_functionality' .` — we've accumulated a lot.
2. **Use the template.** Start from [`templates/newfunction.m`](https://github.com/preraulab/templates) to get the canonical docstring structure.
3. **Pick the right directory.** `fig_tools/` is for axes/figure plumbing; `graphical/` is for plot primitives a user calls directly. `data_processing/` is for index/array manipulation; `conversion/` is for format conversions.
4. **Add a `See also:` line** linking to related functions in the same category.

## Documentation

Full API reference: **https://preraulab.github.io/utils/**

The site is auto-built from docstrings on every push to `master`. Each function's help text appears in the API section, cross-linked to related functions.

## Citation

If you use this in published work, please cite the umbrella codebase:

> Prerau Laboratory — MATLAB Analysis Codebase. https://github.com/preraulab/labcode_main

Individual functions have their own `See also:` references to original papers where applicable (e.g., `scrollzoompan` traces to standard axes-linking patterns; statistical primitives are textbook).

## License

BSD 3-Clause. See [`LICENSE`](LICENSE).
