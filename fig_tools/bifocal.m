%BIFOCAL - Creates bifocal view of a set of axes
% When run on a figure axis, splits the plot into two panels, where top
% panel is full scale and the bottom panel is zoomed in x-wise at a zoom
% level determined by the defaultZoom argument or function parameter.
%
% Usage:
%    bifocal
%    bifocal(ax)
%    bifocal(ax, 2)
%
% Inputs:
%    ax - axis handle to be split into bifocal view
%    defaultZoom - initial unit time length of zoom window
%
% Outputs:
%    none
%
% Example: 
%    % generate a figure with a spectrogram and store axis handle ax
%    bifocal(ax, 2)
%
% Remarks:
% Change the defaultZoom to a value other than 2 if you don't want to zoom
% to 2 (minutes) at the outset (i.e. if you're working in seconds).
%
% Copyright Aug-2014, David Zhou, dwzhou@partners.org
% Last revision Sept-2-2014
%********************************************************************
function [pslider, zslider] = bifocal(ax,defaultZoom)

if nargin < 2
    defaultZoom = 2;
end
if nargin < 1
    ax = gca;
end

% store handle and position of current axes
curpos = get(ax,'position');

% calculate location of the top panel based on current dimensions
halfpos = [curpos(1) (curpos(2)+curpos(4)/2) curpos(3) (curpos(4)/2)];

% change position of current axes to upper half of figure
set(ax,'position',halfpos,'units','normalized');

% make a new copy of figure in lower half of figure
new = copyobj(ax,gcf);
newpos = [curpos(1) curpos(2) curpos(3) (curpos(4)*(0.40))];
set(new,'position',newpos,'units','normalized');

% create sliders and set their dimensions
[pslider, zslider] = scrollzoompan_modified(new);
psliderpos = get(pslider,'position');
zsliderpos = get(zslider,'position');
sliderheight = ((halfpos(2)-0.005) - (newpos(2)+newpos(4)+0.005))/2;
set(pslider,'position',[newpos(1)-0.01 newpos(2)+newpos(4)+sliderheight+0.005 newpos(3)+0.02 sliderheight],'units','normalized');
set(zslider,'position',[newpos(1)-0.01 newpos(2)+newpos(4)+0.005 newpos(3)+0.02 sliderheight],'units','normalized');

% set initial zoom and pan
set(zslider,'Value',defaultZoom);
set(pslider,'Value',0);

% create rectangle denoting area of focus
rect = rectangle('parent',ax,...
                 'position',[min(get(new,'xlim')) min(get(ax,'ylim')) diff(get(new,'xlim')) diff(get(ax,'ylim'))],...
                 'edgecolor',[0 0 0],...
                 'linewidth',5);
r1 = addlistener(new,'XLim','PostSet',@(src,evnt)rmove(rect,ax,new));

%% Moves rectangle
function rmove(rect,current,new)
    set(rect,'position',[min(get(new,'xlim')) min(get(current,'ylim')) diff(get(new,'xlim')) diff(get(current,'ylim'))]);
end

%% Creates zoom and pan sliders
function [pslider, zslider] = scrollzoompan_modified(ax)
    
    xl = xlim(ax);
    pmin = xl(1);
    pmax = xl(2);
    zmin = xl(1);
    zmax = xl(2);
    zinit = defaultZoom;
    
    if zmax < 1
        xvec = get(get(ax,'Children'),'Xdata');
        sliderStep = [1 5]/length(xvec);
    else
        sliderStep = [1 5]/(xl(2)-xl(1));
    end

    % create zoom and pan sliders
    zslider = uicontrol('style','slider', ...
                        'units','normalized', ...
                        'slider',sliderStep, ... % small is one step, big is arbitrary
                        'position',[.05 .025 .9 .025],...
                        'min',zmin,'max',zmax/2,'value',zinit);
    pslider = uicontrol('style','slider', ...
                        'units','normalized', ...
                        'slider',sliderStep, ...
                        'position',[.05 .025 .9 .025],...
                        'min',pmin,'max',pmax,'value',pmin, ...
                        'sliderstep',(pmax-pmin)/pmax*[.5 1]);

    % add two listeners to each slider
    z1=addlistener(zslider,'Value','PostSet',@(src,evnt)xzoom(ax, zslider, pslider, zmax, zmin));
    p1=addlistener(pslider,'Value','PostSet',@(src,evnt)xpan(ax, pslider, pmax, pmin));

    % some computations to make sure panslider begins at start of plot
    xlims_init = pmin+(zinit)/2*[-1 1]; % set initial xlim to be at the start
    if get(pslider,'value') - abs(diff(xlim(ax)))/2 < zmin
        new_pos=zmin+abs(diff(xlim(ax)))/2; % set position of pslider to be ...
        set(pslider,'value', new_pos); % half xlim distance away from the left
        xlims_new(1)=zmin; % remember this
        xlims_new(2)=zmax+abs(diff(xlim(ax)));
    end
    set(ax,'xlim',xlims_init);
    % set pslider step size and value to correspond with start
    if zmax < 1
        set(pslider,'sliderstep',diff(xlims_init)/length(xvec)*[.5 1]);
    else
        set(pslider,'sliderstep',diff(xlims_init)/zmax*[.5 1]);
    end
    set(pslider,'value',pmin);
    if get(pslider,'value')-abs(diff(xlim(ax)))/2<pmin
        set(pslider,'value',pmin+abs(diff(xlim(ax)))/2);
    end
    set(ax, 'xlim', get(pslider,'value')+[-1 1]*abs(diff(xlim(ax)))/2);
    
end

%% Callback to handle time scale zoom
function xzoom(ax, zslider, pslider, amax, amin)
    %Keep the window center with window width determined by slider value
    xlims_new=get(pslider,'value')+get(zslider,'value')/2*[-1 1];

    %Sets a minimum window width
    if xlims_new(2)<=xlims_new(1)
        xlims_new(2)=xlims_new(1)+1e-10;
    end

    %Set sliderbounds so that you can't go past limits
    if get(pslider,'value')-abs(diff(xlim(ax)))/2 < amin % if scope of view extends below "amin"
        new_pos=amin+abs(diff(xlim(ax)))/2; % set position of pslider to be ...
        set(pslider,'value', new_pos); % half xlim distance away from the left
        xlims_new(1)=amin; % remember this
        xlims_new(2)=amin+abs(diff(xlim(ax)));
    elseif get(pslider,'value')+abs(diff(xlim(ax)))/2 > amax % if scope of view extends above "amax"
        new_pos=amax-abs(diff(xlim(ax)))/2; % set position of slider to be ...
        set(pslider,'value', new_pos); % half xlim distance away from the right
        xlims_new(1)=amax-abs(diff(xlim(ax)));
        xlims_new(2)=amax; % remember this
    end
    
    %Compute the new limits
    set(ax,'xlim',xlims_new);
    set(pslider,'sliderstep',diff(xlims_new)/amax*[.5 1]);

end

%% Callback to handle time scale scroll
function xpan(ax, pslider, amax, amin)
    %Set the limits to the slider value center

    %Set sliderbounds so that you can't go past limits
    if get(pslider,'value')-abs(diff(xlim(ax)))/2<amin
        set(pslider,'value',amin+abs(diff(xlim(ax)))/2);
    elseif get(pslider,'value')+abs(diff(xlim(ax)))/2>amax
        set(pslider,'value',amax-abs(diff(xlim(ax)))/2);
    end

    set(ax, 'xlim', get(pslider,'value')+[-1 1]*abs(diff(xlim(ax)))/2);

end

end