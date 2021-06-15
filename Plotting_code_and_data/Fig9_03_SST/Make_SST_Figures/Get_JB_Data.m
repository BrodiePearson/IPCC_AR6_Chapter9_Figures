clear all
load('GMSST_Anomalies.mat')

tmp_count = 1;
for ii=1:size(models_CMIP,2)
   if any(strcmp(models_SSP126,models_CMIP{ii}))
      models_CMIP_for_SSP126{tmp_count} = models_CMIP{ii}; 
      GMSST_CMIP_for_SSP126(:,tmp_count) = GMSST_CMIP(:,ii);
      tmp_count=tmp_count+1;
   end
end

tmp_count = 1;
for ii=1:size(models_CMIP,2)
   if any(strcmp(models_SSP245,models_CMIP{ii}))
      models_CMIP_for_SSP245{tmp_count} = models_CMIP{ii}; 
      GMSST_CMIP_for_SSP245(:,tmp_count) = GMSST_CMIP(:,ii);
      tmp_count=tmp_count+1;
   end
end

tmp_count = 1;
for ii=1:size(models_CMIP,2)
   if any(strcmp(models_SSP370,models_CMIP{ii}))
      models_CMIP_for_SSP370{tmp_count} = models_CMIP{ii}; 
      GMSST_CMIP_for_SSP370(:,tmp_count) = GMSST_CMIP(:,ii);
      tmp_count=tmp_count+1;
   end
end

tmp_count = 1;
for ii=1:size(models_CMIP,2)
   if any(strcmp(models_SSP585,models_CMIP{ii}))
      models_CMIP_for_SSP585{tmp_count} = models_CMIP{ii}; 
      GMSST_CMIP_for_SSP585(:,tmp_count) = GMSST_CMIP(:,ii);
      tmp_count=tmp_count+1;
   end
end

%% Calculate differences

i_beg_CMIP = find(CMIP_time==1995);
i_end_CMIP = find(CMIP_time==2014)+11; % Find the end of the last year
i_beg_SSP = find(SSP_time==2081);
i_end_SSP = find(SSP_time==2100)+11; % Find the end of the last year

for ii = 1:size(GMSST_SSP126,2)
    SSP126_means(ii) = nanmean(GMSST_SSP126(i_beg_SSP:i_end_SSP,ii));
    CMIP_for_SSP126_means(ii) = nanmean(GMSST_CMIP_for_SSP126(i_beg_CMIP:i_end_CMIP,ii));
    SSP126_changes = SSP126_means - CMIP_for_SSP126_means;
end

for ii = 1:size(GMSST_SSP245,2)
    SSP245_means(ii) = nanmean(GMSST_SSP245(i_beg_SSP:i_end_SSP,ii));
    CMIP_for_SSP245_means(ii) = nanmean(GMSST_CMIP_for_SSP245(i_beg_CMIP:i_end_CMIP,ii));
    SSP245_changes = SSP245_means - CMIP_for_SSP245_means;
end


for ii = 1:size(GMSST_SSP370,2)
    SSP370_means(ii) = nanmean(GMSST_SSP370(i_beg_SSP:i_end_SSP,ii));
    CMIP_for_SSP370_means(ii) = nanmean(GMSST_CMIP_for_SSP370(i_beg_CMIP:i_end_CMIP,ii));
    SSP370_changes = SSP370_means - CMIP_for_SSP370_means;
end


for ii = 1:size(GMSST_SSP585,2)
    SSP585_means(ii) = nanmean(GMSST_SSP585(i_beg_SSP:i_end_SSP,ii));
    CMIP_for_SSP585_means(ii) = nanmean(GMSST_CMIP_for_SSP585(i_beg_CMIP:i_end_CMIP,ii));
    SSP585_changes = SSP585_means - CMIP_for_SSP585_means;
end

save('JB_Data.mat', ...
    'SSP126_changes','SSP245_changes', ...
    'SSP370_changes', 'SSP585_changes', ...
    'models_SSP126','models_SSP245','models_SSP370','models_SSP585');



