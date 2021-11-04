function [ch] = colorbar_nosquish(ax,location)

if nargin<2
    location = 'eastoutside';
end

if strcmpi(class(ax),'double') & ishandle(ax)
    ax = handle(ax);
end

pos = ax.Position;
ch = colorbar(ax, 'location',location);
ax.Position = pos;

end
