function clear_all_except(varargin)
%CLEAR_ALL_EXCEPT Clear all local variables except those specified
%
%   Usage:
%       clear_all_except(VAR1,VAR2,VAR3,...)
%
%   Input:
%   VARN: Multiple string inputs of variable names or single cell of
%   variable names as strings
%
%   Example:
%       a=3;b=4;c=4;d=234;e={1234.1234,234,234,546546};
%       clear_all_except({'a','b'})
%
%  Copyright 2018 Michael J. Prerau, Ph.D., Last modified 5/7/2018
%% ********************************************************************

if iscell(varargin) && length(varargin)==1
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
