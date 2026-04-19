function area_handles = threshold_plot(x, y, threshes, colors)
%THRESHOLD_PLOT  Plot a curve with shaded regions below each threshold
%
%   Usage:
%       area_handles = threshold_plot(x, y, threshes)
%       area_handles = threshold_plot(x, y, threshes, colors)
%
%   Inputs:
%       x        : 1xN double - x-axis values -- required
%       y        : 1xN double - y-axis values -- required
%       threshes : 1xK double - threshold levels to shade under -- required
%       colors   : Kx3 double or char - colors for shaded regions
%                  (default: repmat(get(gca,'ColorOrder'),5,1))
%
%   Outputs:
%       area_handles : 1xK array of handles to the shaded area patches
%
%   Example:
%       x = linspace(0, 10, 100);
%       y = sin(x).^2;
%       threshold_plot(x, y, [0.75 0.5 0.25]);
%
%   See also: area, sort, colormap
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

% Create test data if no input arguments are provided
if nargin == 0
    Fs = 100;
    dt = 1 / Fs;
    x = dt:dt:10;
    y = sin(2 * pi * 0.2 * x).^2;
    threshes = 1:-0.25:0.25;
end

% Set default colors to the default color order of the current axes
if nargin < 4
    colors = repmat(get(gca, 'ColorOrder'), 5, 1);
end

% Initialize area handles
area_handles = zeros(size(threshes));

% Sort the thresholds in descending order
threshes = sort(threshes, 'descend');

% Loop through thresholds and plot shaded areas
hold on
for ii = 1:length(threshes)
    thresh = threshes(ii);
    tplot = y;
    
    % Chop off data at threshold
    tplot(tplot > thresh) = thresh;
    
    h = area(x, tplot);
    h.FaceColor = colors(ii, :);
    
    area_handles(ii) = h;
end
end
