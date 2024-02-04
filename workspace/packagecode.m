function packagecode(fname, dest, toponly)
% PACKAGECODE copies the required files and products of a MATLAB function
% into a specified destination folder.
%
% Syntax:
%   packagecode(fname, dest)
%   packagecode(fname, dest, toponly)
%
% Description:
%   PACKAGECODE scans the MATLAB function specified by fname and retrieves
%   the list of files and products it depends on. It then copies those
%   files and products into the specified destination folder. By default,
%   only the top-level files and products are considered. Use the optional
%   argument toponly to include all dependencies.
%
% Input Arguments:
%   - fname: Name of the MATLAB function to be packaged.
%   - dest: Destination folder where the required files and products will
%     be copied to.
%   - toponly (optional): Logical value indicating whether only the
%     top-level files and products should be considered. Default is true.
%
% Examples:
%   % Package the required files and products of a MATLAB function
%   fname = 'myFunction';
%   dest = 'C:\Packages\MyFunctionPackage';
%   packagecode(fname, dest)
%
%   % Package all dependencies of a MATLAB function
%   fname = 'myFunction';
%   dest = 'C:\Packages\MyFunctionPackage';
%   toponly = false;
%   packagecode(fname, dest, toponly)
%
% See also:
%   matlab.codetools.requiredFilesAndProducts, mkdir, copyfile
% 
% Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

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
