function [NDhist, bin_edges, bin_centers] = hist_slide(data, varargin)
%HIST_SLIDE Creates an N-dimensional histogram that allows for sliding windows
%
%   [NDhist, bin_edges, bin_centers] = hist_slide(data, varargin)
%
% Inputs:
%   data: numeric array
%       An N-dimensional numeric array containing the data to be used for
%       computing the histogram.  --required
%       bin_ranges: NDx2 numeric vector - [min max] --required
%       bin_widths: numeric - how large each bin is --required
%       bin_steps: numeric - step size --required
%       bin_methods: char - 'full' starts the first bin at bin_range(1). 'partial' starts the
%               first bin with its bin center at bin_range(1) but ignores all values below
%               bin_range(1). 'full_extend' starts the first bin at bin_range(1) - bin_width/2.
%               Note that it is possible to get values outside of bin_range with this setting.
%               Default = 'full'.
% Outputs:
%   NDhist: array
%       An N-dimensional array representing the computed histogram, where each element corresponds to
%       the count of data points falling within the corresponding bin.
%   bin_edges: 2 x of ND bin edges for each dim
%       A 2 x ND cell array containing the edges of the bins along each dimension stored in a cell array.
%   bin_centers: 1 x N - centers of each bin for each dim
%       A 1 x N cell array representing the centers of each bin for each dimension, stored in a cell array.
%
% Example:
%     % This demo script can be run by calling hist_slide() with no arguments
%
%     % Create random data
%     x = randn(1000,1);
%     y = randn(1000,1)*.5;
%     z = randn(1000,1)*1.5;
%
%     data = [x, y, z];
%     Ndim = size(data, 2);
%
%     [NDhist, bin_edges, bin_centers] = hist_slide(data, [-3 3; -2 2; -4 4], [1 1 1], [.1 .1 .1]);
%
%     % Set up bins for slicing
%     [X, Y, Z] = meshgrid(bin_centers{1}, bin_centers{2}, bin_centers{3});
%     % Permute the order of v to match meshgrid dims
%     V = permute(NDhist, [2 1 3]);
%
%     % Plot figure
%     figure
%     ax = figdesign(1, 3);
%     set(gcf, 'units', 'normalized', 'position', [0.0800 0.3954 0.7945 0.5083])
%     linkaxes3d(ax);
%
%     axes(ax(1))
%     xslice = [-1.25, 0, 1.25];
%     yslice = 0;
%     zslice = 0;
%     h = slice(X, Y, Z, V, xslice, yslice, zslice, 'cubic');
%     set(h, 'edgecolor', 'none');
%     xlabel('x axis');
%     ylabel('y axis');
%     zlabel('z axis');
%     title('Slices')
%     view(3)
%     axis equal
%
%     axes(ax(2))
%     contourslice(X, Y, Z, V, xslice, yslice, zslice, 'cubic');
%     xlabel('x axis');
%     ylabel('y axis');
%     zlabel('z axis');
%     title('Contour Slices')
%     view(3)
%     axis equal
%
%     axes(ax(3))
%     isosurface(X, Y, Z, V, 45)
%     isosurface(X, Y, Z, V, 25)
%     isosurface(X, Y, Z, V, 5)
%     xlabel('x axis');
%     ylabel('y axis');
%     zlabel('z axis');
%     camlight left
%     alpha(.2)
%     title('Isosurfaces')
%     view(3)
%     axis equal
%
%     set(ax, 'fontsize', 15)
%
% See also: create_NDbins
%
% Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

%Demo data
if nargin == 0
    run_demo();
    return;
end

%Compute number of dimensions
if isvector(data)
    %Run simple function if a 1D histogram
    [NDhist, bin_edges, bin_centers] = hist1D(data,varargin{:});
    return;
else
    Ndim = size(data,2);
end

%Get ND bins. The varargin uses the inputs for create_NDbins
[NDbin_edges, ~, ND_coords, bin_edges, bin_centers]=...
    create_NDbins(varargin{:});

%Compute histogram count in each bin
NDhist = zeros(cellfun(@length,bin_centers));

%Creates a function to find the data within the ND bin
funstr = 'index_fun = @(edges, data)';
for ii = 1:Ndim
    funstr = [funstr 'data(:, ' num2str(ii) ') > edges(1,' num2str(ii) ') &  data(:, ' num2str(ii) ') <= edges(2,' num2str(ii) ')']; %#ok<AGROW>
    if ii<Ndim
        funstr = [funstr ' & ']; %#ok<AGROW>
    end
end

%Create the function
eval([funstr ';']);

%Loop through the bins and count the items
for ii = 1:length(NDbin_edges)
    coords = num2cell(ND_coords(ii,:));

    edges = NDbin_edges{ii};
    inds = index_fun(edges,data);

    NDhist(coords{:}) = sum(inds);
end
end

%% *********************************************
%          1D HISTOGRAM FUNCTION
%***********************************************
%Directly compute 1D sliding histogram
function [NDhist, bin_edges, bin_centers] = hist1D(data,varargin)
[bin_edges, bin_centers] = create_bins(varargin{:});
NDhist = zeros(1,length(bin_centers));

for ii = 1:length(bin_centers)
    edges = bin_edges(:,ii);
    inds = data>edges(1) & data<=edges(2);
    NDhist(ii) = sum(inds);
end
end


%% *********************************************
%              DEMO FUNCTION
%***********************************************
function run_demo()
%Create random data
x = randn(1000,1);
y = randn(1000,1)*.5;
z = randn(1000,1)*1.5;

data = [x,y,z];

[NDhist, ~, bin_centers] =  hist_slide(data, [-3 3; -2 2; -4 4],[1 1 1],[.1 .1 .1]);

%Set up bins for slicing
[X,Y,Z] = meshgrid(bin_centers{1}, bin_centers{2}, bin_centers{3});
%Permute the order of v to match meshgrid dims
V = permute(NDhist,[2 1 3]);

%Plot figure
figure
ax = figdesign(1,3);
set(gcf,'units','normalized','position',[0.0800    0.3954    0.7945    0.5083])
linkaxes3d(ax);

axes(ax(1))
xslice = [-1.25, 0, 1.25];
yslice = 0;
zslice = 0;
h = slice(X,Y,Z,V,xslice,yslice,zslice,'cubic');
set(h,'edgecolor','none');
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');
title('Slices')
view(3)
axis equal

axes(ax(2))
contourslice(X,Y,Z,V,xslice,yslice,zslice,'cubic');
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');
title('Contour Slices')
view(3)
axis equal

axes(ax(3))
isosurface(X,Y,Z,V,45)
isosurface(X,Y,Z,V,25)
isosurface(X,Y,Z,V,5)
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');
camlight left
alpha(.2)
title('Isosurfaces')
view(3)
axis equal

set(ax,'fontsize',15)
end
