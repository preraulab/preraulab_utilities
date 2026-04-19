%CCC  Clear variables, close figures, and clear the command window
%
%   Usage:
%       ccc
%
%   Inputs:
%       none
%
%   Outputs:
%       none (side effects only)
%
%   See also: clear, close, clc
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

clear; %Clear all variables
delete(get(0,'children')); %Delete all base objects
close all hidden; %Clear hidden objects
clc; %Clears the screen