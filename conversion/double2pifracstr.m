%%
%DOUBLE2PIFRACSTR Convert a double to a string representation in terms of pi fractions
%
%   Usage:
%       pi_str = double2pifracstr(val, tol)
%
%   Input:
%       val: double - the value to convert to a pi fraction string -- required
%       tol: double - the tolerance for determining the closeness to a pi fraction (default: 1e-4)
%
%   Output:
%       pi_str: char - the string representation of the input value as a fraction of pi or the value itself if not close to a pi fraction
%
%   Example:
%   In this example, we convert a value close to pi/2 and a value that is not close to any pi fraction.
%       val1 = pi/2;
%       tol = 1e-4;
%       pi_str1 = double2pifracstr(val1, tol);
%       % pi_str1 should be 'pi/2'
%
%       val2 = 3;
%       pi_str2 = double2pifracstr(val2);
%       % pi_str2 should be '3'
%
%    Copyright 2023 Prerau Laboratory - sleepEEG.org
%% ********************************************************************

function pi_str = double2pifracstr(val, tol)
    if nargin < 2
        tol = 1e-4;
    end

    pi_denom = find(abs(abs(val) - pi./(1:100)) < tol);

    if isempty(pi_denom)
        pi_str = sprintf('%0.100g', val);
    else
        if pi_denom == 1
            pi_str = 'pi';
        else
            pi_str = ['pi/' num2str(pi_denom)];
        end

        if sign(val) == -1
            pi_str = ['-' pi_str];
        end
    end
end
