function packagecode(fname, dest, toponly)
%PACKAGECODE  Copy a MATLAB function's required files into a destination folder
%
%   Usage:
%       packagecode(fname, dest)
%       packagecode(fname, dest, toponly)
%
%   Inputs:
%       fname   : char - name of the MATLAB function to package -- required
%       dest    : char - destination folder to copy files into -- required
%       toponly : logical - copy only top-level dependencies (default: true)
%
%   Outputs:
%       none (side effects only)
%
%   Example:
%       packagecode('myFunction', 'C:\Packages\MyFunctionPackage');
%       packagecode('myFunction', 'C:\Packages\MyFunctionPackage', false);
%
%   See also: matlab.codetools.requiredFilesAndProducts, mkdir, copyfile
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

if nargin < 3
    toponly = true;  % Consider only top-level files by default
end

if toponly
    filelist = matlab.codetools.requiredFilesAndProducts(fname, 'toponly');
else
    filelist = matlab.codetools.requiredFilesAndProducts(fname);
end

mkdir(dest);  % Create the destination folder

% Copy each file from the list to the destination folder
for i = 1:length(filelist)
    copyfile(filelist{i}, dest);
end
end
