%OUTERLABELS  Plot big labels on the outside of an axis grid
%
%   Usage:
%       [h_xl, h_yl] = outerlabels(axs, xlabel_str, ylabel_str, axdir, <label options>)
%
%   Input:
%   axs: vector of axes in figure
%   x/ylabel_str: string for label text
%   adir: 1x2 logical for x and y label locations to be reversed (default: [false false])
%   <label options>: paired valued options for label class
%
%   Output:
%   h_xl: outer xlim handle
%   h_yl: outer ylim handle
%
%   Example:
%     figure
%     ax = figdesign(3,2,'type','usletter','margins',[.05 .1 .14 .1 .05]);
%     xlabel_str = 'X Label';
%     ylabel_str = 'Y Label';
% 
%     outerlabels(ax,xlabel_str, ylabel_str,[],'fontsize',18,'fontweight','bold');
%
%   Copyright 2021 Michael J. Prerau, Ph.D. - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%
%   last modified 12/01/2021
%********************************************************************

function [h_xl, h_yl] = outerlabels(ax,xlabel_str,ylabel_str, axdir, varargin)

if nargin == 0
    figure
ax = figdesign(3,2,'type','usletter','margins',[.05 .1 .14 .1 .05]);
xlabel_str = 'X Label';
ylabel_str = 'Y Label';
end

if nargin <4 || isempty(axdir)
    axdir = [0 0];
end

if isempty(varargin)
    varargin = {'FontSize', 17, 'FontWeight', 'bold'};
end

%Force the units to be normalized
set(gcf,'units','normalized');
set(ax,'units','normalized');

%Get outer positions
pos = cat(1,ax.OuterPosition);

%Get key positions
bottom_x = min(pos(:,1));
bottom_y = min(pos(:,2));
width = max(pos(:,1) + pos(:,3)) - bottom_x;
height = max(pos(:,2) + pos(:,4)) - bottom_y;

axbig = axes('units','normalized','position',[bottom_x, bottom_y, width, height]);

%Make axes
h_xl = xlabel(xlabel_str,varargin{:});
h_yl = ylabel(ylabel_str,varargin{:});

%Hide big axess
axbig.Visible = 'off';
axbig.XLabel.Visible = 'on';
axbig.YLabel.Visible = 'on';

if axdir(1)
    axbig.XAxisLocation = "top";
end

if axdir(2)
    axbig.YAxisLocation = "right";
end
