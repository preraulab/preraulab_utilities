% hist3 = histcounts3(data, xedges,yedges,zedges)
function hist3 = histcounts3(data, xedges,yedges,zedges)

% make sure edges are non-sparse
xedges = full(xedges); 
yedges = full(yedges);
zedges = full(zedges);

[~,binx] = histcountsmex(data(:,1),xedges);
[~,biny] = histcountsmex(data(:,2),yedges);
[~,binz] = histcountsmex(data(:,3),zedges);

countslenx = length(xedges)-1;
countsleny = length(yedges)-1;
countslenz = length(zedges)-1;

% Filter out NaNs and out-of-range data
subs = [binx(:) biny(:) binz(:)];
subs(any(subs==0,2),:) = [];
subs(any(subs==0,3),:) = [];

%Create histogram cube
hist3 = accumarray(subs,ones(size(subs,1),1),[countslenx countsleny countslenz]);