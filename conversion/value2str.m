%VALUE2STR Convert a value to its string representation
%
%   Usage:
%       value_str = value2str(value)
%
%   Input:
%       value: any - input value to be converted to a string -- required
%
%   Output:
%       value_str: char - string representation of the input value
%
%   Example:
%       % Convert numeric array to string
%       value_str = value2str([1, 2, 3]);
%
%       % Convert cell array to string
%       value_str = value2str({'a', 'b', 'c'});
% 
% Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

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