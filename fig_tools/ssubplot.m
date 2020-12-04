%ssubplot  superior version of subplot
%
%   usage:
%       axis_handles=ssubplot([num_rows, num_cols])
%       axis_handles=ssubplot(num_rows, num_cols)
%       axis_handles=ssubplot(num_rows, margins)
%
%   input:
%   num_rows: the number of rows in the subplot
%   num_cols: the number of columns in the subplot
%   margins: a vector of margin size defined as [top bottom left right middle]
%            (default: [.1 .05 .08 .05 .08])
%   units: a string defining the units of the margin vector (default: 'normalized')
%
%   output:
%   axis_handles: a 1x(num_rows*numcols) vector of axis handles
%
%   example:
%
%         %define custom margins
%         top=.05;
%         bottom=.05;
%         left=.08;
%         right=.05;
%         middle=.08;
%
%         figure('units','inches','color','w','position',[0 0 8.5 11]);
%
%         %create subplot
%         ax=ssubplot(2,2,[top bottom left right middle]);
%         linkaxes(ax,'xy');
%
%         %plot in each axis
%         x=linspace(-pi,pi,10000);
%
%         for i=1:length(ax);
%             plot(ax(i), x,sin(i*x));
%             title(ax(i), ['axis ' num2str(i)]);
%             axis tight
%         end
%
%   copyright 2011 michael j. prerau, ph.d.
%
%   last modified 03/28/2011
%********************************************************************
function axis_handles=ssubplot(num_rows,num_cols,varargin)

p=inputParser;
p.addOptional('margins',[.05 .05 .08 .05 .08],@(x)any(isnumeric(x)));
p.addOptional('interact',false,@isnumeric);
p.addOptional('units','normalized',@(x)any(strcmpi(x,{'normalized', 'inches', 'centimeters', 'points'})))
p.addOptional('merge','');
p.addOptional('orient','landscape', @(x)any(validatestring(x,{'portrait','landscape'})));
p.addOptional('type', []);

p.parse(varargin{:});

margins=p.Results.margins;
interact=logical(p.Results.interact);
units=p.Results.units;
merge=p.Results.merge;
orientation=p.Results.orient;
paper_type=p.Results.type;

%check for one argument
if nargin==1
    %check if it's [num_rows, num_cols]
    if length(num_rows)==2
        num_cols=num_rows(2);
        num_rows=num_rows(1);
        %make the best matrix if just the number of plots
    elseif length(num_rows)==1
        [num_rows, num_cols]=spconfig(num_rows);
    end
end

%Get main figure
mainfig=gcf;
if ~isempty(paper_type)
    %Create figure
    set(mainfig,'paperorientation',orientation,'paperunits','inches','papertype',paper_type)
    set(mainfig,'units','inches','position',[0 0 get(gcf,'papersize')],'color','w');
end

set(mainfig,'units',units);
%Set up axes
axis_handles=set_axes(mainfig, margins(1),margins(2),margins(3),margins(4), margins(5), num_cols, num_rows, units);

%Disable interaction for merged
if ~isempty(merge)
    if interact
        disp('Interaction disabled for merged axes');
        interact=false;
    end
    
    if ~iscell(merge)
        merge_axes(axis_handles(merge));
    else
        for i=1:length(merge)
            merge_axes(axis_handles(merge{i}));
        end
        axis_handles=findobj(gcf,'type','axes');
    end
end

