function equalize_axes(ax, varargin)
%EQUALIZE_AXES Equalize the axes limits across multiple axes.
%   equalize_axes(ax) equalizes the axes limits across multiple axes 
%   specified by the input ax. The function adjusts the limits of each 
%   axis to the tightest range and also considers images within the axes 
%   to update the color limits if present.
%
%   equalize_axes(ax, dimension) allows you to specify the dimensions 
%   across which the axes limits should be equalized. The dimension 
%   argument should be a string that can include any combination of the 
%   following characters: 'x', 'y', 'z', and 'c'. By default, all 
%   dimensions ('xyzc') are equalized.
%
%   Example:
%       % Create a figure with images and plots
%       figure
%       ax = figdesign(3, 2);
%   
%       axes(ax(1))
%       imagesc(peaks(100) + 5)
%       colorbar
%   
%       axes(ax(3))
%       imagesc(peaks(200) - 5)
%       colorbar
%   
%       axes(ax(5))
%       imagesc(peaks(300))
%       colorbar
%   
%       axes(ax(2))
%       N = 100;
%       t = 1:N;
%       plot(t, t * 3 - 4 + randn(size(t)) * 50, '.')
%   
%       axes(ax(4))
%       N = 200;
%       t = 1:N;
%       plot(t, t * -3 + 6 + randn(size(t)) * 80, '.')
%   
%       axes(ax(6))
%       N = 300;
%       t = 1:N;
%       plot(t, t * 4 - 12 + randn(size(t)) * 20, '.')
%   
%       equalize_axes(ax([1 3 5]), 'c');
%       equalize_axes(ax([2 4 6]), 'xy');
%
%   Copyright 2023 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%

if nargin == 0
    %Create a figure with images and plots
    figure
    ax = figdesign(3,2);

    axes(ax(1))
    imagesc(peaks(100)+5)
    colorbar

    axes(ax(3))
    imagesc(peaks(200)-5)
    colorbar

    axes(ax(5))
    imagesc(peaks(300))
    colorbar

    axes(ax(2))
    N = 100;
    t = 1:N;
    plot(t, t*3 - 4 + randn(size(t))*50,'.')

    axes(ax(4))
    N = 200;
    t = 1:N;
    plot(t, t*-3 + 6 + randn(size(t))*80,'.')

    axes(ax(6))
    N = 300;
    t = 1:N;
    plot(t, t*4 - 12 + randn(size(t))*20,'.')

    equalize_axes(ax([1 3 5]),'c');
    equalize_axes(ax([2 4 6]),'xy');
    return
end

assert(length(ax)>1,'Must have more than one axis to equalize across')

% Check if remaining inputs are valid
p = inputParser;
%Make sure there is at least one valid option
addOptional(p, 'dimension', 'xyzc', @(x)(any(strfind(x,'x')) || any(strfind(x,'y')) || any(strfind(x,'z')) || any(strfind(x,'c'))));

parse(p, varargin{:});
dimension = p.Results.dimension;

%Set each axis to the tightest range
for ii = 1:length(ax)
    %Set each axis tight to grab the data range
    axis(ax(ii),'tight')

    %Look for images to check for color ranges
    hIm = findall(ax(ii),'type','image');
    if ~isempty(hIm)
        assert(length(hIm) == 1,'More than one image found in axis. Use specific image handle');

        %Get color data
        data = hIm.CData(:);

        %Make sure it is not a flat image
        assert(range(data)>0,'Image data are all equal');

        %Make color axis "tight"
        ax(ii).CLim = [min(data) max(data)];
    end
end

%Get the total range across all axes and update values
if any(strfind(dimension,'x'))
    [xmin, xmax] = bounds([ax.XLim]);
    xlim(ax,[xmin xmax])
end

if any(strfind(dimension,'y'))
    [ymin, ymax] = bounds([ax.YLim]);
    ylim(ax,[ymin ymax])
end

if any(strfind(dimension,'z'))
    [zmin, zmax] = bounds([ax.ZLim]);
    zlim(ax,[zmin zmax])
end

if any(strfind(dimension,'c'))
    [cmin, cmax] = bounds([ax.CLim]);
    set(ax,'CLim',[cmin cmax])
end






