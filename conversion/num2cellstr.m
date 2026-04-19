function out = num2cellstr(s)
%NUM2CELLSTR  Convert a numeric array into a cell array of strings
%
%   Usage:
%       out = num2cellstr(s)
%
%   Inputs:
%       s : numeric - array to convert -- required
%
%   Outputs:
%       out : cell - cell array of char, same size as s, with each cell
%                    containing the string representation of the corresponding element
%
%   Example:
%       out = num2cellstr([1 2 3; 4 5 6]);
%
%   See also: cellstr, num2str, strtrim
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

% Convert the numeric array into a cell array of strings
out = reshape(strtrim(cellstr(num2str(s(:)))'), size(s));
end
