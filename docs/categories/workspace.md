# Workspace

Workspace management.

## When to use which

| Task | Use |
|---|---|
| Clear all / close all figures / clear command window | {mat:func}`ccc` |
| Clear all variables *except* a specified list | {mat:func}`clear_all_except` |
| Bundle a function + every file it calls into a folder | {mat:func}`packagecode` |

```{warning}
{mat:func}`ccc` mutates the caller's workspace and closes figures. Intended
for interactive sessions, not scripts or functions that other code depends on.
```

## Reference

```{toctree}
:maxdepth: 1

workspace/ccc
workspace/clear_all_except
workspace/packagecode
```
