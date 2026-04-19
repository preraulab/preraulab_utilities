function vargout = struct2nvp(myStruct)
%STRUCT2NVP  Convert a structure to a name-value pairs string
%
%   Usage:
%       str = struct2nvp(myStruct)
%
%   Inputs:
%       myStruct : struct - input structure -- required
%
%   Outputs:
%       str : char - comma-separated name-value pairs 'field', value, 'field', value, ...
%
%   Example:
%       s.field1 = 23;
%       s.field2 = 1:5;
%       s.field3 = 'Testing123';
%       s.field4 = {'apple', 42, [], {'a','b','c'}};
%       s.field5 = [];
%       s.field6 = {};
%       str = struct2nvp(s);
%
%   See also: struct2nvpstr, struct2codestr, namedargs2cell, value2str
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main
fields = fieldnames(myStruct);
vargout = '';
for ii = 1:numel(fields)
    field = fields{ii};
    valueStr = value2str(myStruct.(field));
    if ii < numel(fields)
        vargout = [vargout '''' field ''', ' valueStr ', ']; %#ok<*AGROW>
    else
        vargout = [ vargout '''' field ''', ' valueStr];
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
        elseif ischar(value)
            value_str = ['''' value ''''];
        elseif isstring(value) && isscalar(value)
            value_str = ['"' char(value) '"'];
        else
            error('struct2nvp:unsupportedType', ...
                'Unsupported value type ''%s'' for field.', class(value));
        end
    end
end
