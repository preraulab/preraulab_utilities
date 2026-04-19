function clear_all_except(varargin)
%CLEAR_ALL_EXCEPT  Clear all caller-workspace variables except those specified
%
%   Usage:
%       clear_all_except(VAR1, VAR2, VAR3, ...)
%       clear_all_except({VAR1, VAR2, VAR3, ...})
%
%   Inputs:
%       varargin : char list or cell of char - variable names to keep -- required
%
%   Outputs:
%       none (side effects only)
%
%   Example:
%       a=3; b=4; c=4; d=234; e={1234.1234,234,234,546546};
%       clear_all_except({'a','b'})
%
%   See also: clear, evalin, whos
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

if length(varargin)==1 && iscell(varargin{1})
    varargin=varargin{1};
end

if length(varargin)>1
    varstr=[sprintf('''%s'', ', varargin{1:end-1}) sprintf('''%s''',varargin{end})];
else
    varstr=sprintf('''%s''', varargin{1}) ;
end

evalin('caller','vars=whos;')
evalin('caller', ['clear_vars=setdiff({vars.name},{' varstr '});']);
evalin('caller', 'clear(clear_vars{:},''vars'',''clear_vars'');');
