%HLINE  Draw a horizontal line
%
%   Usage:
%   h = hline(yvals,<line inputs>)
%   h = hline(ax, yvals, <line inputs>)
% 
%   Input:
%   yvals: y coordinate(s) of line (scalar or vector)
% 
%   Output:
%   h: handle for lines
% 
%   Example:
%         % Create a new figure
%         figure;
%         % Draw some lines
%         h=hline([-1 3 4.2],'linewidth',2,'color','k');
%
%   See also vline, line
%
% Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

function h=hline(varargin)

warning('Use matlab native xline instead...')

% Parse possible axes input.
[ax, args, ~] = axescheck(varargin{:});

% Get handle to either the requested or a new axis.
if isempty(ax)
   ax = gca;
end

if isempty(args) 
    error('Must provide line values');
end

yvals = args{1}(:);

hold on;
h=line(xlim(ax),[yvals yvals]', args{2:end});
hold off;