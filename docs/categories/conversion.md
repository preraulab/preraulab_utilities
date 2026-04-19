# Conversion

Type, format, and representation conversions — numbers to strings, structs to name-value cells, tables ↔ CSV.

## When to use which

| Task | Use |
|---|---|
| Format double as an exponential string (for axis labels) | {mat:func}`double2estr`, {mat:func}`double2expstr` |
| Format double as a fraction | {mat:func}`double2fracstr` |
| Format double as a multiple of π | {mat:func}`double2pifracstr` |
| Generic value → string | {mat:func}`value2str` |
| Convert a numeric array to a cell of strings | {mat:func}`num2cellstr` |
| Struct → `{'k1', v1, ...}` cell (ready for `varargin`) | {mat:func}`struct2nvp` |
| Struct → `'k1', v1, ...` string (for code) | {mat:func}`struct2nvpstr` |
| Struct → literal MATLAB code text | {mat:func}`struct2codestr` |
| MATLAB table ↔ CSV | {mat:func}`table2csv`, {mat:func}`csv2table` |

## Reference

```{toctree}
:maxdepth: 1

conversion/csv2table
conversion/double2estr
conversion/double2expstr
conversion/double2fracstr
conversion/double2pifracstr
conversion/num2cellstr
conversion/struct2codestr
conversion/struct2nvp
conversion/struct2nvpstr
conversion/table2csv
conversion/value2str
```
