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

```{eval-rst}
.. mat:module:: conversion

.. mat:autofunction:: csv2table
.. mat:autofunction:: double2estr
.. mat:autofunction:: double2expstr
.. mat:autofunction:: double2fracstr
.. mat:autofunction:: double2pifracstr
.. mat:autofunction:: num2cellstr
.. mat:autofunction:: struct2codestr
.. mat:autofunction:: struct2nvp
.. mat:autofunction:: struct2nvpstr
.. mat:autofunction:: table2csv
.. mat:autofunction:: value2str
```
