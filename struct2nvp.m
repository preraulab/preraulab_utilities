function str = struct2nvp(myStruct)
%STRUCT2NVP Converts a structure to name-value pairs string.
%
%   STR = STRUCT2NVP(MYSTRUCT) converts the fields and values of the input
%   structure MYSTRUCT into a name-value pairs string and returns it as STR.
%   The fields are separated by commas and each name-value pair is of the
%   form 'fieldname, value'. The values are converted to strings according
%   to their data type.
%
%   Inputs:
%   - myStruct: Input structure to convert to name-value pairs string.
%
%   Output:
%   - str: Name-value pairs string representing the input structure.
%
%   Example:
%         myStruct.field1 = 23;
%         myStruct.field2 = 1:5;
%         myStruct.field3 = 'Testing123';
%         myStruct.field4 = {'apple', 42, [], {'a','b','c'}};
%         myStruct.field5 = [];
%         myStruct.field6 = {};
% 
%         struct_str = struct2nvp(myStruct);
%         disp(struct_str)
%
%   See also FIELDNAMES, MAT2STR, NUM2STR, CELLFUN, STRJOIN.
%
%   Copyright 2023 Prerau Lab - http://www.sleepEEG.org
%   This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
%   (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%%%%%%%%%%%

fields = fieldnames(myStruct);
str = '';
for ii = 1:numel(fields)
    field = fields{ii};
    valueStr = value2str(myStruct.(field));
    if ii < numel(fields)
        str = [str '''' field ''', ' valueStr ', '];
    else
        str = [ str '''' field ''', ' valueStr];
    end
end

% Convert element value to string
    function value_str = value2str(value)
        if isempty(value)
            if isnumeric(value)
                value_str = '[]'; % Empty numeric array
            elseif iscell(value)
                value_str = '{}'; % Empty cell array
            elseif ischar(value)
                value_str = ''''''; % Empty character array
            end
        elseif isnumeric(value) && numel(value) > 1
            value_str = mat2str(value); % Numeric array
        elseif isnumeric(value) || islogical(value)
            value_str = num2str(value); % Numeric or logical scalar
        elseif iscell(value)
            % Recurse for all cell elements
            value_str = ['{' strjoin(cellfun(@value2str, value, 'UniformOutput', false), ', ') '}'];
        else
            value_str = ['''' value '''']; % String scalar or other types
        end
    end
end
