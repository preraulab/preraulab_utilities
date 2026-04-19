function frac_str = double2fracstr(val, tol)
%DOUBLE2FRACSTR  Convert a double to a string representation as a simple fraction
%
%   Usage:
%       frac_str = double2fracstr(val)
%       frac_str = double2fracstr(val, tol)
%
%   Inputs:
%       val : double - the value to convert -- required
%       tol : double - tolerance for simple fraction match (default: 1e-10)
%
%   Outputs:
%       frac_str : char - string representation as 'n/d' (or 'n' if d==1), or [] if no match
%
%   Example:
%       double2fracstr(2/3);   % returns '2/3'
%       double2fracstr(4/5);   % returns '4/5'
%
%   See also: double2estr, double2expstr, double2pifracstr, rat
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main
if nargin < 2
    tol = 1e-10;
end

[n,d] = rat(val,tol);

if n<100 && d<100
    if d==1
        frac_str = num2str(n);
    else
        frac_str = [num2str(n) '/' num2str(d)];
    end
else
   frac_str = [];
end
