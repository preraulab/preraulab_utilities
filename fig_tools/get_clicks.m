function pos = get_clicks(varargin)
% GET_CLICKS captures mouse clicks on a figure axis.
%
% Syntax:
%   pos = get_clicks
%   pos = get_clicks(num_clicks)
%   pos = get_clicks(h_ax)
%   pos = get_clicks(h_ax, num_clicks)
%
% Description:
%   GET_CLICKS captures the coordinates of mouse clicks on a specified
%   figure axis. The function allows capturing a specified number of
%   clicks or a default of one click if no input arguments are provided.
%
% Input Arguments:
%   - num_clicks (optional): Number of clicks to capture. Default is 1.
%   - h_ax (optional): Handle to the axis where mouse clicks are captured.
%     Default is the current axis (gca).
%
% Output Arguments:
%   - pos: Matrix of size num_clicks-by-2, containing the coordinates of
%     each mouse click. The first column represents the x-coordinates, and
%     the second column represents the y-coordinates.
%
% Examples:
%   % Capture one mouse click on the current axis
%   pos = get_clicks
%
%   % Capture three mouse clicks on a specific axis
%   h_fig = figure;
%   h_ax = axes('Parent', h_fig);
%   pos = get_clicks(h_ax, 3)
%
%   % Capture two mouse clicks using the default axis
%   pos = get_clicks(2)
%
% See also:
%   gca, waitforbuttonpress, iptPointerManager, iptSetPointerBehavior
% 
% Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

% Set default values for input arguments
if nargin == 0
    h_ax = gca;         % Use the current axis
    num_clicks = 1;     % Capture one click
end

% Process input arguments
if nargin == 1
    h_ax = gca;         % Use the current axis
    num_clicks = varargin{1};
end

if nargin == 2
    h_ax =  varargin{1};
    num_clicks = varargin{2};
end

% Get the figure handle from the axis
h_fig = h_ax.Parent;

% Initialize the position matrix
pos = zeros(num_clicks, 2);

% Set pointer behavior to crosshair
iptPointerManager(h_fig);
iptSetPointerBehavior(h_ax, @(hfig, currentPoint)set(hfig, 'Pointer', 'cross'));

% Capture mouse clicks
clicks = 0;
while clicks < num_clicks
    w = waitforbuttonpress;
    if ~w
        clicks = clicks + 1;
        p = get(h_ax, 'CurrentPoint');
        pos(clicks, :) = p(1, 1:2);
    end
end

% Reset pointer behavior to arrow
iptSetPointerBehavior(h_ax, @(hfig, currentPoint)set(hfig, 'Pointer', 'arrow'));
end
