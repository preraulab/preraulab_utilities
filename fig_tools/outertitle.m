%OUTERTITLE  Plot a big title on the outside of an axis grid
%
%   Usage:
%       [h_title, h_axbig] = outertitle(axs, title_str, <label options>)
%
%   Input:
%       axs: vector of axes in figure
%       title_str: string for title text
%   Optional inputs:
%       <title options>: paired valued options for title class
%
%   Output:
%       h_title: outer title handle
%       h_axbig: parent axis handle 
%
%   Example:
%     %Create Figure
%     figure
%     ax = figdesign(3,2,'type','usletter','margins',[.1 .1 .14 .1 .08],'numberaxes',true);
% 
%     %Outer label strings
%     title_str = 'My Title';
%     xlabel_str = 'My X-Label';
%     ylabel_str = 'My Y-Label';
% 
%     %Create outer labels
%     [~,~,ax_big] =outerlabels(ax,xlabel_str,ylabel_str);
% 
%     %Create outer title
%     outertitle(ax,title_str,'fontsize',30);

%
%
%   Copyright 2024 Michael J. Prerau, Ph.D. - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%
%   last modified 12/01/2021
%********************************************************************

function [h_title, axbig] = outertitle(ax, title_str, varargin)

if nargin == 0
    figure
    ax = figdesign(3,2,'type','usletter','margins',[.05 .1 .14 .1 .05]);
    title_str = 'Title';
end

if isempty(varargin)
    varargin = {'FontSize', 20, 'FontWeight', 'bold'};
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

%Create giant axes for outerlabel creation
axbig = axes('units','normalized','position',[bottom_x, bottom_y, width, height]);

%Make axes
h_title = title(title_str,varargin{:});


%Hide big axis
axbig.Visible = 'off';
h_title.Visible = 'on';
h_title.VerticalAlignment = "bottom";

