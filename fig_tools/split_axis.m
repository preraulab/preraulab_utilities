function new_axes = split_axis(varargin)
%SPLIT_AXIS Split an axis into multiple axes
%   new_axes = split_axis(hbreaks, vbreaks)
%              split_axis(ax, hbreaks, vbreaks)
%
% Inputs:
%   ax: handle to axis to split (default: current axis)
%   hbreaks: 1xH vector - horizontal partitions in % (left to right), must sum to 1 --required
%   vbreaks: 1xV vector -vertical partitions in % (top to bottom), must sum to 1 --required
%   delete_ax: logical - delete original axis (default: true)
%
% Outputs:
%   new_axes: array of handles to the new axis objects
%
%   Example:
%
%     figure
%     new_axes = split_axis([.1 .2 .4 .3], [.6 .2 .1 .1], true);
%
%     for ii = 1:length(new_axes)
%         new_axes(ii).Color = rand(1,3);
%     end
%
% Copyright 2023 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

%Run interactive mode
if nargin <= 1
    if nargin == 0
        ax = gca;
        fh = gcf;
    else
        ax = varargin{1};
        assert(isa(ax,'matlab.graphics.axis.Axes'), 'Single input must be axis handle');
        fh = get(gca,"Parent");
    end

    disp('Click to select horizontal slices, double-click/enter/escape');
    disp('then select veritcal slices, double-click/enter/escape to complete.')

    fh.UserData.y_slices = [];
    fh.UserData.x_slices = [];

    %Set range
    xlim([0 100])
    ylim([0 100])
    set(ax,'units','normalized');

    %Run horizontal selection
    isHoriz = 1;
    line_h = hline(0);

    set(fh,'KeyPressFcn',@handle_keys);

    % set function to call on mouse click
    set(fh, 'WindowButtonDownFcn', {@pick_slice,  line_h, isHoriz, fh});
    set(fh, 'WindowButtonMotionFcn', {@select_slice,ax, line_h, isHoriz});
    uiwait(fh);
    delete(line_h)

    %Run vertical selection
    isHoriz = 0;
    line_h = vline(0);
    set(fh, 'WindowButtonDownFcn', {@pick_slice,  line_h, isHoriz, fh});
    set(fh, 'WindowButtonMotionFcn', {@select_slice, ax, line_h, isHoriz});
    uiwait(fh)
    disp(fh.UserData)
    delete(line_h)
    set(fh, 'WindowButtonMotionFcn',[]);
    set(fh, 'WindowButtonDownFcn', []);

    %Extract the slices and process them
    x_slices = fh.UserData.x_slices;
    y_slices = fh.UserData.y_slices;

    if isempty(x_slices)
        x_slices = 1;
    else
        x_slices = diff([0  unique(sort(x_slices/100)) 1]);
        x_slices = x_slices/sum(x_slices);
    end

    if isempty(y_slices)
        y_slices = 1;
    else
        y_slices = 1 - diff([0  unique(sort(y_slices/100)) 1]);
        y_slices = y_slices/sum(y_slices);
    end

    disp('Command call:')
    disp(regexprep(['split_axis([' num2str(y_slices) '], [' num2str(x_slices) ']);'], '\s+', ' '));
    %Split the axes
    split_axis(ax,y_slices,x_slices);
    return;
end

% Parse possible axes input.
[ax, args, ~] = axescheck(varargin{:});

% Get handle to either the requested or a new axis.
if isempty(ax)
    ax = gca;
end

%Error check
assert(length(args)>= 2,'Must have at least two arguments')

hbreaks = args{1}(:);
vbreaks = args{2}(:);

if length(args)<3 || isempty(args{3})
    delete_ax = true;
else
    delete_ax = args{3};
end

%Normalize axis
ax.Units = 'normalized';

%Error check
%NOTE: This check is due to the likelihood of floating point approximation
%error. e.g. sum([.3 .6 .1]) does not equal 1 but sum([.1 .3 .6])
%This is due to inexact floating point representation of certain numbers,
%the error which may or may not cancel out depending on order of operations
%See: https://dl.acm.org/doi/pdf/10.1145/103162.103163 for more info
assert(abs(sum(vbreaks)-1)<1e-15, 'Sum of vertical breaks must be equal to 1');
assert(abs(sum(hbreaks)-1)<1e-15, 'Sum of horizontal breaks must be equal to 1');

