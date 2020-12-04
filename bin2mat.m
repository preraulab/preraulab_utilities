% [data, Fs, numChans]=bin2mat(filenames)
function [data, Fs, numChans]=bin2mat(filenames)

if nargin==0
    [filenames, pathname] = uigetfile( ...
        {'*.bin','Bin files'},'Select EDF files', 'MultiSelect', 'on');
end

%Handle the case of only one file
if ~iscell(filenames)
    filenames={filenames};
end

%Read all the files
for i=1:length(filenames)
    filename=filenames{i};
    
    if nargin==0
        pathname=fileparts(filename);
    end
    
    if filename ~= 0
        f=fopen(fullfile(pathname, filename), 'r');
        
        %Get sampling freq
        fulldata=fread(f, 'double');
        Fs=fulldata(1);
        
        %Get number of channels
        numChans = fulldata(2);
        
        %Get data
        data=reshape(fulldata(3:end), numChans, (length(fulldata)-2)/numChans);
        fclose(f);
        clear('f');
        clear('fulldata');
        
%         [~,name] = fileparts(filename);
%         save(fullfile(pathname, name), 'data','Fs','numChans', '-v7.3')
    end
end