function out = value2str(value, simplify)
%VALUE2STR  Convert MATLAB values or tables to evaluable string representations
%
%   Usage:
%       s = value2str(x)
%       s = value2str(x, simplify)
%
%   Inputs:
%       x        : any - scalar, vector, matrix, cell, string, logical, or table -- required
%       simplify : logical - simplify scalar numeric values to fractions, pi multiples,
%                            or exp notation (default: true)
%
%   Outputs:
%       s : char or table - string representation of x, or table of strings if x is a table
%
%   Notes:
%       - Converts scalars, arrays, strings, logicals, cells, and tables into strings
%         that can be evaluated using `eval` in MATLAB.
%       - Handles numeric vectors or matrices inside table cells as single strings.
%       - Fully parallelizable for table inputs using parfor.
%       - Optional simplification converts scalar numbers to fractions, multiples of pi,
%         or exp(x) when the decimal representation exceeds 4 characters.
%       - Preserves exp() and pi forms over aggressive fraction conversion.
%
%   Example:
%       value2str(0.5)              % '1/2'
%       value2str(pi/6)             % '(1*pi)/6'
%       value2str([1 2; 3 4])       % '[1 2;3 4]'
%       value2str({'a', [1 2 3], true})   % '{''a'', [1 2 3], true}'
%       value2str(1/3, false)       % '0.333333333333333'
%
%   See also: double2fracstr, double2pifracstr, double2estr, table2csv, csv2table
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main
if nargin < 2
    simplify = true;
end

%% ---------------- Table Input ----------------
if istable(value)
    varNames = value.Properties.VariableNames;
    Nvars = width(value);

    cols = cell(1, Nvars);
    for v = 1:Nvars
        cols{v} = value.(varNames{v});
    end

    % Preallocate output
    outCols = cell(1, Nvars);

    parfor v = 1:Nvars
        col = cols{v};  % Sliced variable

        % Ensure cell array 
        if ~iscell(col)
            col = num2cell(col, 2); 
        end

        % Encode each row
        colStr = cellfun(@(x) encodeValue(x, simplify), col, ...
                         'UniformOutput', false);
        outCols{v} = colStr;
    end

    % Rebuild table
    out = table();
    for v = 1:Nvars
        out.(varNames{v}) = outCols{v};
    end
    return
end

%% ---------------- Single Value ----------------
out = encodeValue(value, simplify);

end

%% =================================================================
%% ===================== CORE VALUE HANDLER ========================
%% =================================================================
function s = encodeValue(v, simplify)

% Empty
if isempty(v)
    switch class(v)
        case {'double','single','logical'}
            s = '[]';
        case 'cell'
            s = '{}';
        case 'char'
            s = '''''';
        otherwise
            s = [class(v) '([])'];
    end
    return
end

% Numeric
if isnumeric(v)
    if isscalar(v)
        if simplify && length(sprintf('%.15g', v)) > 4
            % Try for simple fractions
            s = double2fracstr(v);

            % Try for pi multiples
            if isempty(s)
                s = double2pifracstr(v);
            end

            % Try for exp form
            if isempty(s)
                s = double2estr(v);
            end

            % Return numeric string if nothing matched
            if isempty(s)
                s = sprintf('%.15g', v);  % round-trip safe, removes unnecessary zeros
            end
        else
            s = sprintf('%.15g', v);      % full double precision, trailing zeros removed
        end
    else
        % Non-scalar numeric array
        s = mat2str(v);  % preserves shape, full precision by default
    end
    return
end

% Logical
if islogical(v)
    if isscalar(v)
        if v
            s = 'true';
        else
            s = 'false';
        end
    else
        s = mat2str(v);
    end
    return
end

% Char
if ischar(v)
    s = ['''' v ''''];
    return
end

% String
if isstring(v)
    if isStringScalar(v)
        s = ['"' char(v) '"'];
    else
        quoted = "\"" + v + "\"";
        s = "[" + strjoin(quoted, " ") + "]";
    end
    return
end

% Cell
if iscell(v)
    elems = cellfun(@(x) encodeValue(x, simplify), v, 'UniformOutput', false);
    s = ['{' strjoin(elems, ', ') '}'];
    return
end

% Fallback
s = class(v);
end