function tbox = lm_plot(varargin)
%LM_PLOT  Plot linear regression results with an annotation textbox
%
%   Usage:
%       tbox = lm_plot(mdl)
%       tbox = lm_plot(ax, mdl)
%       tbox = lm_plot(..., 'Display', value, 'Location', value)
%
%   Inputs:
%       ax  : axes handle - target axes (default: gca)
%       mdl : LinearModel - model to plot -- required
%
%   Name-Value Pairs:
%       'Display'  : char - 'coeffs' or 'full' (default: 'full')
%       'Location' : char - 'northwest', 'northeast', 'southwest',
%                    'southeast', or 'center' (default: 'southwest')
%
%   Outputs:
%       tbox : handle to the annotation textbox
%
%   Example:
%       x = rand(1,1000)*10;
%       z = -3*x + 23 + randn(size(x))*2;
%       mdl = fitlm(table(z', x'), 'Var1 ~ Var2');
%       lm_plot(mdl, 'Location', 'southwest');
%
%   See also: fitlm, annotation, plotAdded
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

if nargin == 0
    close all;
    clc;
    x = rand(1,1000)*10;
    z = -3*x + 23 + randn(size(x))*2;
    tbl = table(z',x');
    mdl = fitlm(tbl,'Var1 ~ Var2');
    lm_plot(mdl,'Location', 'southwest');
    title('Regression Plot')
    xlabel('Var 1')
    ylabel('Var 2')
    return;
end

% Check if the first input is an axes object
if nargin > 0 && isa(varargin{1}, 'matlab.graphics.axis.Axes')
    ax = varargin{1};
    varargin = varargin(2:end); % Remove the axes object from varargin
else
    ax = gca;
end

% Check if remaining inputs are valid
p = inputParser;
validOptions = {'coeffs', 'full'};
defaultOption = 'full';
validLocations = {'northwest', 'northeast', 'southwest', 'southeast', 'center'};
defaultLocation = 'southwest';

addRequired(p, 'mdl', @(x) isa(x, 'LinearModel'));
addOptional(p, 'Display', defaultOption, @(x) any(validatestring(x, validOptions)));
addOptional(p, 'Location', defaultLocation, @(x) any(validatestring(x, validLocations))); 
parse(p, varargin{:});
mdl = p.Results.mdl;
displayOption = p.Results.Display;
LocationOption = p.Results.Location; % Retrieve the value of the 'Location' parameter

% Determine the appropriate input for formattedDisplayText based on displayOption
if strcmp(displayOption, 'coeffs')
    str = formattedDisplayText(mdl.Coefficients, 'SuppressMarkup', true, 'LineSpacing', 'compact');
else
    str = formattedDisplayText(mdl, 'SuppressMarkup', true, 'LineSpacing', 'compact');
end

% Create a textbox for the display
tbox = annotation('textbox', 'string',str,'interpreter','none','VerticalAlignment','bottom','HorizontalAlignment','left');

update_loc([],[],ax,tbox,LocationOption)


%Keep the box in the correct location upon resize
set(gcf,'SizeChangedFcn',@(obj, event) update_loc(obj, event, ax, tbox, LocationOption));
addlistener(ax, 'Position', 'PostSet',@(obj, event) update_loc(obj, event, ax, tbox, LocationOption));

%Plot the model
pause(.0001) %Some strange updating happens that requires a pause to get textbox properties
plotAdded(ax, mdl);


function update_loc(~, ~, ax, tbox, LocationOption)
%Some strange updating happens that requires a pause to get the correct
%dimensions
pause(.0001);

% Set the Location of the annotation text box based on the 'Location' parameter
switch LocationOption
    case 'southwest'
        tbox.Position(1:2) = ax.Position(1:2);
    case 'southeast'
        tbox.Position(1) = ax.Position(1) + ax.Position(3) - tbox.Position(3);
        tbox.Position(2) = ax.Position(2);
    case 'northwest'
        tbox.Position(1) = ax.Position(1);
        tbox.Position(2) = ax.Position(2) + ax.Position(4) - tbox.Position(4);
    case 'northeast'
        tbox.Position(1) = ax.Position(1) + ax.Position(3) - tbox.Position(3);
        tbox.Position(2) = ax.Position(2) + ax.Position(4) - tbox.Position(4);
end

