function intersections = interval_intersect(intervals_1, intervals_2)
%INTERVAL_INTERSECT  Compute an intersection matrix for two lists of intervals
%
%   Usage:
%   Direct input:
%   intersections = interval_intersect(intervals_1, intervals_2)
%
%   Input:
%   intervals_1: Nx2 list of start/end bounds
%   intervals_2: Mx2 list of start/end bounds
%
%   Output:
%   intersections: MxN binary matrix of intersections
%   Example:
%     intersections = interval_intersect() %Demo shows all intersection possibilities
%
%   Copyright 2020 Michael J. Prerau, Ph.D. - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%
%   Last modified 3/12/2020
%% ********************************************************************

%Create sets that have all possible types of intersections:
% Left, Right, Inner, Outer, No-intersection
if nargin == 0
    intervals_1 = [1 3; 5 8; 11 14; 16 18]
    intervals_2 = [0 2; 6 9; 12 13; 15 19; 20 25]
end

%Get the time intervals for the first set
s1_starts = intervals_1(:,1);
s1_ends = intervals_1(:,2);

%Get the time intervals for the second set
s2_starts = intervals_2(:,1);
s2_ends = intervals_2(:,2);

%Create intersection matrix
intersections = zeros(length(s1_starts), length(s2_starts));

%Compute intersections
for ii = 1:length(s1_starts)
    %For two intervals [A B) and [X Y) intersection is:
    % intersect = X<A & B<Y
    intersections(ii,:) = s2_starts<s1_ends(ii) & s1_starts(ii)<s2_ends;
end