%% IPCC AR6 Chapter 9 Figure 9.31 (Amplification Factor and Flooding)
%
% Code used to plot timeseries of floods and regional sea level.
%
% Written by Billy Sweet

load Data/Fig_a_final

addpath ./Functions

orig = 180;
clr = [.8 .8 .8];
gclr = [.74 .74 .74];
wclr = [1 1 1];
frame = 'off';

scrsz = get(0,'ScreenSize');
figure('position',[scrsz(3)/(scrsz(3)*.04) scrsz(3)/(scrsz(3)*.03) scrsz(3)*.95 scrsz(4)*.85]);
ax = axesm('miller','grid','off','gcolor',gclr,'meridianlabel','on','parallellabel','on',...
    'mlabelparallel','north','labelformat','compass','maplatlimit',[-60 75],...
    'maplonlimit',[30 390],'frame',frame,'ffacecolor',clr,'origin',orig);
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax,land, 'FaceColor', clr,'edgecolor', clr-clr*.4)
%i=find(~isnan(freq5));
scatterm(lat,long,20,perc_change_negfactor10  ,'filled')% ratio2
% scatterm(lat(i), lon(i),60,'k')
colormap(flip(brewermap(10,'RdYlBu')))
set(gca,'clim',[-500 500])
c=colorbar('southoutside', 'ticks',[-500 -400 -300 -200 -100 0 100 200 300 400 500], 'ticklabels', {'>50','40','30','20','10', '0', '100', '200', '300', '400', '>500'})
c.Label.String = '<---Percent Decrease | Percent Increase--->'
axis tight
title ('Change in Current Average Annual Minor Tidal Flood Frequency relative to 1960-1980 Average')

hgsave('../PNGs/AmplificationFactorMap');
