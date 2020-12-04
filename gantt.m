%GANTT  Creates a simple Gantt chart
%
%   Usage:
%         gantt(data, labels, color, <color options>)
%
%   Input:
%         data: 1 x <number of groups> cell array. Each element of the cell is a
%         N x 2 matrix of (start, end) ordered pairs -- required
%         labels: 1 x <number of groups> cell array of strings of group names
%         colors: <number of groups> x 3 matrix of RGB colors for each group
%         <color options>: add in additional property/value pairs for the rectangle object
%
%   Example:
%         g1 = [1 3; 7 12; 24 29];
%         g2 = [.234 5.6; 15.234 18.4; 19.5 25.3; 27.34 30];
%         g3 = 3 +[1 3; 7 12; 24 29];
%
%         data = {g1 g2 g3};
%
%         gantt(data,{'Task 1','Task 2','Task 3'},[1 .8 .8; .5 .5 1; .3 1 .3],'edgecolor','none')
%
%   Copyright 2019 Michael J. Prerau, Ph.D. - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%
%   Last modified 8/15/2019
%% ********************************************************************

function handles = gantt(data, labels, color, varargin)
if nargin == 0 || isempty(data)
    g1 = [1 3; 7 12; 24 29];
    g2 = [.234 5.6; 15.234 18.4; 19.5 25.3; 27.34 30];
    g3 = 3 +[1 3; 7 12; 24 29];
    
    data = {g1 g2 g3};
end


%Check that data is coming in as a cell
%Fix if it's a single group
if isnumeric(data) && size(data, 2) == 2
    data = {data};
end
if ~iscell(data)
    error('Data must be in cell format');
end

%Get axes and number of
ax = gca;
num_groups = length(data);

%Preallocate output cell array
if nargout == 1
    handles = cell(1, num_groups);
end

%Put generic labels if empty
if nargin<2 || isempty(labels)
    for group_num = 1:num_groups
        labels{group_num} = ['Group ' num2str(group_num)];
    end
end

%Put generic colors if empty
if nargin<3 || isempty(color)
    %Create repeating color orders of a large enough size for all
    %categories
    axcolors = ax.ColorOrder;
    color = repmat(axcolors,ceil(num_groups/size(axcolors,1)),1);
end

hold on;

%Loop through all groups and plot regions
for group_num=1:num_groups
    cat_data = data{group_num};
    duration = diff(cat_data,[],2);
    
    %Preallocate array of handle output
    if nargout == 1
        handles{group_num} = gobjects(1, length(duration));
    end
    
    %Create rectangle objects for the Gantt chart
    for region_num = 1:length(duration)
        h = rectangle('position', [cat_data(region_num,1), group_num, duration(region_num), 1], 'facecolor', color(group_num,:), 'edgecolor','k', varargin{:});
        
        %Save handles if output requested
        if nargout ==1
            handles{group_num}(region_num) = h;
        end
    end
end

%Update graph ticks to center group names on bars
set(ax,'ytick',(1:num_groups) + 0.5, 'yticklabels', labels);