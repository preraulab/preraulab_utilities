%Simple flocking algorithm

function flock
ccc
N=100;
xbounds=800;
ybounds=500;
maxvel=5;
rand_move=1;

pos=[rand(N,1)*xbounds rand(N,1)*ybounds];

vel=randn(N,2)*maxvel.*((ceil(rand(N,2)*2)-1)*2-1);

f=figure('units','normalized','position',[0 0 1 1]);
ax=figdesign(1,1);
set(ax,'xlim',[0 xbounds],'ylim',[0 ybounds],'nextplot','replacechildren','xtick',[],'ytick',[]);
% axis equal;

set (f, 'CloseRequestFcn',@closemsg, 'WindowButtonMotionFcn', @mouseMove, 'WindowButtonDownFcn', @mousedown,'WindowButtonUpFcn', @mouseup,'KeyPressFcn',@handlekeys);
fdat=guidata(f);
fdat.scatter=false;
fdat.go=true;
guidata(f,fdat);


p = plot(pos(:,1), pos(:,2),'.','markersize',10);

go=true;
while go
    vel=vel+move_towards_center(pos,N)+move_if_close(pos,N)+match_vel(vel,N)+...
        move_away_mouse(pos,N)+randn(size(pos))*rand_move;
    pos=pos+vel;
    
    [pos, vel]=fixpos(pos,vel,xbounds,ybounds);
    vel=fixvel(vel,maxvel);
    
    p.XData = pos(:,1);
    p.YData = pos(:,2);
    
    fdat=guidata(f);
    go=fdat.go;
    drawnow;
    %     pause(.01);
end

if ishandle(f)
    delete(f);
end

function [pos, vel]=fixpos(pos,vel,xbounds,ybounds)
pos(isnan(pos))=0;

pos(isnan(pos))=0;
pinds=pos<0;
pos(pinds)=0;
vel(pinds)=vel(pinds)*-1;

inds=pos(:,1)>xbounds;
pos(inds,1)=xbounds;
vel(inds,1)=vel(inds,1)*-1;

inds=pos(:,2)>ybounds;
pos(inds,2)=ybounds;
vel(inds,2)=vel(inds,2)*-1;


function vel=fixvel(vel,maxvel)
inds=abs(vel)>maxvel;
vel(inds)=maxvel*sign(vel(inds));

function newvel=move_towards_center(pos,N)
fdat=guidata(gcf);
cpos=mean(pos,1);
if ~fdat.scatter
    newvel=(repmat(cpos,N,1)-pos)/100;
else
    newvel=(repmat(cpos,N,1)-pos)/200;
end
% NN=20;
% for i=1:N
%     dist=sqrt(sum((repmat(pos(i,:),N,1)-pos).^2,2));
%     [~,inds]=sort(dist);
%     npos=mean(pos(inds(2:NN),:),1);
%     if any(inds)
%         newvel(i,:)=(npos-pos(i,:))/50;
%     else
%         newvel(i,:)=0;
%     end
%
% end

function newvel=match_vel(vel,N)
mvel=sum(vel);
ang=angle(mvel(1)+mvel(2)*1i);
newvel=repmat([.5*cos(ang) .5*sin(ang)],N,1);


function newvel=move_if_close(pos,N)
newvel=zeros(size(pos));
for i=1:N
    dist=sqrt(sum((repmat(pos(i,:),N,1)-pos).^2,2));
    inds=dist<10;
    if any(inds)
        newvel(i,:)=pos(i,:)-mean(pos(inds,:),1);
    end
end

function newvel=move_away_mouse(pos,N)
%Get mouse position
C = get (gca, 'CurrentPoint');
mpos=C(1,1:2);

fdat=guidata(gcf);
newvel=zeros(size(pos));

%Check if mouse is in the axes
if diff(sign(xlim-mpos(1)))~=0 && diff(sign(ylim-mpos(2)))~=0
    %Get distance to mouce
    dist=sqrt(sum((pos-repmat(mpos,N,1)).^2,2));
    
    %Avoid mouse if not in scatter mode
    if ~fdat.scatter
        inds=dist<50;
        
        newvel(inds,:)=pos(inds,:)-repmat(mpos,sum(inds),1);
        newvel=newvel-(pos-repmat(mpos,N,1))/800;
    else
        inds=dist<100;
        newvel(inds,:)=pos(inds,:)-repmat(mpos,sum(inds),1);
        
        inds2=dist<400;
        newvel(inds2,:)=newvel(inds2,:)+(pos(inds2,:)-repmat(mpos,sum(inds2),1))/400;
    end
end


function mouseMove (~, ~)
% get (gca, 'CurrentPoint');

function mousedown(~,~)
fdat=guidata(gcf);
fdat.scatter=true;
guidata(gcf,fdat);

function mouseup(~,~)
fdat=guidata(gcf);
fdat.scatter=false;
guidata(gcf,fdat);

function handlekeys(~,event)
if strcmpi(event.Character,'q')
    fdat=guidata(gcf);
    fdat.go=false;
    guidata(gcf,fdat);
end

function closemsg(~,~)
fdat=guidata(gcf);
fdat.go=false;
guidata(gcf,fdat);

