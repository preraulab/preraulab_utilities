%Plot a curve with thresholds under it with varying colors
function area_handles = threshold_plot(x, y, threshes, colors)

%Create test data
if nargin == 0
    Fs = 100;
    dt = 1/Fs;
    x = dt:dt:10;
    y = sin(2*pi*.2*x).^2;
    
    threshes = 1:-.25:.25;
end

%Get colors to be default color order
if nargin<4
    colors = repmat(get(gca,'colororder'),5,1);
end

%Save area handles
area_handles = zeros(size(threshes));

%Go from largest to smallest
threshes = sort(threshes,'descend');

%Loop through thresholds and plot
hold on
for ii = 1:length(threshes)
    thresh = threshes(ii);
    tplot = y;
    
    %Chop off data at threshold
    tplot(tplot>thresh) = thresh;
    h = area(x, tplot);
    
    h.FaceColor = colors(ii,:);
    
    area_handles(ii) = h;
end