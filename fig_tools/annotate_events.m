% ANNOTATE_EVENTS  creates event markers in plots of a time course
%
% Usage:
%    annotate_events(events, times)
%    annotate_events(events, times, heightfactor)
%
% Input:
%    events - cell array of strings, where each string labels an event
%    times - double or cell array of times for each event, in time unit
%            matching xaxis of plot, must be same length as events. if cell
%            array, then it is assumed that times are in real time after
%            start time of surgery, ex. '11:27' where surgery started at
%            11:20
%    heightfactor - factor by which to decrease height of panel in order to
%                   fit event labels, i.e. 0.8 makes it 20% shorter
%
% Output:
%    none
%
% Example:
%    % generate EEG spectrogram of a surgery case
%    annotate_events({'induction start', 'patient fidgets'},[15 16])
%    annotate_events({'start','stop'},{'3:00','3:05'},0.8)
%
% Remarks:
%    Note that the time unit may be in seconds, minutes, or datenum format.
%    Plots generated with mtspecgram and plots after running clocktime will
%    have datenum format. Plots generated with mtspecgramc or other 
%    plotting functions will be in seconds. Also confirm that times entered
%    into the argument do not start in clocktime if the data starts in zero
%    time. Data beginning at the real start time of a case may be annotated
%    with real clocktime.
%
% Copyright Aug-2014, David Zhou, dwzhou@partners.org
% Last revision Sept-2-2014
%********************************************************************
function annotate_events(events,times,heightfactor)

% factor by which to decrease height of panel
if nargin < 3
    heightfactor = 4/5;
end

% process times into datenum if in clocktime
if iscell(times)
    times_raw = times;
    times = zeros(1,length(times_raw));
    for i = 1:length(times_raw)
        time = datevec(times_raw{i});
        times(i) = datenum([0 0 0 time(4:6)]);
    end
end

% make current axes shorter to fit event labels on top
curpos = get(gca,'Position');
set(gca,'Position',[curpos(1:3) curpos(4)*heightfactor]);
ylims = get(gca,'YLim');

for i = 1:length(events)
    
    % make each line
    line([times(i); times(i)],[min(ylims); max(ylims)],...
         'Color',[0.5 0.5 0.5],...
         'Linewidth',4);
    
    % write event on top of plot
    text(times(i), max(ylims), events{i},...
         'fontsize',11,...
         'fontweight','demi',...
         'verticalalignment','bottom',...
         'color','k',...
         'horizontalalignment','left',...
         'rotation',45);
    
end