function new_axes = split_axis(ax, hbreaks, vbreaks)
%SPLIT_AXIS Split an axis into multiple axes
%   new_axes = split_axis(ax, hbreaks, vbreaks)
%
% Inputs:
%   ax: handle to axis to split --required
%   hbreaks: horizontal partitions in %, must sum to 1 --required
%   vbreaks: vertical partitions in %, must sum to 1 --required
%
% Outputs:
%   new_axes: array of handles to the new axis objects
%
%   Example:
%
%     figure
%     ax = gca;
%
%     new_axes = split_axes(ax,[.1 .2 .4 .3], [.6 .2 .1 .1]);
%     
%     for ii = 1:length(new_axes)
%         new_axes(ii).Color = rand(1,3);
%     end
%
%   Copyright 2022 Michael J. Prerau, Ph.D. - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%
%   Last modified 03/10/2022
%********************************************************************
if isempty(ax)
    ax = gca;
end

ax.Units = 'normalized';


assert(sum(vbreaks)==1,'Sum of vbreaks must equal 1');
assert(sum(hbreaks)==1,'Sum of hbreaks must equal 1');

%Get positions of original axis
L = ax.Position(1);
B = ax.Position(2);
W = ax.Position(3);
H = ax.Position(4);

Nv = length(vbreaks);
Nh = length(hbreaks);

%Counter for new axes
c = 1;
new_axes = [];

%Loop through all the partitions
for vv = 1:Nv
    for hh = 1:Nh

        %Create the new axis
        ax_new = axes;

        %Update left
        if vv == 1
            ax_new.Position(1) = L;
        else
            ax_new.Position(1) = L + sum(vbreaks(1:vv-1))*W;
        end

        %Update bottom
        if hh == 1
            ax_new.Position(2) = B;
        else
            ax_new.Position(2) = B + sum(hbreaks(1:hh-1))*H;
        end

        %Update width/height
        ax_new.Position(3) = W*(vbreaks(vv));
        ax_new.Position(4) = H*(hbreaks(hh));

        %%Good for debugging
        %ax_new.Color = rand(1,3);

        %Add to output vector
        new_axes(c) = ax_new;
        c = c+1;
    end
end