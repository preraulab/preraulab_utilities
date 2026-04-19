function code_str = struct2codestr(mystruct, struct_name)
%STRUCT2CODESTR  Generate a MATLAB code string that reconstructs a structure
%
%   Usage:
%       code_str = struct2codestr(mystruct, struct_name)
%
%   Inputs:
%       mystruct    : struct - input structure -- required
%       struct_name : char - variable name to use in the generated code -- required
%
%   Outputs:
%       code_str : char - MATLAB code assigning each field of mystruct
%
%   Example:
%       mystruct.field1 = 10;
%       mystruct.field2 = 'hello';
%       code_str = struct2codestr(mystruct, 'mystruct');
%
%   See also: struct2nvp, struct2nvpstr, value2str
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

code_str = [];
fnames = fieldnames(mystruct);
struct_vals = struct2cell(mystruct);

for ii = 1:length(fnames)
    code_str = [code_str struct_name '.' fnames{ii} ' = ' value2str(struct_vals{ii}) ';' newline];
end