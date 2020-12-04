%PRECISE_DATATIP Makes a far more precise data tip in cursor mode
%
% precise_datatip()
% precise_datatip(h_fig)
% precise_datatip(precision)
% precise_datatip(h_fig, precision)
%
% Inputs:
%   h_fig: figure handle (default: gca)
%   precision: number of decimal places to show (default: 10)
%
function precise_datatip(varargin)

if nargin==0
    figh=gcf;
    precision=10;
elseif nargin==1
    if ~ishandle(varargin{1})
        figh=gcf;
        precision=varargin{1};
    else
        precision=10;
        figh=varargin{1};
    end
elseif nargin==2
    figh=varargin{1};
    precision=varargin{2};
else
    disp(nargin);
end

set(datacursormode(figh),'enable','on','UpdateFcn',{@bettertip,precision});

function txt = bettertip(~,event_obj,precision)
  if ~(ishandle(event_obj) || isa(event_obj,'matlab.graphics.internal.DataTipEvent'))
      txt='Error in object being passed to datatip'; 
      return; 
  end %sanity check
  pos = get(event_obj,'Position');
  x = pos(1);
  y = pos(2);
  % Note: each element in txt{} is displayed on a separate line
  txt = {sprintf(['X: %.' num2str(precision) 'f'],x), '', sprintf(['Y: %.' num2str(precision) 'f'],y)};