%FINDCLOSEST  Compares two vectors A and B, and finds the elements in A closest to B
%
%   Usage:
%       [vals inds]=findclosest(A, B)
%
%   Input:
%   A: 1xN vector of numeric values
%   B: 1XM vector of numeric values to compare to those in A
%
%   Output:
%   vals: the values of the elements in A that are closest to B
%   inds: the indices of the values in A to which those in B are closest
%
%   Example:
%
%         %Create data sets
%         A=[-1 5 74 2 9 -45 23 75 23]
%         B=[-3.4 5.6 9.45 -100]
%
%         %Define events
%         [vals inds]=findclosest(A, B)
%
%   Copyright 2011 Michael J. Prerau, Ph.D.
%
%   Last modified 01/13/2011
%********************************************************************
function [vals, inds]=findclosest(A, B)
inds=zeros(1,length(B));

%Use fast matrix method for smaller data sets
if length(A)*length(B)*2<50000
    [~, inds]=min(abs(ones(length(A),1)*B(:)'-A(:)*ones(1,length(B))));
else %Use slow method for large sets
    %     disp('Datasets large. Switching to iterative method');
    for i=1:length(B)
        [~, inds(i)]=min(abs(A-B(i)));
    end
end

vals=A(inds);