function linkcaxes(ax)
if nargin == 0
    error('Must provide axis handles');
end

linkprop(ax, 'CLim')

% %Add listeners to all axes
% for ii=1:length(ax)
%     addlistener(ax(ii),'CLim','PostSet',@(e,h)update_caxis(e,h,ax));
% end
% end
% 
% %Update the clims
% function update_caxis(~, event, ax)
% %Get the clim of the selected axis
% new_clim = event.AffectedObject.CLim;
% 
% %Update just the axes with different clims
% all_clims = cat(1, ax.CLim);
% inds = ~all(all_clims == repmat(new_clim,length(ax),1),2);
% 
% %Update all other axes
% if any(inds)
%     set(ax(inds),'CLim',new_clim);
% end
% end