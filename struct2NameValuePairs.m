function str = struct2NameValuePairs(myStruct)
%STRUCT2NAMEVALUEPAIRS Convert a structure to name-value pairs string.
%   STR = STRUCT2NAMEVALUEPAIRS(MYSTRUCT) converts a structure MYSTRUCT
%   into a string representation of name-value pairs. The output STR
%   contains the names and values of the fields in MYSTRUCT, separated by
%   commas.

%   Input:
%       - myStruct: Input structure to be converted.
%
%   Output:
%       - str: String representation of name-value pairs.
%
%   Examples:
%       myStruct = struct('field1', 123, 'field2', 'hello', 'field3', [1, 2, 3]);
%       str = struct2NameValuePairs(myStruct)
%       % Output:
%       % str = 'field1, 123, field2, 'hello', field3, [1, 2, 3]'

fields = fieldnames(myStruct);
str = '';
for ii = 1:numel(fields)
    field = fields{ii};
    value = myStruct.(field);
    if isnumeric(value) && numel(value) > 1
        valueStr = mat2str(value);
    elseif isnumeric(value) || islogical(value)
        valueStr = num2str(value);
    elseif iscell(value)
        valueStr = ['{' strjoin(cellfun(@convertElementToString, value, 'UniformOutput', false), ', ') '}'];
    else
        valueStr = ['''' value ''''];
    end
    if ii<numel(fields)
        str = [str field ', ' valueStr ', '];
    else
        str = [str field ', ' valueStr];
    end
end

%Convert element to string
function str = convertElementToString(element)
if isnumeric(element) && numel(element) > 1
    str = mat2str(element);
elseif isnumeric(element)
    str = num2str(element);
elseif iscell(element)
    %Make recursive call
    str = ['{' strjoin(cellfun(@convertElementToString, element, 'UniformOutput', false), ', ') '}'];
else
    str = char(element);
end

