function f_new = mergefigures(f1,f2)

set(f1,'units','normalized');
set(f2,'units','normalized');

f_new=figure;
figdesign(1,1,'type','usletter','orient','landscape');
set(f_new,'units','normalized');
clf;

c1=get(f1,'children');
c1=c1(strcmp(get(c1,'type'),'axes'));

for i=1:length(c1)
    if(strcmpi(c1(i).Type ,'axes'))
        C=copyobj(c1(i),f_new);
        
        xl=get(C,'xlim');
        set(C,'xlim',xl);
        
        yl=get(C,'ylim');
        set(C,'ylim',yl);
                
        set(C,'units','normalized');
        C.Position(1)=C.Position(1)/2;
        C.Position(3)=C.Position(3)/2;
        
        
        C.YAxis.FontSize=C.YAxis.FontSize*.8;
        C.XAxis.FontSize=C.XAxis.FontSize*.8;
    end
end

c2=get(f2,'children');
c2=c2(strcmp(get(c2,'type'),'axes'));

for i=1:length(c2)
    if(strcmpi(c2(i).Type ,'axes'))
        C=copyobj(c2(i),f_new);
        
        xl=get(C,'xlim');
        set(C,'xlim',xl);
        
        yl=get(C,'ylim');
        set(C,'ylim',yl);
        
        set(C,'units','normalized');
        C.Position(1)=C.Position(1)/2;
        C.Position(3)=C.Position(3)/2;
        C.Position(1)=C.Position(1)+.5;
        
        C.YAxis.FontSize=C.YAxis.FontSize*.8;
        C.XAxis.FontSize=C.XAxis.FontSize*.8;
    end
end