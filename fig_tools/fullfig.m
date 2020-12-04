%FULLFIG  Generates full-screen figure
%
%   Usage:
%   fullfig(h)
%
%   Input:
%   h: optional figure handle
%
%   Example:
%       % Generate full-screen figure
%       fullfig;
%       % Plot on figure
%       plot(randn(1000,1));
%
%   See also mtit, myaa
%
%   Copyright 2011
%
%   Last revised 07/18/2011
%
%********************************************************************

function h=fullfig(h)

if nargin==0
    h=figure;
end
set(h,'units','normalize','position',[0 0 1 1]);