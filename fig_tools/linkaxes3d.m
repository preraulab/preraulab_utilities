%LINKAXES3D   Links 3D axes so that they can rotate in unison
%
%   Usage:
%   linkaxes3d(axes)
%
%   Input:
%   axes: should be set of 3D axes
%
%   Example:
%     axs(1)=subplot(121);
%     surf(peaks(500),'edgecolor','none');
% 
%     axs(2)=subplot(122);
%     surf(peaks(500),'edgecolor','none');
%     linkaxes3d(axs);
%
%   See also surfaceplot, surfaceplot_input, timesurfaceplot
%
%   Copyright Michael J. Prerau Ph.D. 2011
%
%   Last revised 04/25/2013
%
%********************************************************************
function linkaxes3d(axes)
axeslink = linkprop(axes,{'CameraPosition','CameraUpVector'});
key = 'graphics_linkprop';

% Store link object on first subplot axes
setappdata(axes(1),key,axeslink); 
