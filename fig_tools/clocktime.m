%CLOCKTIME  Converts axis ticks from seconds/minutes to HH:MM:SS
%
% Usage:
%   clocktime
%   clocktime(t0)
%   clocktime(t0,h)
%   clocktime(t0,h,unit)
%
% Input:
%   t0 - date vector ([YYYY MM DD HH MM SS]) of data start time
%   unit - string 'sec' or 'min' denoting current time unit of the xaxis.
%          if not entered, unit is in seconds.
%   h - axis handle (if no input, uses current axis)
%
% Example:
%   % after plotting a spectrogram with time in minutes...
%   clocktime([0 0 0 11 27 0],gca,'min');
%
% See also sec2hms
%
% Copyright 2014, David Zhou, dwzhou@partners.org
% Last modified 9/2/14
%********************************************************************
function clocktime(t0,h,unit)
% Set the current axis to be active if not specificed
if nargin<2;
    h=gca;
end
% assign factor to correct for unit if in minutes
unitfact = 1; % default seconds does not need change
if nargin == 3
    if strcmp(unit,'min')
        unitfact = 60;
    end
end

odat = get(h,'xlim');
if nargin==3 && strcmp(unit,'min')
    odat = [addtodate(datenum(t0),odat(1)/unitfact,'minute') addtodate(datenum(t0),odat(2)/unitfact,'minute')];
else
    odat = [addtodate(datenum(t0),odat(1),'second') addtodate(datenum(t0),odat(2),'second')];
end

% Get all of the plotted items
children=get(h,'children');

% Set figure size large enough so that auto mode xticks are finely spaced
set(gcf,'units','normalized'); set(gcf,'position',[.1 .1 .4 .4]);

% Set the date factored xdata, with t0 added
set(children,'xdata',get(children,'xdata')*unitfact*datefact+datenum(t0));
xdat = get(children,'xdata');

% Change the axes
datetick('x','HH:MM:SS');
xlim([xdat(1) xdat(end)]);
xlim([odat(1) odat(2)]);% restore original xlim
xlabel('Time (hh:mm)');
zoomAdaptiveDateTicks('on');
zoom out;