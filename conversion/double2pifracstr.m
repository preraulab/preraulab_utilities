function pi_str = double2pifracstr(val, tol)
%DOUBLE2PIFRACSTR  Convert a double to a string representation as a pi fraction
%
%   Usage:
%       pi_str = double2pifracstr(val)
%       pi_str = double2pifracstr(val, tol)
%
%   Inputs:
%       val : double - the value to convert -- required
%       tol : double - tolerance for pi-fraction match (default: 1e-10)
%
%   Outputs:
%       pi_str : char - representation like 'pi/2', '-pi', '(3*pi)/4', or numeric string
%                       if no simple pi fraction found
%
%   Example:
%       double2pifracstr(pi/2);   % returns 'pi/2'
%       double2pifracstr(3);      % returns '3'
%
%   See also: double2estr, double2expstr, double2fracstr, rat
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main
if nargin < 2
    tol = 1e-10;
end

[n,d] = rat(val/pi,tol);

if n<100 && d<100

    if n == -1
        pi_str = '-pi';
    elseif n == 1
        pi_str = 'pi';
    elseif n == 0
        pi_str = '0';
    elseif d == 1
        pi_str = [num2str(n) '*pi'];
    else
        pi_str = ['(' num2str(n) '*pi)/' num2str(d)];
    end
else
    pi_str = num2str(val);
end
