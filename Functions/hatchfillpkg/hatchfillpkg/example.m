%%% In this example, the 2 contour of a contour plot
%%% is filled with hatching.

load example_data.mat
% plot background data
[c,h] = contourf(lat,p,temp,[150:10:320]);
caxis([190 270]);
set(h,'linestyle','none');
hold on;
% plot hatching region:
[c2,h2] = contourf(lat2,p2,zone,[2 2]); % plots only the 2 contour
set(h2,'linestyle','none');
hp = findobj(h2,'type','patch'); % findobj is highly customizable
hold off;                                 % if you want to have more control

%%% Comment/uncomment these blocks for different effects:
%%% Example 1:
%%% Default hatching
hatchfill(hp);

%%% Example 2:
%%% Set logarithmic yscale and reverse yaxis.
%%% For predictable results, it is important to set
%%% xscale/yscale/xdir/ydir/xlim/ylim BEFORE calling hatchfill.
% ylim([50 700])
% set(gca,'yscale','log','ydir','reverse');
% hatchfill(hp);

%%% Example 3:
%%% Cross-hatching with gray fill and thick blue lines
% hh = hatchfill(hp,'cross',45,5,[0.8 0.8 0.8]);
% set(hh,'color','b','linewidth',2);

%%% Example 4:
%%% Speckling
% hatchfill(hp,'speckle');
