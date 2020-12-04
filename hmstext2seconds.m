function [seconds, hh, mm, ss]=hmstext2seconds(hmstext)

%Hours
hh=zeros(1,length(hmstext));
%Minutes
ss=hh;
%Seconds
mm=hh;

%Total seconds
totalsecs=hh;

%Loop through each cell of text
for i=1:length(hmstext)
    %Extract the hours minutes and seconds
    ctime=deblank(hmstext{i});
    
    tfields=strfind(ctime,':');
    
    
    h=str2double(deblank(ctime(1:tfields(1)-1)));
    hh(i)=h(~isnan(h));
    m=str2double(deblank(ctime(tfields(1)+1:tfields(2)-1)));
    mm(i)=m(~isnan(m));
    s=str2double(deblank(ctime(tfields(2)+1:end)));
    ss(i)=s(~isnan(m));
end

%Compute the total time of the hour of the day
totalsecs=ss+mm*60+hh*3600;

%Convert to seconds with proper adjustment for overlappingd days
seconds=[0 cumsum(mod(diff(totalsecs),3600*24))];