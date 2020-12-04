%
%[sline, stxt]=vscaleline(ax,time,label,dateform,vgap)
function [sline, stxt]=vscaleline(varargin)
if ishandle(varargin{1}) && strcmp(get(varargin{1},'type'),'axes')
    ax=varargin{1};
    time=varargin{2};
    varargin=varargin(3:end);
else
    ax=gca;
    time=varargin{1};
    varargin=varargin(2:end);
end

%Set up defaults
params={[num2str(time) ' seconds'], false, .01};
params(1:length(varargin))=varargin;

[tstring, dateform, vgap]=params{:};

set(ax,'yticklabel','');
xlabel(ax,'');

axpos=get(ax,'position');


if dateform
    time=time*datefact;
end

h=axpos(4)*(time/diff(ylim(gca)));

lpos(4)=h;
lpos(3)=0;
lpos(2)=axpos(2);
lpos(1)=axpos(1)-vgap;

sline=annotation(get(ax,'parent'),'line','position',lpos,'linewidth',3);


stxt=text(0,0,tstring,'rotation',90,'units','normalized','position',[-4*vgap h/2 0],'verticalalign','middle','horizontalalign','center');
