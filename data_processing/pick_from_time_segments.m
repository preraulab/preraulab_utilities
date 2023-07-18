function picked_idx = pick_from_time_segments(time_segments, times)
% PICK_FROM_TIME_SEGMENTS Subselect data from multiple discontiunous ranges
%
%   Usage:
%       picked_idx = pick_from_time_segments(time_segments, times)
%
%   Input:
%       time_segments: Kx2 matrix of (start time, end time) time segments
%       times: 1 x N vector - data times
%
%   Output:
%       picked_idx: 1xN logical for data selection
%
%   Example:
%         %Load example data
%         load('/data/preraugp/archive/Lunesta Study/sleep_stages/Lun01-Night1.mat');
% 
%         %Make reduced hypnogram
%         t_inds=unique([1; find(diff(stage_struct.stage)~=0)+1; length(stage_struct.stage)]);
% 
%         hyp_times=stage_struct.time(t_inds);
%         hyp_stages=stage_struct.stage(t_inds);
% 
%         %Set overall time bounds to use
%         time_bounds=[500 25000];
%         %Set specific times to exclude
%         excluded_times=[1000 5000; 10000 11000];
%         %Pick all stages but REM
%         selected_stages=[1:3 5];
% 
%         %Find the time segments
%         time_segments = sleep_time_select(time_bounds, hyp_times, hyp_stages, selected_stages, excluded_times);
%
%         %Simulate data 25% larger than the hypnogram
%         data_range=max(hyp_times)-min(hyp_times);
%         times=rand(1,1000)*data_range*1.25+min(time_segments(:)) - data_range*.125;
%         data=randn(size(times));
% 
%         %Get the index and select the data
%         picked_idx = pick_from_time_segments(time_segments, times);
%         picked_data=data(picked_idx);
% 
%         %Plot
%         figure
%         ax=figdesign(3,1,'type','usletter','orient','landscape');
%         linkaxes(ax,'x')
%         axes(ax(1))
%         hypnoplot(hyp_times, hyp_stages);
%         vline(time_segments(:,1)',1,'m');
%         vline(time_segments(:,2)',1,'g');
%         title('Hypnogram and Selected Times');
% 
%         axes(ax(2))
%         plot(times, data,'.')
%         vline(time_segments(:,1)',1,'m');
%         vline(time_segments(:,2)',1,'g');
%         axis tight;
%         title('Samples');
% 
%         axes(ax(3))
%         plot(times(picked_idx), picked_data,'.');
%         vline(time_segments(:,1)',1,'m');
%         vline(time_segments(:,2)',1,'g');
%         title('Selected Samples');
% 
% Copyright 2023 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
%**************************************************************************

%Use time segments to interpolate logicals on the data
x=reshape(time_segments',1,numel(time_segments));
y=zeros(size(x));
y(1:2:end)=1;

yi=interp1(x,y,times,'previous');
yi(isnan(yi))=0;

picked_idx=logical(yi);

