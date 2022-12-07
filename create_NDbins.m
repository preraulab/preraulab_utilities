function [NDbin_edges, NDbin_centers, NDbin_coords] = create_NDbins(bin_ranges, bin_widths, bin_steps, bin_methods)
%CREATE_BINS Create bins with potential for overlap
%   [NDbin_edges, NDbin_centers, NDbin_coords] = create_NDbins(bin_ranges, bin_widths, bin_steps, bin_methods)
%
% Inputs:
%   bin_ranges: NDx2 numeric vector - [min max] --required
%   bin_widths: numeric - how large each bin is --required
%   bin_steps: numeric - step size --required
%   bin_methods: char - 'full' starts the first bin at bin_range(1). 'partial' starts the
%               first bin with its bin center at bin_range(1) but ignores all values below
%               bin_range(1). 'full_extend' starts the first bin at bin_range(1) - bin_width/2.
%               Note that it is possible to get values outside of bin_range with this setting.
%               Default = 'full'.
%
% Outputs:
%   NDbin_edges: cell array of ND bin edges
%   NDbin_centers: ND x N - centers of each bin
%   NDboin_coords: ND coordinates for each bin
%
%   Copyright 2022 Michael J. Prerau, Ph.D. - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%********************************************************************

assert(size(bin_ranges,2) == 2, 'bin_range must be an N x 2 matrix');
ND = size(bin_ranges,1);

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

