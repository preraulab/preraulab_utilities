function h=getallaxes(h)
if nargin==0
    h=gcf;
end

c=get(gcf,'children');
h=c(isaxis(c));
end


function inds=isaxis(c)
inds=strcmp(get(c,'type'),'axes');
end