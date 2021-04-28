%VLINE  Draw a vertical line
%
%   Usage:
%   [h] = vline(xvals)
%   [h] = vline(xvals, width)
%   [h] = vline(xvals, width, color)
%   [h] = vline(xvals, width, color, style)
% 
%   Input:
%   xvals: x coordinate(s) of line (scalar or vector)
%   width: width of line
%   color: color of line
%   style: line style
% 
%   Output:
%   h: handle for line
% 
%   Example:
%         % Create a new figure
%         figure;
%         % Draw a thick red line at x=1
%         h=vline([-1 3 4.2],3,'r','--');
%
%   See also hline, line
%
%   Copyright 2021 Michael J. Prerau, Ph.D. - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%   
%   Last modified 9/21/2011
%********************************************************************

function h=vline(xvals, width, color, style, axs)

if nargin==0
    x=ginput(1);
    xvals=x(1);
end

if isempty(xvals)
    warning('No values entered');
    return;
end

if nargin<2
    width=1;
end

if nargin<3
    color='k';
end

if nargin<4
    style='-';
end

if nargin<5
    axs=gca;
end

hold on;
h=line([xvals(:) xvals(:)]',[ylim(axs)]', 'linewidth',width,'color',color,'LineStyle',style,'parent',axs);