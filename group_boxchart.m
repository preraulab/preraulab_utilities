function h_box = group_boxchart(data, groupid, feature_labels, group_labels, group_gap, feature_gap, markers, marker_colors, varargin)
%GROUP_BOXCHART  Creates a grouped boxchart
%
%   Usage:
%   h_box = group_boxchart(data, groupid, feature_names, group_names, group_gap, feature_gap, markers, marker_colors, <boxchart_params>)
%
%   Input:
%   data: NxF data with F features and N observations across all groups
%   groupid: Nx1 column vector with group ids
%   feature_labels: 1xF cell of chars with feature lables (default: {'Feature 1',...'Feature N'})
%   group_labels: 1xG cell of chars with group labels (default: {'Group 1',...'Group N'})
%   group_gap: double - the spacing within groups boxplot (default: .5)
%   feature_gap: double - the spacing between each boxplot group between features (default: 1)
%   markers: 1xG char - markers for each group (default: 'o^sdvph>')
%   marker_colors: chars or Nx3 matrix of colors (default: matlab color order)
%   boxchart_params: optional parameters to the boxchart function
%
%   Output:
%   h_box: handle to boxchart objects
%
%   Example:
%     figure
%     %% Generate Data
% 
%     N1 = 10; %Number in group 1
%     N2 = 12; %Number in group 2
%     N3 = 15; %Number in group 3
% 
%     data1 = [randn(N1,1) randn(N1,1)+2 randn(N1,1)*2-3];
%     data2 = [randn(N2,1)-1 randn(N2,1)-2 randn(N2,1)/2+3];
%     data3 = [randn(N3,1)+.5 randn(N3,1)+3 randn(N3,1)-1];
% 
%     data = [data1; data2; data3];
% 
%     %Group id
%     groupid = [ones(N1,1)*0; ones(N2,1)*1; ones(N3,1)*2];
% 
%     group_boxchart(data,groupid);
%
%   Copyright 2022 Michael J. Prerau, Ph.D. - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%
%   Last modified 02/19/2022
%********************************************************************
if nargin == 0
    %% Generate Data

    N1 = 10; %Number in group 1
    N2 = 12; %Number in group 2
    N3 = 15; %Number in group 3

    data1 = [randn(N1,1) randn(N1,1)+2 randn(N1,1)*2-3];
    data2 = [randn(N2,1)-1 randn(N2,1)-2 randn(N2,1)/2+3];
    data3 = [randn(N3,1)+.5 randn(N3,1)+3 randn(N3,1)-1];

    data = [data1; data2; data3];

    %Group id
    groupid = [ones(N1,1)*0; ones(N2,1)*1; ones(N3,1)*2];
end

%Get unique group ids
ids = unique(groupid);
Ngroups = length(ids);

%Number of features
Nfeatures = size(data,2);

%Create the xtick locations
xticks = zeros(1,Nfeatures);
xpos = zeros(1, Ngroups);

%Set default feature names
if nargin<3 || isempty(feature_labels)
    feature_labels = cell(1,Nfeatures);
    for ii = 1:Nfeatures
        feature_labels{ii} = ['Feature ' num2str(ii)];
    end
end

%Set default group names
if nargin<4 || isempty(group_labels)
    group_labels = cell(1,Ngroups);
    for ii = 1:Ngroups
        group_labels{ii} = ['Group ' num2str(ii)];
    end
end

if nargin<5 || isempty(group_gap)
    %Spacing within groups
    group_gap = .5;
end

if nargin<6 || isempty(feature_gap)
    %Between features spacing
    feature_gap = 1;
end

%Data markers
if nargin<7 || isempty(markers)
    markers = 'o^sdvph>o^sdvph>o^sdvph>';
end

%Data colors
if nargin<8 || isempty(marker_colors)
    marker_colors = repmat(get(gca,'colororder'),5,1);
end

%Force character colors to be column vector
if ischar(marker_colors)
    marker_colors = marker_colors(:);
else
    assert(size(marker_colors,2) == 3,'Color must be vector of characters or Nx3 matrix');
end

assert(length(groupid)==size(data,1),'Group id must be column vector of length equal to data rows');

%% Create plot
hold all;

%Loop through each of the features
for ii = 1:Nfeatures
    %Set the x positions
    xpos(1) = ii+(2*group_gap+feature_gap)*(ii-1);
    for jj = 2:Ngroups
        xpos(jj) = xpos(jj-1)+group_gap;
    end

    %Set the xticks in the middle of the group
    xticks(ii) = mean(xpos);

    %Assemble the group data
    xgroupdata = [];
    h_scatter = zeros(1,Ngroups);

    for jj = 1:Ngroups
        %Get all gorup members
        group_idx = groupid == ids(jj);
        N = sum(group_idx);

        %Concatenate data
        xgroupdata = [xgroupdata; ones(N,1)*xpos(jj)];

        %Plot the data
        h_scatter(jj) = plot(xpos(jj)*ones(N,1),data(groupid==ids(jj),ii),markers(jj),'markerfacecolor',marker_colors(jj,:),'markersize',5);
    end

    %Get the data for the features
    d = data(:,ii);

    %Plot the boxchart
    h_box(ii) = boxchart(xgroupdata,d(:),varargin{:});
end

%Update the ticks and the legend
set(gca,'XTick',xticks,'XTickLabel',feature_labels)
legend(h_scatter,group_labels);

hold off;