vbreaks = vbreaks/sum(vbreaks);
hbreaks = hbreaks/sum(hbreaks);

%Get positions of original axis
ax_left = ax.Position(1);
ax_bottom = ax.Position(2);
ax_width = ax.Position(3);
ax_height = ax.Position(4);

Nv = length(vbreaks);
Nh = length(hbreaks);

%Counter for new axes
c = 1;

%Loop through all the partitions
for hh = 1:Nh
    for vv = 1:Nv
        %Create the new axis
        ax_new = axes;

        %Update left
        if vv == 1
            ax_new.Position(1) = ax_left;
        else
            ax_new.Position(1) = ax_left + sum(vbreaks(1:vv-1))*ax_width;
        end

        %Update bottom
        ax_new.Position(2) = ax_bottom+ax_height*sum(hbreaks(hh+1:end));

        %Update width/height
        ax_new.Position(3) = ax_width*(vbreaks(vv));
        ax_new.Position(4) = ax_height*(hbreaks(hh));

        %%Good for debugging
        % ax_new.Color = rand(1,3);
        % title(num2str(c))

        %Add to output vector
        new_axes(c) = handle(ax_new); %#ok<AGROW>
        c = c+1;
    end
end

%Hides original axis
if delete_ax
    delete(ax);
end


function select_slice(~,~,ax, line_h, isHoriz)
%Get the current point from the mouse
C = get(ax, 'CurrentPoint');
x = C(1,1);
y = C(1,2);
xl = xlim;
yl = ylim;

%Set key spots to lock on
key_spots = [.05 .1 .2 .25 .3 1/3 .4 .5 .6 2/3 .7 .75 .8 .9 .95];
%Tolerance for key spots
tol = .01;

%Contain line values
if x<xl(1)
    x = xl(1);
end

if x>xl(2)
    x = xl(2);
end

if y<yl(1)
    y = yl(1);
end

if y>yl(2)
    y = yl(2);
end

%Get the percentage of the line
px = (x-xl(1))/diff(xl);
py = (y-yl(1))/diff(yl);

%Find the closest hot spot
[dxkey, closest_keyx] = min(abs(px-key_spots));
[dykey, closest_keyy] = min(abs(py-key_spots));

%Check for horizontal line
if isHoriz
    %Check for lock
    if dykey<tol
        py_close = key_spots(closest_keyy);
        y = py_close*diff(yl)+yl(1);

        line_h.LineWidth = 3;
        line_h.Color = 'm';
    else
        line_h.LineWidth = 1;
        line_h.Color = 'k';
        py_close = py;
    end
    px_close = px;

    line_h.YData = [y y];
    title(ax, [num2str(py_close*100,3), '%'],'FontSize',15);
else
     %Check for lock
    if dxkey<tol
        px_close = key_spots(closest_keyx);
        x = px_close*diff(xl)+xl(1);

        line_h.LineWidth = 3;
        line_h.Color = 'm';
    else
        line_h.LineWidth = 1;
        line_h.Color = 'k';
        px_close = px;
    end

    py_close = py;
    line_h.XData = [x x];
    title(ax, [num2str(px_close*100,3), '%'],'FontSize',15);
end

%Select and save the picked slice
function pick_slice(~,~,line_h, isHoriz, fh)
if isHoriz
    y_val = line_h.YData(1);
    fh.UserData.y_slices = [fh.UserData.y_slices y_val];
    hline(line_h.YData(1));
else
    x_val = line_h.XData(1);
    fh.UserData.x_slices = [fh.UserData.x_slices x_val];
    vline(line_h.XData(1));
end

%Finds a double click
if strcmpi(get(fh,'selectiontype'),'open')
    uiresume(fh);
end

%Handle selection via enter/escape
function handle_keys(~,event)
   disp(event.Key);
   switch event.Key
       case {'return','escape'}
           uiresume(gcf);
   end

