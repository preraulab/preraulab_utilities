function result = double2expstr(value)
%DOUBLE2EXPSTR  Convert a value to a string in terms of exp() and a simple rational fraction
%
%   Usage:
%       result = double2expstr(value)
%
%   Inputs:
%       value : double - the numerical value to convert -- required
%
%   Outputs:
%       result : char - string representation as 'n/d*exp(k)', or '' if no match
%
%   Example:
%       result = double2expstr(81.897225049716354);   % returns '3/2*exp(4)'
%
%   See also: double2estr, double2fracstr, double2pifracstr, rat
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

% Decompose the value into a factor and an exponential part
tol = 1e-5;

log_val = log(value);
exponent = round(log_val);

factor = value / exp(exponent);

if ~isempty(double2fracstr(factor))

    % Use the rat function to get the simple rational fraction
    [num, den] = rat(factor);

    % Form the result string
    if num == 1 && den == 1
        result = sprintf('exp(%d)', exponent);
    elseif den == 1
        result = sprintf('%d*exp(%d)', num, exponent);
    else
        result = sprintf('%d/%d*exp(%d)', num, den, exponent);
    end
else
    result = '';
end
end