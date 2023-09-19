%PAGEFIG  Generates letter-sized figure
%
%   Usage:
%   h=pagefig(h)
%
%   Input:
%   h: optional figure handle
%
%   Example:
%       % Generate portrait-oriented letter-sized figure
%       pfigh = pagefig;
%       % Change orientation to landscape
%       pagefig(pfigh,'landscape')
%       % Plot on figure
%       plot(randn(1000,1));
%
%   See also fullfig, mtit, myaa
%
%   Copyright 2011
%
%   Last revised 09/26/2011
%
%********************************************************************

function h=pagefig(varargin)
%Set optional direction input
p=inputParser;
p.addOptional('orient', 'portrait', @(x)any(validatestring(x,{'portrait','landscape'})));
p.addOptional('type', 'usletter');

if nargin==0
    h=figure;
    p.parse(varargin{:});
else
    %Allow for handle input
    if isnumeric(varargin{1})
        h=figure(varargin{1});
        p.parse(varargin{2:end});
    else
        h=figure;
        p.parse(varargin{:});
    end
end

%Get the parsed result
orientation=p.Results.orient;
paper_type=p.Results.type;

%Create figure
set(h,'paperorientation',orientation,'paperunits','inches','papertype',paper_type);

set(h,'units','inches','position',[0 0 get(gcf,'papersize')],'color','w');
set(h,'units','normalized');
