function [NDbin_edges, NDbin_centers, NDbin_coords, bin_edges, bin_centers] = create_NDbins(bin_ranges, bin_widths, bin_steps, bin_methods)
%CREATE_NDBINS  Create N-dimensional bins with optional overlap
%
%   Usage:
%       [NDbin_edges, NDbin_centers, NDbin_coords, bin_edges, bin_centers] = ...
%           create_NDbins(bin_ranges, bin_widths, bin_steps, bin_methods)
%
%   Inputs:
%       bin_ranges  : NDx2 double - [min max] per dimension -- required
%       bin_widths  : 1xND double - bin width per dimension -- required
%       bin_steps   : 1xND double - step size per dimension -- required
%       bin_methods : char or 1xND cell - per-dimension method (default: 'full')
%                     Methods: 'full', 'partial', 'full_extend' (see create_bins)
%
%   Outputs:
%       NDbin_edges   : Kx1 cell - each cell is a 2xND edge matrix for one ND bin
%       NDbin_centers : KxND double - centers of each ND bin
%       NDbin_coords  : KxND double - integer grid coordinates for each ND bin
%       bin_edges     : 1xND cell of 2xN per-dimension edges
%       bin_centers   : 1xND cell of 1xN per-dimension centers
%
%   Notes:
%       Call with no arguments to run a built-in demo.
%
%   Example:
%       [NDbin_edges, NDbin_centers, ND_coords, bin_edges, bin_centers] = ...
%           create_NDbins([-3 3; -2 2; -4 4], [1 1 1], [.1 .1 .1]);
%
%   See also: create_bins, hist_slide
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

if nargin==0
    run_demo();
    return;
end

if isvector(bin_ranges)
    bin_ranges = bin_ranges(:)';
    ND = 1;
else
    assert(size(bin_ranges,2) == 2, 'bin_range must be an N x 2 matrix');
    ND = size(bin_ranges,1);
end

if nargin<4
    bin_methods = cell(1,ND);
end

%Format single string bin_method as cell
if ~iscell(bin_methods)
    bin_methods = {bin_methods};
end

% Set default to full
if length(bin_methods)<ND
    bin_methods{ND} = [];
end

%Create each dims edges independently
bin_edges = cell(1,ND);
bin_centers = cell(1,ND);
for ii = 1:ND
    [bin_edges{ii}, bin_centers{ii}] = create_bins(bin_ranges(ii,:), bin_widths(ii), bin_steps(ii), bin_methods{ii});
end

%Get all linearized coordinates without looing
NDbin_coords = cell(1,ND);

%Dynamically create ND grid
dims = cellfun(@length,bin_edges);
X = arrayfun(@(x)1:x,dims,'UniformOutput',false);
[NDbin_coords{:}]=ndgrid(X{:});

%Reshape into coordinates
NDbin_coords = cell2mat(cellfun(@(x)x(:),NDbin_coords,'UniformOutput',false));

NDbin_edges = cell(size(NDbin_coords,1),1);
NDbin_centers = zeros(size(NDbin_coords,1),ND);

%Merge all bins into linearized coordinates
for ii = 1:size(NDbin_coords,1)
    for dd = 1:ND
        NDbin_edges{ii}(:,dd) = bin_edges{dd}(:,NDbin_coords(ii,dd));
        NDbin_centers(ii,dd) = bin_centers{dd}(NDbin_coords(ii,dd));
    end
end

end

function run_demo()
%Create random data
x = randn(1000,1);
y = randn(1000,1)*.5;
z = randn(1000,1)*1.5;

%Get ND bins
[NDbin_edges, ~, ND_coords, ~, bin_centers]=...
    create_NDbins([-3 3; -2 2; -4 4],[1 1 1],[.1 .1 .1]);

%Compute histogram count in each bin
histvol = zeros(cellfun(@length,bin_centers));

for ii = 1:length(NDbin_edges)
    coords = ND_coords(ii,:);
    cx = coords(1);
    cy = coords(2);
    cz = coords(3);

    edges = NDbin_edges{ii};
    inds = x > edges(1,1) & x<= edges(2,1) & y > edges(1,2) & y <= edges(2,2) & z > edges(1,3) & z<= edges(2,3);

    histvol(cx,cy,cz) = sum(inds);
end

%Set up bins for slicing
[X,Y,Z] = meshgrid(bin_centers{1}, bin_centers{2}, bin_centers{3});
%Permute the order of v to match meshgrid dims
V = permute(histvol,[2 1 3]);

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
