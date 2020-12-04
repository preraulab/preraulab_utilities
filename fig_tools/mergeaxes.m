function new_axis=mergeaxes(merger_axes)
%If interactive selection is on
if nargin==0
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
new_axis=axes('position',new_pos);

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
