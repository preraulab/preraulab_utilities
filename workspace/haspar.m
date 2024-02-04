%HASPAR Checks whether parallel toolbox is installed
%
%   Output:
%   TRUE if parallel toolbox is installed
%   haspar returns 1 if parallel toolbox is installed and 0 otherwise
% 
% Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

function result = haspar()
%Check if the parallel toolbox has been installed
result=~isempty(ver('parallel'));