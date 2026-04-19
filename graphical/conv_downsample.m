function img_downsampled = conv_downsample(img, scale_factor, method, plot_on)
%CONV_DOWNSAMPLE  Downsample an image via convolution and decimation
%
%   Usage:
%       img_downsampled = conv_downsample(img, scale_factor, method, plot_on)
%
%   Inputs:
%       img          : MxN double - image data -- required
%       scale_factor : 1x2 double - integer downsample ratio per dimension -- required
%       method       : char or double - filter type: 'mean', 'median', 'max',
%                      'min', or an order number (default: 'mean')
%       plot_on      : logical - plot original vs downsampled (default: false)
%
%   Outputs:
%       img_downsampled : downsampled image
%
%   Example:
%       img = peaks(200) + randn(200)/5;
%       img_downsampled = conv_downsample(img, [4 6], 'mean');
%
%   See also: conv2, ordfilt2, imresize
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

%Set example data
if nargin == 0
    img = peaks(100);
    scale_factor = [3,3];
end

if nargin<3
    method = 'mean';
end

if nargin<4
    plot_on = false;
end

%Check for integer inputs
if any(mod(scale_factor,1))
    scale_factor = round(scale_factor);
    warning(['Non-integer scale factor. Rounding to [' num2str(scale_factor) ']']);
end

switch lower(method)
    case 'mean'
        %Compute convolution and rescale
        img_downsampled = conv2(img, ones(scale_factor)./prod(scale_factor), 'same');
    case 'median'
        img_downsampled=ordfilt2(img,round(prod(scale_factor)/2),ones(scale_factor));
    case 'max'
        img_downsampled=ordfilt2(img,prod(scale_factor),ones(scale_factor));
    case 'min'
        img_downsampled=ordfilt2(img,1,ones(scale_factor));
    otherwise
        if isnumeric(method)
            if method <= 0 || method> prod(scale_factor)
                error(['Filter order number be between 1 and ' num2str(prod(scale_factor))]);
            else
                img_downsampled=ordfilt2(img,method,ones(scale_factor));
            end
        else
            error('Invalid method. Must be ''mean'', ''median'', ''max'', ''min'', or order number');
        end
end

img_downsampled = img_downsampled(1:scale_factor(1):end, 1:scale_factor(2):end);

%Plot data
if plot_on
    figure
    subplot(211)
    imagesc(img);
    cx = get(gca,'CLim');
    title(['Original: ' sprintf('%d x %d', size(img))])

    subplot(212)
    imagesc(img_downsampled);
    set(gca,'CLim',cx);
    title(['Downsampled: ' sprintf('%d x %d', size(img_downsampled))])
end

end
