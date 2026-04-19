function remove_copyright_lines(directory)
%REMOVE_COPYRIGHT_LINES  Recursively remove specified copyright lines from .m files
%
%   Usage:
%       remove_copyright_lines(directory)
%
%   Inputs:
%       directory : char - directory to process recursively (default: pwd)
%
%   Outputs:
%       none (rewrites .m files in place)
%
%   Notes:
%       Strips the two-line Creative Commons BY-NC-SA 4.0 block from any .m
%       file found under the given directory. Intended for cleaning licence
%       boilerplate out of third-party contributions.
%
%   Example:
%       remove_copyright_lines('/Users/username/Documents/MATLAB');
%
%   See also: dir, textscan
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

    
    if nargin < 1
        directory = pwd;
    end
    
    % Get all .m files recursively
    files = dir(fullfile(directory, '**', '*.m'));
    
    % Define patterns to remove
    patterns = {
        '%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.'
        '%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)'
    };
    
    % Process each file
    for i = 1:length(files)
        filePath = fullfile(files(i).folder, files(i).name);
        remove_lines_from_file(filePath, patterns);
    end
    
    fprintf('Processing complete. Copyright lines removed where applicable.\n');
end

function remove_lines_from_file(filePath, patterns)
    % Read file content
    fid = fopen(filePath, 'r');
    if fid == -1
        warning('Could not open file: %s', filePath);
        return;
    end
    lines = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
    fclose(fid);
    
    lines = lines{1};
    
    % Remove matching lines
    linesToKeep = ~ismember(strtrim(lines), patterns);
    
    % Rewrite file if changes were made
    if any(~linesToKeep)
        fid = fopen(filePath, 'w');
        if fid == -1
            warning('Could not write to file: %s', filePath);
            return;
        end
        fprintf(fid, '%s\n', lines{linesToKeep});
        fclose(fid);
        fprintf('Updated: %s\n', filePath);
    end
end