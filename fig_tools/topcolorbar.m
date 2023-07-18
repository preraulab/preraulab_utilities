% topcolorbar(width,height,vgap)
function [lab, c] = topcolorbar(w, h, vgap)
% TOPCOLORBAR creates a colorbar positioned at the top of the plot.
%
% Syntax:
%   [lab, c] = topcolorbar
%   [lab, c] = topcolorbar(w, h)
%   [lab, c] = topcolorbar(w, h, vgap)
%
% Description:
%   TOPCOLORBAR creates a colorbar positioned at the top of the current
%   plot. By default, the width (w) and height (h) of the colorbar are set
%   to 0.2 and 0.01, respectively. The vertical gap (vgap) between the plot
%   and the colorbar is set to 0.01 by default. The function returns the
%   handle to the colorbar (c) and the handle to its label (lab).
%
% Input Arguments:
%   - w (optional): Width of the colorbar. Default is 0.2.
%   - h (optional): Height of the colorbar. Default is 0.01.
%   - vgap (optional): Vertical gap between the plot and the colorbar.
%     Default is 0.01.
%
% Output Arguments:
%   - lab: Handle to the label of the colorbar.
%   - c: Handle to the colorbar.
%
% Examples:
%   % Create a colorbar at the top with default settings
%   [lab, c] = topcolorbar
%
%   % Create a colorbar with custom width, height, and vertical gap
%   [lab, c] = topcolorbar(0.3, 0.02, 0.02)
%
% See also:
%   colorbar, get, set
% 
% Copyright 2023 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

colorbar('off');  % Remove any existing colorbars
axpos = get(gca, 'Position');  % Get the position of the current axes

if nargin < 1
    w = 0.2;  % Default width of the colorbar
end

if nargin < 2
    h = 0.01;  % Default height of the colorbar
end

if nargin < 3
    vgap = 0.01;  % Default vertical gap between plot and colorbar
end

c = colorbar('northoutside', 'Units', 'normalized');  % Create the colorbar

cpos(4) = h;
cpos(3) = w;
cpos(2) = axpos(2) + axpos(4) + vgap;
cpos(1) = axpos(1) + axpos(3) - w;

set(c, 'Position', cpos);  % Set the position of the colorbar

lab = get(c, 'Label');  % Get the label of the colorbar
labpos = get(lab, 'Position');  % Get the position of the label
labpos(2) = 0.8 * labpos(2);  % Adjust the vertical position of the label
set(lab, 'String', 'Power (dB)', 'Position', labpos);  % Set the label text and position
end
