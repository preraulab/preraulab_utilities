function [axis_handle, shadow_handle]=shadow_axis(varargin)
%Parse all the inputs
p=inputParser;
%Axis position
p.addOptional('position', [0.1300 0.1100 0.7750 0.8150]);
%Shadow size
p.addOptional('size', 10);
%Shadow distance
p.addOptional('distance', .03);
%Shadow angle (in degrees)
p.addOptional('angle', -45);
%Shadow opacity
p.addOptional('opacity', .5);
%Shadow resolution
p.addOptional('resolution', 500);

%Parse the arguments
p.parse(varargin{:});
args=p.Results;

%Set the variables from the input
position=args.position;
size=args.size;
distance=args.distance;
angle=args.angle;
opacity=args.opacity;
resolution=args.resolution;

%Get the figure background color
bgcolor=get(gcf,'color');

%Make the shadow axes
shadow_handle=axes('position',position+[cos(angle/180*pi)*distance sin(angle/180*pi)*distance 0 0]);

%Create shadow
%Make image the color of the background
shadow=cat(3,ones(resolution)*bgcolor(1),ones(resolution)*bgcolor(3),ones(resolution)*bgcolor(3));

%Make shadow and set darkness based on opacity parameter
for i=1:3
    shadow(size:end-size,size:end-size,i)=(1-opacity)*bgcolor(i);
end

%Blur to make the shadow
F = fspecial('disk',size);
shadow = imfilter(shadow,F,'replicate');

%Display the shadow
image(shadow);
set(gca, 'xtick',[],'ytick',[],'xcolor',bgcolor,'ycolor',bgcolor);

%Create actual axis for plotting
axis_handle=axes('units','normalized','position',position);