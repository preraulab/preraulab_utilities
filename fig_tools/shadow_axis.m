function [axis_handle, shadow_handle] = shadow_axis(varargin)
% SHADOW_AXIS creates an axis with a shadow effect.
%
% Syntax:
%   [axis_handle, shadow_handle] = shadow_axis
%   [axis_handle, shadow_handle] = shadow_axis('Name', Value)
%
% Description:
%   SHADOW_AXIS creates an axis with a shadow effect. The position,
%   size, distance, angle, opacity, and resolution of the shadow can be
%   customized using the optional name-value pairs.
%
% Input Arguments:
%   - position (optional): Position of the axis. Default is [0.1300 0.1100
%     0.7750 0.8150].
%   - size (optional): Size of the shadow effect. Default is 10.
%   - distance (optional): Distance between the axis and the shadow.
%     Default is 0.03.
%   - angle (optional): Angle of the shadow in degrees. Default is -45.
%   - opacity (optional): Opacity of the shadow. Default is 0.5.
%   - resolution (optional): Resolution of the shadow image. Default is 500.
%
% Output Arguments:
%   - axis_handle: Handle to the actual axis for plotting.
%   - shadow_handle: Handle to the shadow axis.
%
% Examples:
%   % Create a shadow axis with default settings
%   [axis_handle, shadow_handle] = shadow_axis
%
%   % Create a shadow axis with custom settings
%   [axis_handle, shadow_handle] = shadow_axis('size', 15, 'opacity', 0.7)
%
% See also:
%   inputParser, axes, get, set, fspecial, imfilter, image

% Parse all the inputs
p = inputParser;

% Axis position
p.addOptional('position', [0.1300 0.1100 0.7750 0.8150]);

% Shadow size
p.addOptional('size', 10);

% Shadow distance
p.addOptional('distance', 0.03);

% Shadow angle (in degrees)
p.addOptional('angle', -45);

% Shadow opacity
p.addOptional('opacity', 0.5);

% Shadow resolution
p.addOptional('resolution', 500);

% Parse the arguments
p.parse(varargin{:});
args = p.Results;

% Set the variables from the input
position = args.position;
size = args.size;
distance = args.distance;
angle = args.angle;
opacity = args.opacity;
resolution = args.resolution;

% Get the figure background color
bgcolor = get(gcf, 'color');

% Create the shadow axes
shadow_handle = axes('position', position + [cos(angle/180*pi)*distance sin(angle/180*pi)*distance 0 0]);

% Create the shadow
% Make the image the color of the background
shadow = cat(3, ones(resolution)*bgcolor(1), ones(resolution)*bgcolor(2), ones(resolution)*bgcolor(3));

% Make the shadow and set darkness based on opacity parameter
for i = 1:3
    shadow(size:end-size, size:end-size, i) = (1-opacity) * bgcolor(i);
end

% Blur to create the shadow effect
F = fspecial('disk', size);
shadow = imfilter(shadow, F, 'replicate');

% Display the shadow
image(shadow);
set(gca, 'XTick', [], 'YTick', [], 'XColor', bgcolor, 'YColor', bgcolor);

% Create the actual axis for plotting
axis_handle = axes('Units', 'normalized', 'Position', position);
end
