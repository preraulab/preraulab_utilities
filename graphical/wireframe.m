function handles = wireframe2(X, Y, Z, varargin)
%WIREFRAME Generates a wireframe plot of a surface.
%
%   handles = WIREFRAME(X, Y, Z, N) 
%   handles = WIREFRAME(X, Y, Z, xbins, xvals, ybins, yvals) 
%
%   Inputs:
%       X: Matrix of x-coordinates
%       Y: Matrix of y-coordinates
%       Z: Matrix of z-coordinates
%
%       N': Number of divisions (default: 10)
%   or
%       X_bins: Vector of available x indices
%       X_vals: Vector of x indices to plot
%       Y_bins: Vector of available y indices
%       Y_vals: Vector of y indices to plot
%
%   Optional name-value pair:
%       'Surface': Logical flag to plot surface (default: true)
%
%   Output:
%       handles: Handles to the wireframe plot lines or surface
%
%   Example:
%       [X, Y, Z] = peaks(500);
%       
%       figure
%       subplot(121)
%       %Wireframe by divisions
%       wireframe(X, Y, Z, [10 20]);
%       
%       subplot(122)
%       %Wireframe by values
%       xbins = 1:250;
%       ybins = 1:250;
%       xvals = [1 34 69 100 248];
%       yvals = [10:10:50 200:10:250];
%       wireframe(X, Y, Z, xbins, xvals, ybins, yvals);
%
%   Copyright 2024 Michael J. Prerau Laboratory - http://www.sleepEEG.org
%**************************************************************************

if nargin == 0
    [X, Y, Z] = peaks(500);

    figure
    subplot(121)
    %Wireframe by divisions
    wireframe(X, Y, Z, [10 20]);

    subplot(122)
    %Wireframe by values
    xbins = 1:250;
    ybins = 1:250;
    xvals = [1 34 69 100 248];
    yvals = [10:10:50 200:10:250];
    wireframe(X, Y, Z, xbins, xvals, ybins, yvals);
    return;
end

% Validate inputs using inputParser
parser = inputParser;
addRequired(parser, 'X', @(x) isnumeric(x) && ismatrix(x));
addRequired(parser, 'Y', @(y) isnumeric(y) && ismatrix(y));
addRequired(parser, 'Z', @(z) isnumeric(z) && ismatrix(z));
if nargin <7
    addOptional(parser, 'N', 10, @(n) validateattributes(n, {'numeric'}, {'nonnegative'}));
else
    addOptional(parser, 'X_bins', [], @(x) validateattributes(x, {'numeric'}, {'vector'}));
    addOptional(parser, 'X_vals', [], @(x) validateattributes(x, {'numeric'}, {'vector'}));
    addOptional(parser, 'Y_bins', [], @(y) validateattributes(y, {'numeric'}, {'vector'}));
    addOptional(parser, 'Y_vals', [], @(y) validateattributes(y, {'numeric'}, {'vector'}));
end
addOptional(parser, 'Surface', true, @(x) validateattributes(x, {'logical'}, {'scalar'}));

parse(parser, X, Y, Z, varargin{:});

% Extract validated inputs
X = parser.Results.X;
Y = parser.Results.Y;
Z = parser.Results.Z;
if nargin <= 7
    N = parser.Results.N;
    x_bins = [];
    x_vals = [];
    y_bins = [];
    y_vals = [];
else
    x_bins = parser.Results.X_bins;
    x_vals = parser.Results.X_vals;
    y_bins = parser.Results.Y_bins;
    y_vals = parser.Results.Y_vals;
    N = [];
end
plot_surface = parser.Results.Surface;

% Check if X, Y, and Z are the same size
if ~isequal(size(X), size(Y), size(Z))
    error('X, Y, and Z must be matrices of the same size.');
end

% Check if X, Y, and Z are 2D matrices
if ~ismatrix(X) || ~ismatrix(Y) || ~ismatrix(Z)
    error('X, Y, and Z must be 2D matrices.');
end

% Check if N is a scalar or a vector with 2 elements
if nargin == 4 && ~(isscalar(N) || (isvector(N) && numel(N) == 2))
    error('N must be a scalar or a vector with 2 elements.');
end

%Single entry means same for each dimension
if nargin < 7 && isscalar(N)
    N = [N N];
end

% Check if x_bins, x_vals, y_bins, and y_vals are numeric vectors
if ~isempty(x_bins) && (~isvector(x_bins) || ~isnumeric(x_bins))
    error('X_bins must be a numeric vector.');
end
if ~isempty(x_vals) && (~isvector(x_vals) || ~isnumeric(x_vals))
    error('X_vals must be a numeric vector.');
end
if ~isempty(y_bins) && (~isvector(y_bins) || ~isnumeric(y_bins))
    error('Y_bins must be a numeric vector.');
end
if ~isempty(y_vals) && (~isvector(y_vals) || ~isnumeric(y_vals))
    error('Y_vals must be a numeric vector.');
end

% Calculate indices for wireframe
if ~isempty(N)
    % Calculate indices based on N
    x_inds = round(linspace(1, size(Z,1), N(1)));
    x_inds(1) = 1;
    x_inds(end) = size(Z,1);
    y_inds = round(linspace(1, size(Z,2), N(2)));
    y_inds(1) = 1;
    y_inds(end) = size(Z,1);
else
    % Calculate indices based on custom x and y values
    x_inds = ismember(1:size(Z,1), x_vals);
    y_inds = ismember(1:size(Z,2), y_vals);
end

% Check if x_inds or y_inds are all zeros
if all(x_inds == 0) || all(y_inds == 0)
    error('Invalid x or y indices.');
end

% Plot wireframe
hold on;
line_h1 = plot3(X(x_inds,:)', Y(x_inds,:)', Z(x_inds,:)', 'k');
line_h2 = plot3(X(:,y_inds), Y(:,y_inds), Z(:,y_inds), 'k');
handles = {line_h1, line_h2};

% Plot surface if specified
if plot_surface
    s = surface(X, Y, Z, 'edgecolor', 'none');
    view(3);
    axis xy
    handles{3} = s;
end

end
