function RGBimage = mat2rgbpic(varargin)
%MAT2RGBPIC  Convert a scaled image matrix into an RGB image and optionally write it
%
%   Usage:
%       RGBimage = mat2rgbpic(data, file_name)
%       RGBimage = mat2rgbpic(data, file_name, clims)
%       RGBimage = mat2rgbpic(data, file_name, color_map)
%       RGBimage = mat2rgbpic(data, file_name, color_map, clims)
%
%   Inputs:
%       data      : MxN double - data to convert -- required
%       file_name : char - output file name ([] to skip writing) -- required
%       color_map : Kx3 double - colormap for mapping (default: current colormap)
%       clims     : 1x2 double - color limits (default: current CLim)
%
%   Outputs:
%       RGBimage : MxNx3 RGB image
%
%   Example:
%       colormap(jet(1024));
%       imagesc(peaks(1000), [-4 6]);
%       mat2rgbpic(peaks(1000), 'test.tiff');
%
%   See also: imwrite, colormap, ind2rgb
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

data=flipud(varargin{1});
file_name=varargin{2};

%Check for too few parameters
if nargin<2
    error('Function requires at least data and file_name parameters');
end

%Set default clims and axes
if nargin==2
    color_map=colormap;
    clims=get(gca,'clim');
end

%Check for variable third input argument
if nargin==3
    if length(varargin{3})==2
        clims=varargin{3};
        color_map=colormap;
    else
        color_map=varargin{3};
        clims=get(gca,'clim');
    end
end

if nargin==4
    color_map=varargin{3};
    clims=varargin{4};
end

%get colormap
color_map_size = size(color_map,1);

%Scale the data
data(data<clims(1))=clims(1);
data(data>clims(2))=clims(2);

% scale the matrix to the range of the color_map.
scaled_data = round(interp1(linspace(min(data(:)),max(data(:)),color_map_size),1:color_map_size,data));

%Create the RGB image
RGBimage = reshape(color_map(scaled_data,:),[size(scaled_data) 3]); % make rgb image from scaled.

if ~isempty(file_name)
    %Write the image
    imwrite(RGBimage,file_name);
end