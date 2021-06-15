clear all

load('SST_Maps.mat');

figure(1)
subplot(3,2,2)
temp = nanmean(SST_change_SSP585,3);
temp(temp==0)=NaN(1);
imagesc(flipud(temp'))
caxis([-0.4 0.8])
colormap('jet')
colorbar
title('SSP5-8.5 rate of change 2005-2100 (22 ScenarioMIP models)')

subplot(3,2,4)
temp = nanmean(SST_change_SSP585_2050,3);
temp(temp==0)=NaN(1);
imagesc(flipud(temp'))
caxis([-0.4 0.8])
colormap('jet')
colorbar
title('SSP5-8.5 rate of change 2005-2050 (22 ScenarioMIP models)')

subplot(3,2,6)
temp = nanmean(SST_change_HRSSP,3);
temp(temp==0)=NaN(1);
imagesc(flipud(temp'))
caxis([-0.4 0.8])
colormap('jet')
colorbar
title('HighResMIP All high-resoltion 2005-2050 (5 models)')

subplot(3,2,3)
temp = nanmean(SST_change_HRSSP_LR,3);
temp(temp==0)=NaN(1);
imagesc(flipud(temp'))
caxis([-0.4 0.8])
colormap('jet')
colorbar
title('HighResMIP Low-res partners 2005-2050 (3 models)')

subplot(3,2,5)
temp = nanmean(SST_change_HRSSP_HR,3);
temp(temp==0)=NaN(1);
imagesc(flipud(temp'))
caxis([-0.4 0.8])
colormap('jet')
colorbar
title('HighResMIP High-res partners 2005-2050 (3 models)')
