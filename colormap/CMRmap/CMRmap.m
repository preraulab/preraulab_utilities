%% 9 Level Color Scale Colormap with Mapping to Grayscale for Publications.
%
N=1024;
map1=[0 0 0;.15 .15 .5;.3 .15 .75;.6 .2 .50;1 .25 .15;.9 .5 0;.9 .75 .1;.9 .9 .5;1 1 1];
for i=1:3
map(i,:)=interp1(1:size(map1,1),map1(:,i),linspace(1,size(map1,1),N));
end
colormap(map')
