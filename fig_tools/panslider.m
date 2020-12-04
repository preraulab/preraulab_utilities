% PANSLIDER  pans the slider 'pslider' to a time 't'
% Input: pslider - pan slider object handle
%        zslider - zoom slider object handle
% Author: David Zhou
% Last modified: 8/7/14
function panslider(pslider,zslider,t)

zoom = get(zslider,'Value');
set(pslider,'Value',t + zoom/2);