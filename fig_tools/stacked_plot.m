function new_axes = stacked_plot(ax, data, x, varargin)
%STACKED_PLOT  Plot multi-channel data as vertically stacked subplots with optional scale lines
%
%   Usage:
%       new_axes = stacked_plot(ax, data)
%       new_axes = stacked_plot(ax, data, x)
%       new_axes = stacked_plot(..., 'ylabels', ylabels, 'skip', skip, 'colors', colors, ...
%                               'xscale', xscale, 'xlabel', xlabel, ...
%                               'yscale', yscale, 'ylabel', ylabel)
%
%   Required Inputs:
%       ax: axes handle - parent axes to split (default: gca)
%       data: R x C matrix - R channels (rows), C samples (columns)
%       x: 1 x C vector - x-axis values (default: 1:C)
%
%   Name-Value Pair Inputs:
%       'ylabels': cell array/string array - y-axis labels (default: {'Channel 1', ...})
%       'skip': positive integer - plot every nth sample (default: 1)
%       'colors': R x 3 matrix - RGB colors for each data row (default: lines(R))
%       'xscale': numeric scalar - length of x scale line (bottom axis only)
%       'xlabel': string - label for x scale line
%       'yscale': numeric vector - lengths of y scale lines for each row (optional)
%       'ylabel': cell array/string array - labels for y scale lines (optional)
%
%   Output:
%       new_axes: R x 1 array of axes handles
%
%********************************************************************

%************************************************************
%                   INPUT HANDLING
%************************************************************
if nargin < 1 || isempty(ax) || ~ishandle(ax) || ~strcmp(get(ax, 'type'), 'axes')
    ax = gca;
end

[r, c] = size(data);
if nargin < 2 || isempty(data)
    error('Data input is required.');
end

if nargin < 3 || isempty(x)
    x = 1:c;
end
assert(numel(x) == c, 'Length of x must match number of data columns.');

% Parse name-value pairs
p = inputParser;
addParameter(p, 'ylabels', strcat("Channel ", string(1:r)));
addParameter(p, 'skip', 1, @(v) isnumeric(v) && v>=1 && mod(v,1)==0);
addParameter(p, 'colors', lines(r), @(v) isnumeric(v) && size(v,1)==r && size(v,2)==3);
addParameter(p, 'xscale', []);
addParameter(p, 'xlabel', '');
addParameter(p, 'yscale', []);
addParameter(p, 'ylabel', {});
parse(p, varargin{:});

ylabels = p.Results.ylabels;
skip = p.Results.skip;
colors = p.Results.colors;
xscale = p.Results.xscale;
xlabel_str = p.Results.xlabel;
yscale = p.Results.yscale;
ylabel_lines = p.Results.ylabel;

assert(numel(ylabels) == r, 'Number of ylabels must match number of data rows.');
if ~isempty(yscale)
    assert(numel(yscale) == r, 'Length of yscale must match number of data rows.');
end
if ~isempty(ylabel_lines)
    assert(numel(ylabel_lines) == r, 'Number of ylabel strings must match number of data rows.');
end

%************************************************************
%                   AXIS CREATION
%************************************************************
new_axes = split_axis(ax, ones(1, r)/r, 1);

%************************************************************
%                   PLOTTING
%************************************************************
x_plot = x(1:skip:end);

for ii = 1:r
    ax_i = new_axes(ii);
    plot(ax_i, x_plot, data(ii, 1:skip:end), 'Color', colors(ii,:));
    ax_i.YLabel.String = ylabels{ii};
    
    if ii < r
        ax_i.XTick = [];
        ax_i.XColor = 'none';
    end
    
    % Add y-scale line if provided
    if ~isempty(yscale)
        sl_label = '';
        if ~isempty(ylabel_lines)
            sl_label = ylabel_lines{ii};
        end
        scaleline(ax_i, yscale(ii), sl_label, 'y');
    end
end

%************************************************************
%                   X-SCALE LINE
%************************************************************
if ~isempty(xscale)
    scaleline(new_axes(end), xscale, xlabel_str, 'x');
end

%************************************************************
%                   FINAL COSMETICS
%************************************************************
new_axes(end).XColor = 'k';
box(new_axes(end), 'off');

end
