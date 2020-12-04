%RANDINT  Generate a matrix of random integers 
%
%   Usage:
%   intmat=randint(maxint)
%   intmat=randint(minint,maxint)
%   intmat=randint(minint,maxint,rows,cols)
% 
%   Input:
%   minint: minimum integer value (Default:1)
%   maxint: maximum integer value
%   rows: number of rows (Default:1)
%   cols: number of columns (Default:1)
% 
%   Output:
%   intmat: matrix of random integers
% 
%   Example:
%         intmat=randint(2,10,1,50);
%
%   Copyright 5/23/12 Katie Hartnack
%   
%   Last modified 5/23/12
%********************************************************************

function result=randint(minint,maxint,rows,cols)
%Set default matrix size to 1x1
if nargin<=2
    rows=1;
    cols=1;
end

%Set minint to 1 for one argument
if nargin==1
    maxint=minint;
    minint=1;
end

%Defines the range of random integers
range=maxint-minint+1;
%Creates an offset to get desired numbers
offset=minint-1;

%Computes random integer matrix
result=ceil(rand(rows,cols)*range) + offset;
