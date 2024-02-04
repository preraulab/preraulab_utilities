function lab_handle = letter_label(fig_h, ax_h, labstr, labdir, fontsize, gaps)
%LETTER_LABEL  Make a figure label letter annotation for an axis
%
%   Usage:
%   lab_handle = letter_label(fig_h, ax_h, labstr, labdir, fontsize)
%
%   Input:
%   fig_h: figure handle (default: gcf)
%   ax_h: axis handle (default: gca)
%   labstr: char/string - figure labele string (default: 'A')
%   labdir: 'l'/'left' or 'r'/'right' - the side of the axis the label is on (default: 'left')
%   fontsize: double - font size (default: 30)
%   gaps: 1x2 double - gaps between bottom and side of the axis in normalized units (default: [.03 .03])
% 
%   Output:
%   lab_handle: handle for the label annotation
% 
%   Example:
%         % Create a new figure
%         figure;
%
%         %Create an axis
%         ax = gca;
%         ax.Position(4) = .6;
%         letter_label(gcf,ax,'B','left',25);
%
%  Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

%Set defaults
if nargin < 1
    fig_h = gcf;
end

if nargin<2
    ax_h = gca;
end

if nargin<3
    labstr = 'A';
end

if nargin<4
    labdir = 'l';
end

if nargin < 5
    fontsize = 30;
end

if nargin<6
    gaps = [.03 .03];
end


% Force everything to be normalized
set(fig_h,'units','normalized');
set(ax_h,'Units','normalized');

%Get the position of the axis in the figure space
axpos = ax_h.Position;

%Set large textbox size
W = .05;
H = .05;

%Set textbox position as a function of direction
switch lower(labdir)
    case {'left','l'}
        labpos = max(min([axpos(1)-W-gaps(2), axpos(2)+axpos(4)+gaps(1), W, H],1),0);
        halign = 'right';
    case {'right','r'}
        labpos = max(min([axpos(1)+axpos(3)+gaps(2), axpos(2)+axpos(4)+gaps(1), W, H],1),0);
        halign = 'left';
    otherwise
        error('Label direction must be ''left'' or ''right''');
end


% Create textbox for figure labe;
lab_handle = annotation(fig_h,'textbox',...
    labpos,...
    'String',labstr,...
    'HorizontalAlignment',halign,...
    'VerticalAlignment','bottom',...
    'FontSize',fontsize,...
    'LineStyle','none',...
    'margin',0,...
    'FontName','Helvetica Neue',...
    'FitBoxToText','off');