%Set up interaction
if interact
    if ~strcmpi(units,'normalized')
        pos=get(mainfig,'position');
        wmax=pos(3);
        hmax=pos(4);
    else
        hmax=1;
        wmax=1;
    end
    
    posfig = figure('Position',[250 250 350 280],...
        'MenuBar','none','NumberTitle','off',...
        'Name','Adjust Subplots','closerequestfcn',@(src,evnt)merge_on(mainfig));
    
    s1_h = uicontrol(posfig,'units','pixel','Style','slider',...
        'Max',hmax,'Min',1e-100,'Value',margins(1),...
        'SliderStep',[0.05 0.2],...
        'Position',[25 25 300 20]);
    s2_h = uicontrol(posfig,'units','pixel','Style','slider',...
        'Max',hmax,'Min',1e-100,'Value',margins(2),...
        'SliderStep',[0.05 0.2],...
        'Position',[25 75 300 20]);
    s3_h = uicontrol(posfig,'units','pixel','Style','slider',...
        'Max',wmax,'Min',1e-100,'Value',margins(3),...
        'SliderStep',[0.05 0.2],...
        'Position',[25 125 300 20]);
    s4_h = uicontrol(posfig,'units','pixel','Style','slider',...
        'Max',wmax,'Min',1e-100,'Value',margins(4),...
        'SliderStep',[0.05 0.2],...
        'Position',[25 175 300 20]);
    s5_h = uicontrol(posfig,'units','pixel','Style','slider',...
        'Max',max([wmax hmax]),'Min',1e-100,'Value',margins(5),...
        'SliderStep',[0.05 0.2],...
        'Position',[25 225 300 20]);
    sl_h=[s1_h s2_h s3_h s4_h s5_h];
    
    uicontrol(gcf,'units','pixel','Style','text','string','Top Margin','Position',[25 45 100 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','left');
    uicontrol(gcf,'units','pixel','Style','text','string','Bottom Margin','Position',[25 95 100 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','left');
    uicontrol(gcf,'units','pixel','Style','text','string','Left Margin','Position',[25 145 100 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','left');
    uicontrol(gcf,'units','pixel','Style','text','string','Right Margin','Position',[25 195 100 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','left');
    uicontrol(gcf,'units','pixel','Style','text','string','Middle Margins','Position',[25 245 100 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','left');
    
    e1=uicontrol(gcf,'units','pixel','Style','edit','string',num2str(margins(1)),'Position',[120 47 70 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','right');
    e2=uicontrol(gcf,'units','pixel','Style','edit','string',num2str(margins(2)),'Position',[120 97 70 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','right');
    e3=uicontrol(gcf,'units','pixel','Style','edit','string',num2str(margins(3)),'Position',[120 147 70 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','right');
    e4=uicontrol(gcf,'units','pixel','Style','edit','string',num2str(margins(4)),'Position',[120 197 70 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','right');
    e5=uicontrol(gcf,'units','pixel','Style','edit','string',num2str(margins(5)),'Position',[120 247 70 20],'backgroundcolor',get(gcf,'color'),'horizontalalign','right');
    
    eh=[e1 e2 e3 e4 e5];
    
    set(e1,'callback',@(src,evnt)updatetxt(axis_handles,sl_h,eh,1, mainfig, num_cols, num_rows, units));
    set(e2,'callback',@(src,evnt)updatetxt(axis_handles,sl_h,eh,2, mainfig, num_cols, num_rows, units));
    set(e3,'callback',@(src,evnt)updatetxt(axis_handles,sl_h,eh,3, mainfig, num_cols, num_rows, units));
    set(e4,'callback',@(src,evnt)updatetxt(axis_handles,sl_h,eh,4, mainfig, num_cols, num_rows, units));
    set(e5,'callback',@(src,evnt)updatetxt(axis_handles,sl_h,eh,5, mainfig, num_cols, num_rows, units));
    
    addlistener(s1_h,'ContinuousValueChange',@(src,evnt)slider_callback(axis_handles,sl_h,eh,1, mainfig, num_cols, num_rows, units));
    addlistener(s2_h,'ContinuousValueChange',@(src,evnt)slider_callback(axis_handles,sl_h,eh,2, mainfig, num_cols, num_rows, units));
    addlistener(s3_h,'ContinuousValueChange',@(src,evnt)slider_callback(axis_handles,sl_h,eh,3, mainfig, num_cols, num_rows, units));
    addlistener(s4_h,'ContinuousValueChange',@(src,evnt)slider_callback(axis_handles,sl_h,eh,4, mainfig, num_cols, num_rows, units));
    addlistener(s5_h,'ContinuousValueChange',@(src,evnt)slider_callback(axis_handles,sl_h,eh,5, mainfig, num_cols, num_rows, units));
    
    set(mainfig,'closerequestfcn',@(src,evnt)close_all(mainfig, posfig));
else
    f = uimenu('Label','Merge Axes');
    uimenu(f,'Label','Merge...','Callback',@(src,evnt)merge_axes);
end

function slider_callback(axs, sl_h, eh, val, mainfig, num_cols, num_rows, units)
if ~strcmpi(units,'normalized')
    pos=get(mainfig,'position');
    wmax=pos(3);
    hmax=pos(4);
else
    hmax=1;
    wmax=1;
end

%Get margins
margins=cell2mat(get(sl_h,'value'));
margins(val)=get(sl_h(val),'value');
set(eh(val),'string',num2str(margins(val)));

num_axes=length(axs);

top_margin=margins(1);
bottom_margin=margins(2);
left_margin=margins(3);
right_margin=margins(4);
mid_margin=margins(5);

%compute the height and width for the axes
ax_width=(wmax-left_margin-right_margin-mid_margin*(num_cols-1))/num_cols;
ax_height=(hmax-top_margin-bottom_margin-mid_margin*(num_rows-1))/num_rows;

ax_number=1;
%loop through each axis and define properties
for r=1:num_rows
    for c=1:num_cols
        if ax_number<=num_axes
            %compute left and bottom coordinates
            left=left_margin+mid_margin*(c-1)+ax_width*(c-1);
            bottom=hmax-top_margin-mid_margin*(r-1)-ax_height*r;
            
            set(axs(ax_number),'position',max([left bottom ax_width ax_height],1e-100));
            
            ax_number=ax_number+1;
        end
    end
end

function axis_handles=set_axes(mainfig, top_margin, bottom_margin, left_margin, right_margin, mid_margin, num_cols, num_rows,units)
if ~strcmpi(units,'normalized')
    pos=get(mainfig,'position');
    wmax=pos(3);
    hmax=pos(4);
else
    hmax=1;
    wmax=1;
end

%compute the height and width for the axes
ax_width=(wmax-left_margin-right_margin-mid_margin*(num_cols-1))/num_cols;
ax_height=(hmax-top_margin-bottom_margin-mid_margin*(num_rows-1))/num_rows;

%counter
ax_number=1;
num_axes=num_cols*num_rows;
axis_handles=zeros(1,num_axes);

%loop through each axis and define properties
for r=1:num_rows
    for c=1:num_cols
        if ax_number<=num_axes
            %compute left and bottom coordinates
            left=left_margin+mid_margin*(c-1)+ax_width*(c-1);
            bottom=hmax-top_margin-mid_margin*(r-1)-ax_height*r;
            
            axis_handles(ax_number)=axes('units',units,'position',[left bottom ax_width ax_height]);
            
            ax_number=ax_number+1;
        end
    end
end

function updatetxt(axs, sl_h, eh, val, mainfig, num_cols, num_rows, units)
newval=get(eh(val),'string');
set(sl_h(val),'value',str2double(newval));
slider_callback(axs, sl_h, eh, val, mainfig, num_cols, num_rows,units);

function merge_axes(merger_axes)

if nargin==0
    %If interactive selection is on
    disp('Click to select axes. Double click on final axis to merge...');
    %Create log of axes clicked
    handle=guidata(gcf);
    handle.axes=[];
    guidata(gcf,handle);
    
    %Get the axes in the figure
    all_axes=findobj(gcf,'type','axes');
    %Allow them to accept clicks
    set(all_axes,'buttondownfcn',@select_axes);
    
    %Pause until double click
    uiwait(gcf);
    
    %Grab axes to be merged
    handle=guidata(gcf);
    merger_axes=handle.axes;
end
units=get(merger_axes(1),'units');

if length(merger_axes)==1
    error('Must have more than one axis');
end

%Get the axes position
pos=cell2mat(get(merger_axes,'position'));

%Find new width
[~, imin]=min(pos(:,1));
[~, imax]=max(pos(:,1));
new_width=pos(imax,1)+pos(imax,3)-pos(imin,1);

%Find new height
[~, imin]=min(pos(:,2));
[~, imax]=max(pos(:,2));
new_height=pos(imax,2)+pos(imax,4)-pos(imin,2);

%Get new position
new_pos=[min(pos(:,1:2)) new_width new_height];

%Delete original axes and create new
delete(merger_axes)
new_axis=axes('units',units,'position',new_pos);

%Put below other axes
uistack(new_axis,'bottom');

%Select axes on the fly
function select_axes(varargin)
%Add selected axis to data
handle=guidata(gcf);
handle.axes=unique([handle.axes gca]);
guidata(gcf,handle);

%Continue merging
if strcmpi(get(gcf,'selectiontype'),'open')
    uiresume(gcf);
end

function merge_on(mainfig)
delete(gcf)
figure(mainfig)
f = uimenu('Label','Merge Axes');
uimenu(f,'Label','Merge...','Callback',@(src,evnt)merge_axes);


function close_all(mainfig, posfig)
delete(mainfig)
if ishandle(posfig)
    delete(posfig)
end