function h_box = group_boxchart(data, groupid, feature_names, group_names, feature_spacing, group_spacing, markers, marker_colors)

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
if nargin<3
    feature_names = cell(1,Nfeatures);
    for ii = 1:Nfeatures
        feature_names{ii} = ['Feature ' num2str(ii)];
    end
end

%Set default group names
if nargin<4
    group_names = cell(1,Ngroups);
    for ii = 1:Ngroups
        group_names{ii} = ['Group ' num2str(ii)];
    end
end

if nargin<5
    %Spacing between the features
    feature_spacing = 1;
end

if nargin<6
    %Between group spacing
    group_spacing = 1.5;
end

%Data markers
if nargin<7
    markers = 'o^sdvph>o^sdvph>o^sdvph>';
end

%Data colors
if nargin<8
    marker_colors = 'rgbcymkorgbcymkorgbcymko';
end

%Force character colors to be column vector
if ischar(marker_colors)
    marker_colors = marker_colors(:);
else
    assert(size(marker_colors,2) == 3,'Color must be vector of characters or Nx3 matrix');
end

%% Create plot
hold all;

%Loop through each of the features
for ii = 1:Nfeatures
    %Set the x positions
    xpos(1) = ii+(2*feature_spacing+group_spacing)*(ii-1);
    for jj = 2:Ngroups
        xpos(jj) = xpos(jj-1)+feature_spacing;
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
    h_box(ii) = boxchart(xgroupdata,d(:));
end

%Update the ticks and the legend
set(gca,'XTick',xticks,'XTickLabel',feature_names)
legend(h_scatter,group_names);
