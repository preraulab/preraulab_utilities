function [zscored, mu, sigma] = nanzscore(data, varargin)
%NANZSCORE  Compute z-scores ignoring NaN values
%
%   Usage:
%       [zscored, mu, sigma] = nanzscore(data, ...)
%
%   Inputs:
%       data     : numeric array - data to z-score (NaNs are ignored) -- required
%       varargin : additional arguments forwarded to zscore()
%
%   Outputs:
%       zscored : numeric array - z-scored data (same size as data)
%       mu      : double - mean used for z-scoring (non-NaN values only)
%       sigma   : double - standard deviation used for z-scoring
%
%   Notes:
%       Only non-NaN elements of data are used to compute the z-score. The
%       resulting zscored array matches the size of data, with NaN preserved
%       at every position where data was NaN.
%
%   See also: zscore, isnan
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

inds = ~isnan(data);
zscored = nan(size(data));
[zscored(inds), mu, sigma] = zscore(data(inds),varargin{:});

% %NANZSCORE compute zscores ignoring nans
% if any(isnan(data))
%     mu = mean(data,'all','omitnan');
%     sigma = std(data,0,'all','omitnan');
%     zscored = (data-mu)./sigma;
% else
%     [zscored, mu, sigma] = zscore(data(:));
% end

end

