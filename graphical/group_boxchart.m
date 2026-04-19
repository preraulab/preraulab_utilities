function [h_box, pvals] = group_boxchart(data, groupid, feature_labels, group_labels, group_gap, feature_gap, markers, marker_colors, pvals, varargin)
%GROUP_BOXCHART  Draw a grouped boxchart with per-pair significance stars
%
%   Usage:
%       [h_box, pvals] = group_boxchart(data, groupid, feature_labels, ...
%           group_labels, group_gap, feature_gap, markers, marker_colors, pvals, ...)
%
%   Inputs:
%       data           : NxF double - F features over N observations -- required
%       groupid        : Nx1 double - group id per observation -- required
%       feature_labels : 1xF cell of char - feature labels
%                        (default: {'Feature 1', ..., 'Feature F'})
%       group_labels   : 1xG cell of char - group labels
%                        (default: {'Group 1', ..., 'Group G'})
%       group_gap      : double - spacing within a group (default: 0.5)
%       feature_gap    : double - spacing between features (default: 1)
%       markers        : 1xG char - marker glyphs per group (default: 'o^sdvph>o^sdvph>o^sdvph>')
%       marker_colors  : char or Nx3 double - colors
%                        (default: repmat(get(gca,'colororder'),5,1))
%       pvals          : FxK double - precomputed p-values;
%                        if empty, pairwise ttest2 is used (default: [])
%
%   Name-Value Pairs:
%       Any name-value pair accepted by boxchart is forwarded.
%
%   Outputs:
%       h_box : 1xF array of boxchart handles
%       pvals : FxK double of pairwise p-values
%
%   Example:
%       data = [randn(10,3); randn(12,3)+1; randn(15,3)-1];
%       groupid = [zeros(10,1); ones(12,1); 2*ones(15,1)];
%       group_boxchart(data, groupid);
%
%   See also: boxchart, ttest2, sigstar
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

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

% pvals
if (nargin<9 || isempty(pvals))
    use_ttest = true;
else 
    use_ttest = false;
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
    
    %pvals = nan(nchoosek(Ngroups,2),1); %Init storage variable for pvalues
    count = 0;
    
    for jj = 1:Ngroups
        %Get all group members
        group_idx = groupid == ids(jj);
        N = sum(group_idx);

        %Concatenate data
        xgroupdata = [xgroupdata; ones(N,1)*xpos(jj)]; %#ok<*AGROW>

        %Plot the data
        h_scatter(jj) = plot(xpos(jj)*ones(N,1),data(groupid==ids(jj),ii),markers(jj),...
            'markerfacecolor',marker_colors(jj,:),'markeredgecolor','none','markersize',5);
    
        % Get pvalues
        for nn = 1:Ngroups
            if (nn ~= jj) && (nn<jj) % only test each pair once with no self-testing
                count = count + 1;
                if use_ttest
                    [~, pvals(ii,count), ~, ~] = ttest2(data(groupid==ids(nn),ii), data(groupid==ids(jj),ii));
                end
                if pvals(ii,count) < 0.05
                    H = sigstar([xpos(nn), xpos(jj)], pvals(ii,count)); %Place sigstar
                    set(H(2), 'fontsize', 18)
                end
            end
        end
    end

    %Get the data for the features
    d = data(:,ii);

    %Plot the boxchart
    h_box(ii) = boxchart(xgroupdata,d(:),varargin{:});
end

%Update the ticks and the legend
set(gca,'XTick',xticks,'XTickLabel',feature_labels)
legend(h_scatter,group_labels, 'location', 'southwest');

%Update xlims and ylims 
xlim([0, max(xticks)+(min(xticks))])
ylim([min([0,min(data,[],'all')]), max(data, [], 'all')+max([0,min(data,[],'all')])])

hold off;
