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