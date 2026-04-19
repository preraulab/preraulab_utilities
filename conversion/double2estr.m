function e_str = double2estr(val, tol)
%DOUBLE2ESTR  Convert a double to a string as a simple fraction times an exponential
%
%   Usage:
%       e_str = double2estr(val)
%       e_str = double2estr(val, tol)
%
%   Inputs:
%       val : double - the value to convert -- required
%       tol : double - closeness tolerance for simple fraction match (default: 1e-10)
%
%   Outputs:
%       e_str : char - string representation as 'n/d * exp(b)', or '' if no match
%
%   Example:
%       e_str = double2estr(2/4*exp(5));   % returns '1/2 * exp(5)'
%       e_str = double2estr(4.7);          % returns ''
%
%   See also: double2fracstr, double2pifracstr, double2expstr, value2str
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

if nargin < 2
    tol = 1e-10;
end

best_approximation = Inf;
best_a = NaN;
best_b = NaN;


% Iterate through values of b from 2 to 20
for b = 1:20
    % Calculate a
    a = val / exp(b);

    [n,d] = rat(a,tol);

    if n<10 && d<10 && n>0 && d>0
        % Calculate the approximation
        approximation = a * exp(b);

        if isempty(double2fracstr(a))
            continue;
        end

        % Check if this approximation is better than the current best
        if abs(val - approximation) < abs(val - best_approximation) && abs(val-approximation)<tol
            best_approximation = approximation;
            best_a = a;
            best_b = b;
        end
    end
end
if isnan(best_a) || isnan(best_b)
    e_str = '';
else
    if best_a == 1
        e_str =  ['exp(', num2str(best_b), ')'];
    else
        [n,d] = rat(best_a,tol);
        if d == 1
            e_str =  [num2str(n) ' * exp(', num2str(best_b), ')'];
        else
            e_str =  [num2str(n) '/' num2str(d) ' * exp(', num2str(best_b), ')'];
        end
    end
end

