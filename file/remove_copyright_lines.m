function remove_copyright_lines(directory)
    %REMOVE_COPYRIGHT_LINES Recursively removes specified copyright lines from .m files
    %   This function searches for all .m files in the given directory and its
    %   subdirectories, removing specific copyright lines if they are present.
    %
    %   Usage:
    %       remove_copyright_lines('/path/to/directory');
    %
    %   Input:
    %       directory: string - path to the directory to process
    %
    %   Example:
    %       remove_copyright_lines('/Users/username/Documents/MATLAB');
    %
    
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