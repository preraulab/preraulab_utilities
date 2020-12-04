%TOPXAXIS  copies xaxis to top of panel
% Copies ticks and markers of the xaxis to the top line of the panel
%
% Usage:
%   topxaxis
%
% Input:
%   None
%
% Copyright 2014, David Zhou, dwzhou@partners.org
% Last modified 7-28-2014
%********************************************************************
function topxaxis

hold on;
h1 = gca;
% % % move the title so it doesn't block 2nd axis
title1 = get(gca,'title');
titlepos = get(title1,'position')
set(title1,'position',[titlepos(1) titlepos(2)*1.2 titlepos(3)])

h2 = copyobj(h1,gcf);
set(h2,'position',get(h1,'position'));
set(h2,'XAxisLocation','top')
xlabel(h2,'')
title(h2,'')
linkaxes([h1 h2],'x');
linkaxes([h1 h2],'y');
hold on;

set(gcf,'CurrentAxes',h1)

end