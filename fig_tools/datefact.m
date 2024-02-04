function df = datefact
% DATEFACT returns the date factor, which represents the fractional value
% of one second in MATLAB's serial date format.
%
% Syntax:
%   df = datefact
%
% Description:
%   DATEFACT calculates the date factor by converting a duration of one
%   second (represented as [0 0 0 0 0 1]) into MATLAB's serial date format.
%   The date factor is a fractional value that corresponds to the length of
%   one day.
%
% Output Argument:
%   - df: Date factor, representing the fractional value of one day in
%     MATLAB's serial date format.
%
% Example:
%   % Calculate the date factor
%   df = datefact
%
% See also:
%   datenum, duration
%
%   Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

df = datenum([0 0 0 0 0 1]); %#ok<DATNM>
end
