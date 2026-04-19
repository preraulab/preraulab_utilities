function table2csv(T, filename)
%TABLE2CSV  Save a table to CSV with full numeric precision and eval-safe encoding
%
%   Usage:
%       table2csv(T, filename)
%
%   Inputs:
%       T        : table - table to save -- required
%       filename : char - output CSV path -- required
%
%   Outputs:
%       none (writes a CSV file)
%
%   Notes:
%       - Doubles stored with full precision (17 digits)
%       - Singles stored with full precision and cast back upon load
%       - Vectors/matrices preserved as strings
%       - Works with scalars, strings, logicals, cells, and tables
%
%   See also: csv2table, value2str, writecell
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

    enc = value2str(T,false);  % Encode table values to strings

    % Add headers
    C = [T.Properties.VariableNames; table2cell(enc)];

    % Write CSV safely, preserving all digits
    writecell(C, filename);
end
