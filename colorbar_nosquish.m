function [ch] = colorbar_nosquish(ax,location)

if nargin<2
    location = 'eastoutside';
end


pos = ax.Position;
ch = colorbar(ax, 'location',location);
ax.Position = pos;

end
