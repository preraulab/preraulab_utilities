function caxisall(varargin)
ax=getallaxes;
for i=1:length(ax)
caxis(ax(i),varargin{:});
end