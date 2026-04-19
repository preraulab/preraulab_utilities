function str = struct2nvpstr(myStruct)
%STRUCT2NVPSTR  Convert a structure to a name-value pairs string
%
%   Usage:
%       str = struct2nvpstr(myStruct)
%
%   Inputs:
%       myStruct : struct - input structure -- required
%
%   Outputs:
%       str : char - comma-separated name-value pairs 'field', value, ...
%
%   Notes:
%       Similar to struct2nvp but uses a simpler value encoder (does not
%       support non-char/numeric scalar fallbacks via value2str).
%
%   Example:
%       s.field1 = 23;
%       s.field2 = 1:5;
%       s.field3 = 'Testing123';
%       str = struct2nvpstr(s);
%
%   See also: struct2nvp, struct2codestr, namedargs2cell
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main
fields = fieldnames(myStruct);
str = '';
for ii = 1:numel(fields)
    field = fields{ii};
    valueStr = value2str(myStruct.(field));
    if ii < numel(fields)
        str = [str '''' field ''', ' valueStr ', ']; %#ok<*AGROW>
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
