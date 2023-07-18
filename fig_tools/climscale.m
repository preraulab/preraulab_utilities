%CLIMSCALE Rescale the color limits of an image to remove outliers with percentiles
%
%   Usage:
%       clims_new = climscale(hObj, ptiles, outliers)
%       climscale(outliers)
%       climscale(ptiles)
%
%   Input:
%       hObj: handle to axis or image object -- required
%       ptiles: 1x2 double - scaling percentiles (default: [5 98])
%       outliers: logical - remove outliers prior to scaling using isoutlier (default: true)
%
%   Output:
%       clims_new: 1x2 double - scaled caxis limits
%
%   Example:
%      ax = gca;
%      imagesc(peaks(500);
%      climscale;
%
function c = colorbar_noresize(varargin)
% COLORBAR_NORESIZE creates a colorbar that does not resize the axis.
%
% Syntax:
%   c = colorbar_noresize
%   c = colorbar_noresize(ax, <colorbar arguments>)
%
% Description:
%   COLORBAR_NORESIZE creates a colorbar associated with the current axis
%   (gca) or the specified axis (ax). By default, the colorbar will retain
%   the same size as the axis and will not cause any resizing. Additional
%   colorbar arguments can be provided.
%
% Input Arguments:
%   - ax (optional): Handle to the axis for which the colorbar will be
%     created. Default is the current axis (gca).
%   - <colorbar arguments>: Additional arguments to customize the colorbar.
%
% Output Argument:
%   - c: Handle to the created colorbar.
%
% Copyright 2023 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

if nargin == 0 || ~isa(varargin{1},'matlab.graphics.axis.Axes')
    ax = gca;   % Use the current axis if no input argument is provided
else
    ax = varargin{1};
end

pos = ax.Position;  % Save the current position of the axis
c = colorbar(ax, varargin{2:end});  % Create the colorbar
ax.Position = pos;  % Restore the original position of the axis

end

function clims_new = climscale(hObj, ptiles, outliers)
if nargin == 1
    if isa(hObj,'matlab.graphics.primitive.Image') || isa(hObj,'matlab.graphics.axis.Axes')
        ptiles =[5 98];
        outliers = true;
    elseif issorted(hObj) && isnumeric(hObj)
        ptiles = hObj;
        hObj = gca;
        outliers = true;
    elseif islogical(hObj)
        outliers = hObj;
        hObj = gca;
        ptiles =[5 98];
    else
        error('Single input must be object, ptiles, or logical');
    end
else
%Set default current axis
if nargin==0 || isempty(hObj)
    hObj=gca;
end

%Set default percentiles
if nargin<2 || isempty(ptiles)
    ptiles=[5 98];
end

%Set default percentils
if nargin<3 || isempty(outliers)
    outliers = true;
end
end

assert(ishandle(hObj) || isa(hObj,'matlab.graphics.primitive.Image') || isa(hObj,'matlab.graphics.axis.Axes'),['First input must be axis or image handle. Input was ' class(hObj)])
assert(issorted(ptiles) && isnumeric(ptiles), 'Percentiles must be monotically increasing and numeric');
assert(islogical(outliers), 'Outliers must be logical');


%Get color data
if isa(hObj,'matlab.graphics.primitive.Image')
    hIm = hObj;
    hAx = get(hIm, 'parent');
else
    hAx = hObj;
    hIm = findall(hAx,'type','image');
    assert(length(hIm) == 1,'More than one image found in axis. Use specific image handle');
end

%Get color data
data = hIm.CData(:);

%Make sure it is not a flat image
assert(range(data)>0,'Image data are all equal');

%Handle massive images
N = length(data);
if N > 1e9
    warning('Data too large to efficiently compute percentile. Using random sampling.');
    data = data(randi(N, 1, min(100000, N)));
end

%Find poorly formed data
if ~outliers
    bad_inds = isnan(data) | isinf(data);
else %Remove outliers if selected
    bad_inds = isnan(data) | isinf(data) | isoutlier(data);
end

%Compute color limits
clims_new = prctile(data(~bad_inds), ptiles);

if clims_new(1) == clims_new(2)
    return;
end

%Update axis scale
set(hAx,'clim',clims_new);
