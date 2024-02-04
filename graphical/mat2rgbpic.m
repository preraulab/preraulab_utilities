%MAT2RGBPIC Converts a scaled image matrix into an RGB image file
%
%   Usage:
%       RGBimage=mat2rgbpic(data, file_name)
%       RGBimage=mat2rgbpic(data, file_name, clims)
%       RGBimage=mat2rgbpic(data, file_name, color_map)
%       RGBimage=mat2rgbpic(data, file_name, color_map, clims)
%
%   Input:
%       data: MxN matrix of data
%       file_name: string for output file name (if [], will not write)
%       colormap: input colormap for the data (default: current map)
%       clims: color limits (default: current limits)
%
%   Output:
%       RGBimage: MxNx3 RGB image
%
%   Example:
%         %Set the color map
%         colormap(jet(1024));
%
%         %Create a scaled image
%         subplot(211)
%         imagesc(peaks(1000), [-4 6]);
%
%         %Write the file
%         mat2rgbpic(peaks(1000),'test.tiff');
%
%         %Read the file
%         RGBimage=imread('test.tiff');
%
%         %Plot the results
%         subplot(212)
%         image(RGBimage)
%
%  Copyright 2024 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

function RGBimage=mat2rgbpic(varargin)
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