# utils

Meta-repository bundling the Prerau Lab's general-purpose MATLAB utilities — binning, conversions, figure layout, plotting primitives, statistics, and workspace management.

Each category is a standalone repository that can be used on its own. This repo aggregates them as git submodules so `labcode_main` (and anyone who wants the whole toolbox) can pull everything in one clone.

## Submodules

| Submodule | What's in it | Example functions |
|---|---|---|
| [`binning`](https://github.com/preraulab/binning) | 1-D and N-D binning, sliding-window histograms | `create_bins`, `create_NDbins`, `hist_slide` |
| [`conversion`](https://github.com/preraulab/conversion) | Type, format, and representation conversions | `struct2nvp`, `double2pifracstr`, `csv2table` |
| [`data_processing`](https://github.com/preraulab/data_processing) | Generic signal / index manipulation | `consecutive_runs`, `get_chunks`, `percentile_filt` |
| [`fig_tools`](https://github.com/preraulab/fig_tools) | Figure layout, axes linking, interactive controls | `figdesign`, `scrollzoompan`, `letter_label` |
| [`graphical`](https://github.com/preraulab/graphical) | Higher-level plot primitives | `shadebounds`, `gantt`, `phasehistogram` |
| [`stats`](https://github.com/preraulab/stats) | NaN-aware statistical helpers | `nanzscore`, `nanpow2db` |
| [`workspace`](https://github.com/preraulab/workspace) | Workspace management | `ccc`, `clear_all_except`, `packagecode` |

Each sub-repo has its own README with function tables and usage examples — click any submodule name above.

> **Third-party utilities.** File Exchange / community utilities that lab code depends on (e.g., `suptitle`, `progressbar`, `sigstar`) live in the private [`external_utils`](https://github.com/preraulab/external_utils) repo so this toolbox stays entirely lab-owned BSD-3. Add it to your path separately if needed.

## Install

Clone recursively to pull all submodules:

```bash
git clone --recursive git@github.com:preraulab/utils.git
```

Or, if you've already cloned:

```bash
git submodule update --init --recursive
```

Add everything to your MATLAB path:

```matlab
addpath(genpath('/path/to/utils'));
savepath;   % optional, persists across sessions
```

When used as part of `labcode_main`, the top-level path setup handles this automatically.

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

## Contributing

Before adding a new utility:

1. **Pick the right sub-repo.** `fig_tools` is for axes/figure plumbing; `graphical` is for plot primitives a user calls directly. `data_processing` is for index/array manipulation; `conversion` is for format conversions.
2. **Start from the lab template.** Use [`templates/newfunction.m`](https://github.com/preraulab/templates) to get the canonical docstring structure.
3. **Commit to the appropriate sub-repo**, not this meta-repo. Then bump the submodule pointer here.
4. **Add a `See also:` line** linking to related functions in the same category.

## Citation

```
Prerau Laboratory — MATLAB Analysis Codebase.
https://github.com/preraulab/labcode_main
```

## License

Each sub-repo is individually licensed BSD 3-Clause. This meta-repo's `LICENSE` follows suit; see [`LICENSE`](LICENSE).
