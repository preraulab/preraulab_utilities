function [colorbar_handle] = double_colorbar(topax, botax)
%DOUBLE_COLORBAR  Make a double-sided colorbar in between two plots
%
%   Usage:
%   [colorbar_handle] = double_colorbar(topax, botax)
% 
%   Input:
%   topax: handle for upper axis
%   botax: handle for lower axis
% 
%   Output:
%   colorbar_handle: returned handle of colorbar
% 
%   Example:
%         %Plot two image of random data
%         topax = subplot(2,1,1);
%         imagesc(randn(100,100));
%         botax = subplot(2,1,2);
%         imagesc(randn(100,100));
%
%         %Make double colorbar
%         [colorbar_handle] = double_colorbar(topax, botax)
%
%   See also colorbar, addtxaxis
%
%   Copyright 2011
%   
%   Last modified 9/9/2011
%********************************************************************

% Ensure that colorbar is horizontally oriented
topcolh = colorbar('peer',topax,'Location','SouthOutside');
colorbar_handle = colorbar('peer',botax,'Location','SouthOutside');

% Get limits, tick locations, and tick labels for both plots
botlims=get(colorbar_handle, 'XLim');
toplims=get(topcolh, 'Xlim');
ticks=get(colorbar_handle, 'XTick');
toplables=get(topcolh, 'XTickLabel');
parasites=get(colorbar_handle, 'XTickLabel');

% Determine relative position of ticks for both axes
while length(get(colorbar_handle, 'XTick'))<(length(get(topcolh, 'XTick'))+1),
    ticks=get(colorbar_handle, 'XTick');
    set(colorbar_handle, 'XTick', [ticks ticks(end)+(ticks(2)-ticks(1))]);
end

halfway = ((((toplims(2)-toplims(1))/(botlims(2)-botlims(1)))*(str2num(parasites))));
newlims = ((toplims(2)-toplims(1))/(botlims(2)-botlims(1)))*botlims;
ticklabels = halfway + (toplims(1)-newlims(1));

partway = ((((botlims(2)-botlims(1))/(toplims(2)-toplims(1)))*(str2num(toplables))));
newerlims = ((botlims(2)-botlims(1))/(toplims(2)-toplims(1)))*toplims;
toplabels = partway + (botlims(1)-newerlims(1));

botticks=str2num(parasites);

% Set position of colorbar based on axes positions
toploc = get(topax,'position');
botloc = get(botax,'position');
gapheight=(toploc(2)-(botloc(2)+botloc(4)));
set(colorbar_handle, 'position', [toploc(1) botloc(2)+botloc(4)+0.15*gapheight toploc(3) 0.1*gapheight]);

% Define needed variables in base workspace (required for addtxaxis)
assignin('base', 'toplabels', toplabels)
assignin('base', 'botticks', botticks)

% Add top axis to colorbar
topaxishandle = addtxaxis(colorbar_handle,'((toplabels(2)-toplabels(1))/(botticks(2)-botticks(1)))*x+(toplabels(1)-(((toplabels(2)-toplabels(1))/(botticks(2)-botticks(1)))*botticks(1)))',ticks,[],toplables);

% Set ticks to appear in front of colors
allchildren=get(gcf, 'Children');
set(gcf, 'Children', [allchildren(2); allchildren(1); allchildren(3:end)]);
set(topaxishandle, 'Color', 'none');

delete(topcolh);

end