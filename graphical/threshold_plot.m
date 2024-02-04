function area_handles = threshold_plot(x, y, threshes, colors)
% THRESHOLD_PLOT plots a curve with thresholds under it using varying colors.
%
% Syntax:
%   area_handles = threshold_plot(x, y, threshes, colors)
%
% Description:
%   THRESHOLD_PLOT takes an input curve defined by the x and y vectors and
%   plots it on a 2D plot. Thresholds are specified in the threshes vector
%   and are visualized by shading the area below the curve up to each
%   threshold. The colors of the shaded areas can be specified using the
%   colors vector.
%
% Input Arguments:
%   - x: Independent variable vector defining the x-axis of the plot.
%   - y: Dependent variable vector defining the y-axis of the plot.
%   - threshes: Vector of threshold values for the shaded areas.
%   - colors (optional): Matrix or vector specifying the colors of the
%     shaded areas. By default, the colors will follow the default color
%     order of the current axes.
%
% Output Argument:
%   - area_handles: Array of handles to the shaded area patches.
%
% Examples:
%   % Plot a curve with default thresholds and colors
%   x = linspace(0, 10, 100);
%   y = sin(x);
%   threshes = [0.5, 0.25, 0];
%   area_handles = threshold_plot(x, y, threshes)
%
%   % Plot a curve with custom thresholds and colors
%   x = linspace(0, 10, 100);
%   y = sin(x);
%   threshes = [0.5, 0.25, 0];
%   colors = ['r', 'g', 'b'];
%   area_handles = threshold_plot(x, y, threshes, colors)
%
% See also:
%   area, sort, get, colormap
% 
% Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

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
