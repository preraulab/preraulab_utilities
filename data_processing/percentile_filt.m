function filtered_data = percentile_filt(data, ptile, window_size)
%PERCENTILE_FILT  Compute a running percentile filter
%
%   Usage:
%   Direct input:
%   [filtered_data = percentile_filt(data, ptile, window_size)
%
%   Input:
%   data: N x T matrix - time series data, runs on rows, columns = time -- required
%   ptile: double - percentile value  -- required
%   window_size: sliding window size in samples -- required
%
%   Output:
%   filtered_data: MxT matrix of percentile filtered data
%
%   Example:
% 
% Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

%Make sure inputs are valid
% p = inputParser;
% 
% addRequired(p,'data',@(x)validateattributes(x,'numeric',{'2d','nonempty'}))
% addRequired(p,'ptile',@(x)validateattributes(x,'numeric',{'scalar','>=',0,'<=',100}));
% addRequired(p,'window_size',@(x)validateattributes(x,'numeric',{'scalar','nonempty'}))
% 
% parse(p,data,ptile,window_size);

%Create a row filter
filt_mat = ones(1, window_size);

%Compute the order 1 = smallest, winsize = biggest
order = round(prctile(1:window_size, ptile));
%Verify order
assert(order>= 1 & order<= window_size,'Order must a valid index');

%Compute order filter
filtered_data = ordfilt2(data, order, filt_mat, 'symmetric');

assert(isequal(size(data), size(filtered_data)), 'Output and input sizes unequal');
end

