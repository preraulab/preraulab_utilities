%SHADEBOUNDS  Plots a curve and shaded confidence intervals
%
%   Usage:
%       shadebounds(x, mid, hi, lo, cmid, cbounds, edgecolor)
% 
%   Input:
%   x: the xvalue of the curve
%   mid: the yvalue of the curve
%   hi: the upper bounds of the curve
%   lo: the lower bounds of the curve
%   cmid: the curve color
%   cbounds: the shaded bounds color
%   edgecolor: defines the bounds edge color
% 
%   Example:
%         
%
%   Copyright 2011 Michael J. Prerau, Ph.D.
%   
%   Last modified 07/11/2011
%********************************************************************

function [line_handle, bounds_handle] = shadebounds(x, mid, hi, lo, cmid, cbounds, edgecolor)

%Set defaults
if nargin==4
    cmid=[0 0 0];
    cbounds=[.95 .95 .95];
    edgecolor=[.9 .9 .9];
elseif nargin==5
    cbounds=[.95 .95 .95];
    edgecolor=[.9 .9 .9];
elseif nargin==6
    edgecolor=[.9 .9 .9];
end

%Make sure all vectors are pointing in the same direction
x=x(:)';
mid=mid(:)';
lo=lo(:)';
hi=hi(:)';

%Plot curve and bounds
hold on
bounds_handle = fill([x fliplr(x)],[lo fliplr(hi)],cbounds,'edgecolor',edgecolor);
line_handle = plot(x,mid,'linewidth',2,'color',cmid);


