%VLINE  Draw a vertical line
%
%   Usage:
%   h = vline(xvals,<line inputs>)
%   h = vline(ax, xvals, <line inputs>)
% 
%   Input:
%   xvals: x coordinate(s) of line (scalar or vector)
% 
%   Output:
%   h: handle for lines
% 
%   Example:
%         % Create a new figure
%         figure;
%         % Draw some lines
%         h = vline([-1 3 4.2],'linewidth', 2, 'color', 'k');
%
%   See also hline, line
%
%   Copyright 2021 Michael J. Prerau, Ph.D. - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%   
%   Last modified 11/16/2021
%********************************************************************

function h=vline(varargin)

% Parse possible axes input.
[ax, args, ~] = axescheck(varargin{:});

% Get handle to either the requested or a new axis.
if isempty(ax)
   ax = gca;
end

if isempty(args) 
    error('Must provide line values');
end

xvals = args{1}(:);

hold on;
h=line([xvals xvals]',ylim(ax), args{2:end});
hold off;