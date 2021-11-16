%GETALLAXES Returns all the axes object within a given figure, ignoring all
%other objects

function axh = getallaxes(figh)
if nargin==0
    figh=gcf;
end

children = get(figh,'children');
axh = children(strcmp(get(children,'type'),'axes'));
end

