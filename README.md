# preraulab_utilities

Meta-repository bundling the Prerau Lab's general-purpose MATLAB utilities — binning, conversions, figure layout, plotting primitives, statistics, workspace management, EDF I/O, and HTML-backed UI controls.

Each category is a standalone repository that can be used on its own. This repo aggregates them as git submodules so anyone who wants the whole toolbox can pull everything in one clone.

## Submodules

| Submodule | What's in it | Example / main entry |
|---|---|---|
| [`binning`](https://github.com/preraulab/binning) | 1-D and N-D binning, sliding-window histograms | `create_bins`, `create_NDbins`, `hist_slide` |
| [`conversion`](https://github.com/preraulab/conversion) | Type, format, and representation conversions | `struct2nvp`, `double2pifracstr`, `csv2table` |
| [`CSSuicontrols`](https://github.com/preraulab/CSSuicontrols) | CSS-styled HTML-backed UI controls for `uifigure` apps | `CSSuiButton`, `CSSuiDropdown`, `CSSuiListBox`, `SmoothProgressBar` |
| [`data_processing`](https://github.com/preraulab/data_processing) | Generic signal / index manipulation | `consecutive_runs`, `get_chunks`, `percentile_filt` |
| [`fig_tools`](https://github.com/preraulab/fig_tools) | Figure layout, axes linking, interactive controls | `figdesign`, `scrollzoompan`, `letter_label` |
| [`graphical`](https://github.com/preraulab/graphical) | Higher-level plot primitives | `shadebounds`, `gantt`, `phasehistogram` |
| [`read_EDF`](https://github.com/preraulab/read_EDF) | EDF/EDF+ reader with MEX acceleration | `read_EDF`, `header_gui` |
| [`nanstats`](https://github.com/preraulab/nanstats) | NaN-aware statistical helpers | `nanzscore`, `nanpow2db` |
| [`workspace`](https://github.com/preraulab/workspace) | Workspace management | `ccc`, `clear_all_except`, `packagecode` |

Each sub-repo has its own README with function tables and usage examples — click any submodule name above.

> **Third-party utilities.** File Exchange / community utilities that lab code depends on (e.g., `suptitle`, `progressbar`, `sigstar`) live in the private [`external_utils`](https://github.com/preraulab/external_utils) repo so this toolbox stays entirely lab-owned BSD-3. Add it to your path separately if needed.

## Install

Clone recursively to pull all submodules:

```bash
git clone --recursive git@github.com:preraulab/preraulab_utilities.git
```

Or, if you've already cloned:

```bash
git submodule update --init --recursive
```

Add everything to your MATLAB path:

```matlab
addpath(genpath('/path/to/preraulab_utilities'));
savepath;   % optional, persists across sessions
```

When used as part of a larger toolbox, the top-level path setup handles this automatically.

## Use a single category standalone

Any category can be cloned and used on its own:

```bash
git clone git@github.com:preraulab/graphical.git
```

See the individual sub-repo README for category-specific usage.

## Dependencies

- **MATLAB R2020a or later** (all sub-repos target this baseline).
- **No required toolboxes** for the core. Signal Processing Toolbox improves a few plotting helpers (noted per sub-repo).

## Design conventions (shared across all sub-repos)

- **Canonical docstring format.** Every function has `Usage`, `Inputs`, `Name-Value Pairs`, `Outputs`, `See also` sections. Run `help <function_name>`.
- **R2020a-compatible.** No `arguments` blocks, no name=value call syntax, no `dictionary`. Input validation uses `inputParser`.
- **NaN-aware where sensible.** Anything named `nan*` handles NaN input gracefully.
- **Small, composable.** Each function does one thing.
- **No hidden state.** Interactive controls store state in `appdata` on the target axes/figure, not in globals.

## Citation

```
Prerau Laboratory — MATLAB Analysis Codebase.
https://sleepEEG.org
```

## License

Each sub-repo is individually licensed BSD 3-Clause. This meta-repo's `LICENSE` follows suit; see [`LICENSE`](LICENSE).
