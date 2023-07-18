function [rows, cols] = squarest_subplots(num, landscape)
% SQUAREST_SUBPLOTS determines the best row and column configuration for
% subplots based on the number of plots.
%
% Syntax:
%   [rows, cols] = squarest_subplots(num)
%   [rows, cols] = squarest_subplots(num, landscape)
%
% Description:
%   SQUAREST_SUBPLOTS calculates the optimal number of rows and columns
%   for subplots based on the given number of plots (num). By default, the
%   function assumes a landscape orientation, but the landscape parameter
%   can be set to false to use a portrait orientation instead.
%
% Input Arguments:
%   - num: Number of plots.
%   - landscape (optional): Logical value indicating the orientation of
%     the subplots. Default is true (landscape).
%
% Output Arguments:
%   - rows: Number of rows for the subplot configuration.
%   - cols: Number of columns for the subplot configuration.
%
% Examples:
%   % Determine subplot configuration for 6 plots (default landscape)
%   num = 6;
%   [rows, cols] = squarest_subplots(num)
%
%   % Determine subplot configuration for 9 plots (portrait)
%   num = 9;
%   landscape = false;
%   [rows, cols] = squarest_subplots(num, landscape)
%
% See also:
%   ceil, sqrt, min, max

if nargin == 1
    landscape = true;  % Default to landscape orientation
end

switch num
    case 1
        rows = 1;
        cols = 1;
    case 2
        rows = 1;
        cols = 2;
    case 3
        rows = 1;
        cols = 3;
    case 4
        rows = 2;
        cols = 2;
    case 5
        rows = 2;
        cols = 3;
    case 6
        rows = 2;
        cols = 3;
    case 7
        rows = 2;
        cols = 4;
    case 8
        rows = 2;
        cols = 4;
    case 9
        rows = 3;
        cols = 3;
    case 10
        rows = 2;
        cols = 5;
    otherwise
        % Find the configuration that minimizes empty space and maximizes
        % squareness
        c = [1:ceil(sqrt(num)); ceil(num ./ (1:ceil(sqrt(num))))];
        [~, ind] = min(diff(c) / 2 + 2 * (prod(c) - num));
        rows = min(c(:, ind));
        cols = max(c(:, ind));
end

% Flip rows and columns if portrait orientation
if ~landscape
    temp = rows;
    rows = cols;
    cols = temp;
end
end
