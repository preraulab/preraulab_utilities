function [bin_edges, bin_centers] = create_bins(bin_range, bin_width, bin_step, bin_method)
%CREATE_BINS  Create 1-D bins with optional overlap
%
%   Usage:
%       [bin_edges, bin_centers] = create_bins(bin_range, bin_width, bin_step, bin_method)
%
%   Inputs:
%       bin_range  : 1x2 double - [min max] data range -- required
%       bin_width  : double - width of each bin -- required
%       bin_step   : double - step size between bin centers -- required
%       bin_method : char - 'full', 'partial', or 'full_extend' (default: 'full')
%
%   Outputs:
%       bin_edges   : 2xN double - row 1 = left edges, row 2 = right edges
%       bin_centers : 1xN double - centers of each bin
%
%   Notes:
%       bin_method controls how the first/last bin align to bin_range:
%         - 'full'        : first bin starts at bin_range(1), last ends at bin_range(2)
%         - 'partial'     : first bin center at bin_range(1); values outside bin_range ignored
%         - 'full_extend' : first bin starts at bin_range(1) - bin_width/2 (may exceed bin_range)
%
%   See also: create_NDbins, hist_slide
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

if nargin<4 || isempty(bin_method)
    bin_method = 'full';
end

switch lower(bin_method)

    case 'full'
        bin_range_new(1) = bin_range(1) + bin_width/2;
        bin_range_new(2) = bin_range(2) - bin_width/2;

        bin_centers = (bin_range_new(1):bin_step:bin_range_new(2));
        bin_edges = bin_centers + [-bin_width/2; bin_width/2];
        %bin_edges = max(min(bin_centers + [-bin_width/2 ; bin_width/2], bin_range(2)), bin_range(1));

    case 'partial'
        bin_centers = (bin_range(1):bin_step:bin_range(2));
        bin_edges = max(min(bin_centers + [-bin_width/2 ; bin_width/2], bin_range(2)),bin_range(1));

    case {'full_extend', 'full extend', 'extend'}
        bin_range_new(1) = bin_range(1) - floor((bin_width/2)/bin_step)*bin_step;
        bin_range_new(2) = bin_range(2) + floor((bin_width/2)/bin_step)*bin_step;

        bin_centers = (bin_range_new(1)+(bin_width/2)):bin_step:(bin_range_new(2)-(bin_width/2));
        bin_edges = bin_centers + [-bin_width/2; bin_width/2];

end
