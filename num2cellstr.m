function out = num2cellstr(s)
%NUM2CELLSTR Turns numeric array into a cell array of strings
%
%   out = num2cellstr(s)

out = reshape(strtrim(cellstr(num2str(s(:)))'), size(s));

end

