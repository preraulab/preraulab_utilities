% DRAWARROW - DRAWS ARROWS WITH MAGNITUDE AND ANGLE
% 
% h = drawarrow(x, y, m, theta, autoscale, varargin)
% x: xvals
% y: yvals
% m: magnitudes
% theta: angles
% autoscale: auto scale the values (default: 'off');
% varargin: parameters for the quiver function
% 

function h = drawarrow(x, y, m, theta, autoscale, varargin)
if nargin < 5 || isempty(autoscale)
    autoscale = 'off';
end

X = [x(:), x(:)+m(:).*cos(theta(:))];  
Y = [y(:), y(:)+m(:).*sin(theta(:))];
h = quiver(X(:,1),Y(:, 1),X(:,2)-X(:,1),Y(:,2)-Y(:,1),'autoscale',autoscale, varargin{:});
end

