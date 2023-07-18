function tbox = lm_plot(varargin)

% lm_plot - Plot linear regression results with an annotation textbox.
%
%   tbox_h = lm_plot(mdl) plots the linear regression results represented by
%   the LinearModel object 'mdl'. The function generates a scatter plot of
%   the data points and overlays the fitted regression line. It also
%   displays model information in an annotation textbox. Returns the handle
%   to the annotation textbox, tbox_h.
%
%   tbox_h = lm_plot(ax, mdl) plots the linear regression results on the
%   specified axes object 'ax'. Returns the handle to the annotation
%   textbox, tbox_h.
%
%   tbox_h = lm_plot(..., 'display', displayOption) specifies the display
%   option for the model information. displayOption can be 'coeffs' to show
%   only the model coefficients or 'full' to show detailed model
%   information. The default value is 'full'.
%
%   tbox_h = lm_plot(..., 'Location', LocationOption) specifies the Location
%   of the annotation textbox. LocationOption can be 'northwest', 'northeast',
%   'southwest', 'southeast', or 'center'. The default value is 'southwest'.
%
% Example:
%     x = rand(1,1000)*10;
%     z = -3*x + 23 + randn(size(x))*2;
%     tbl = table(z',x');
%     mdl = fitlm(tbl,'Var1 ~ Var2');
%     lm_plot(mdl,'Location', 'southwest');
%     title('Regression Plot')
%     xlabel('Var 1')
%     ylabel('Var 2')
% 
% See also:
%   fitlm, annotation
%
% Copyright 2023 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

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

