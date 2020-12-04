%SEC2HMS  Converts axis ticks from seconds to hours:minutes:seconds
%
%   Usage:
%   sec2hms
%   sec2hms(h)
%
%   Input:
%   h:  axis handle (if no input, uses current axis)
%
%   Example:
%       % create example data
%       data=randn(1,100);
%       time=[1:100];
%       % plot example data
%       plot(time, data);
%       % convert current axis to HH:MM:SS
%       sec2hms
%
%   See also <other related programs>
%
%   Copyright 2011, Michael J. Prerau Ph.D.
%
%   Last modified 7/7/2011
%********************************************************************

function sec2hms(h)
%Set the current axis to be active if not specificed
if nargin==0;
    h=gca;
end

%Get all of the plotted items
children=get(h,'children');

%Change the axis by the datenum factor
for i=1:length(children)
    if isprop(children(i),'xdata');
        set(children(i),'xdata',get(children(i),'xdata')*datefact);
    end
end

%Change the axes
datetick('x','HH:MM:SS');
zoomAdaptiveDateTicks('on');