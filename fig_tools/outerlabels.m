%OUTERLABELS  Plot big labels on the outside of an axis grid
%
%   Usage:
%       [h_xl, h_yl, h_axbig] = outerlabels(axs, xlabel_str, ylabel_str, axdir, <label options>)
%
%   Input:
%       axs: vector of axes in figure
%       x/ylabel_str: string for label text
%       adir: 1x2 logical for x and y label locations to be reversed (default: [false false])
%   Optional inputs:
%       XAxisLocation: 'bottom' (default) or 'top'
%       YAxisLocation: 'left' (default) or 'right'
%       <label options>: paired valued options for label class
%
%   Output:
%       h_xl: outer xlim handle
%       h_yl: outer ylim handle
%       h_axbig: parent axis handle 
%
%   Example:
%         %Create Figure
%         figure
%         ax = figdesign(3,2,'type','usletter','margins',[.1 .1 .14 .1 .08],'numberaxes',true);
% 
%         %Outer label strings
%         title_str = 'My Title';
%         xlabel_str = 'My X-Label';
%         ylabel_str = 'My Y-Label';
% 
%         %Create outer labels
%         [~,~,ax_big] =outerlabels(ax,xlabel_str,ylabel_str);
% 
% Copyright 2023 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

function [h_xl, h_yl, h_axbig] = outerlabels(ax,xlabel_str,ylabel_str, varargin)

if nargin == 0
    figure
    ax = figdesign(3,2,'type','usletter','margins',[.05 .1 .14 .1 .05]);
    xlabel_str = 'X Label';
    ylabel_str = 'Y Label';
end

if isempty(varargin)
    varargin = {'FontSize', 17, 'FontWeight', 'bold'};
end

%Parse inputs to extract just the xy axis locations
p = inputParser;
addOptional(p,'XAxisLocation','bottom',@(x)  any(validatestring(x,{'top','bottom'})));
addOptional(p,'YAxisLocation','left',@(x) any(validatestring(x,{'left','right'})));
p.KeepUnmatched = true;
parse(p,varargin{:});

%Save results
xloc = p.Results.XAxisLocation;
yloc = p.Results.YAxisLocation;

%Recreate varargin removing the x/y axis location name pairs
varargin = cat(2,fieldnames(p.Unmatched),struct2cell(p.Unmatched));
varargin = reshape(varargin',1, numel(varargin));

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
h_axbig = axes('units','normalized','position',[bottom_x, bottom_y, width, height]);

%Make axes
h_xl = xlabel(xlabel_str,varargin{:});
h_yl = ylabel(ylabel_str,varargin{:});

%Hide big axis
h_axbig.Visible = 'off';
h_axbig.XLabel.Visible = 'on';
h_axbig.YLabel.Visible = 'on';
h_axbig.XLabel.VerticalAlignment = "middle";
h_axbig.YLabel.VerticalAlignment = "middle";

%Set axis label location
h_axbig.XAxisLocation = xloc;
h_axbig.YAxisLocation = yloc;
