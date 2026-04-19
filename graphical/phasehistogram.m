function [theta_mean, rho_mean, h_phist, h_pax, h_ml] = phasehistogram(phases, amps, varargin)
%PHASEHISTOGRAM  Draw a polar histogram with mean-vector arrow for phase data
%
%   Usage:
%       [theta_mean, rho_mean, h_phist, h_pax, h_ml] = phasehistogram(phases, amps, ...)
%
%   Inputs:
%       phases : 1xN double - phase values in radians -- required
%       amps   : 1xN double - amplitudes per phase (default: ones(size(phases)))
%
%   Name-Value Pairs:
%       Any name-value pair accepted by polarhistogram is forwarded.
%       Normalization defaults to 'pdf' if not specified.
%
%   Outputs:
%       theta_mean : double - mean angle of the resultant vector
%       rho_mean   : double - mean magnitude of the resultant vector
%       h_phist    : handle to the polarhistogram
%       h_pax      : handle to the polar axes
%       h_ml       : handle to the mean-vector line
%
%   Example:
%       phases = mod(randn(1,1000) + pi/2, 2*pi);
%       figure;
%       phasehistogram(phases, 1, 'NumBins', 25, 'FaceColor', 'blue', 'FaceAlpha', .3);
%
%   See also: polarhistogram, polarplot
%
%   ∿∿∿  Prerau Laboratory MATLAB Codebase · sleepEEG.org  ∿∿∿
%        Source: https://github.com/preraulab/labcode_main

if nargin==0
    error('Must input phases');
end

if nargin<2 || isempty(amps)
    amps = ones(size(phases));
end

%Compute the mean population vector
vect_mean = mean(amps.*exp(1i*phases));

%Get the mean magnitude and angle
rho_mean = abs(vect_mean);
theta_mean = angle(vect_mean);

%Set default to normalization
varargin = [{'Normalization'}, {'pdf'}, varargin(:)'];

%Plot histogram
h_phist = polarhistogram(phases,varargin{:});
h_pax = gca;
h_pax.ThetaAxisUnits = 'radians';
h_pax.ThetaTick = 0:pi/4:2*pi;
h_pax.ThetaTickLabel = {'0','\pi/4','\pi/2','3\pi/4' '\pm\pi','-3\pi/4', '-\pi/2','-\pi/4'};
h_pax.FontSize = 14;

%Add mean arrow
hold on
h_ml = polarplot([theta_mean theta_mean],[0 rho_mean],'linestyle','-','color','r','linewidth',2);

