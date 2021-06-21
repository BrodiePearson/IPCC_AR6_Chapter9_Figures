%% IPCC AR6 Chapter 9: Figure 9.6 Timeseries (Ocean Heat Content)
%
% Code used to plot pre-processed ocean heat content data. 
%
% Plotting code written by Brodie Pearson
% CMIP processed data provided by Yongqiang Yu & Lijuan Hua 
% Paleo processed data provided by Alan Mix
% Other datasets cited in report/caption

clear all

addpath ../../../Functions/
fontsize=15;
width = 3;

color_Shk = IPCC_Get_SSPColors('ssp370'); %red
color_SOSST = [196 121 0]/255; % orange
color_Uem = 'k'; % black
color_Bag = 'k'; % black
color_HadCM3 = [0 79 0]/255; % green
color_CMIP = [0 0 0]/255;
color_Lev = [196 121 0]/255; % orange

color_OBS = IPCC_Get_SSPColors('Observations');
color_HRMIP = IPCC_Get_SSPColors('HighResMIP');
color_HRSSP = IPCC_Get_SSPColors('HighResMIP');
color_CMIP = IPCC_Get_SSPColors('CMIP');
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

%% Load OHC trend fields (all experiments) and OHC mean (historical)

% First load last 10 year mean of each experiment
experiment = {'extract'};
suffix = '.nc';

prefix = 'timeseries_anomaly_ohc2000_';
data_path = {'./Processed_Data/historical_022521'; './Processed_Data/ssp126_030521'; ...
    './Processed_Data/ssp245_030521'; ...
    './Processed_Data/ssp370_030521'; './Processed_Data/ssp585_030521'};
count = {0,0,0,0,0};
for kk=1:size(data_path,1)
    kk
    datadir=dir(data_path{kk}+"/"+char(experiment)+"/");
    filenames = {datadir.name}; % Load filenames in path

%    i_models = find(contains(filenames,prefix) & ~contains(filenames,'BCC-ESM1'));
    i_models = find(contains(filenames,prefix) & ~contains(filenames,'NESM3'));
    for ii=1:size(i_models,2)
        count{kk} = count{kk} + 1;
        model_names{kk,count{kk}} = ...
            {strtok(erase(erase(filenames{1,i_models(ii)},prefix),suffix))};
        strtok(erase(erase(filenames{1,i_models(ii)},prefix),suffix))
        if (contains(filenames(i_models(ii)),'CAMS') & ~contains(data_path{kk},'historical')) ...
                || (contains(filenames(i_models(ii)),'MPI-ESM1-2-HR') & contains(data_path{kk},'ssp585'))
            ohc{kk}(:,count{kk}) = [squeeze(ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),'OHC2000')); NaN(12,1)];
        else
            ohc{kk}(:,count{kk}) = squeeze(ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),'OHC2000'));
        end
        if kk~=1 % SSP, so get historical for each model
            ohc_ref{kk}(:,count{kk}) = ncread(char(data_path{1}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),'OHC2000');
        end
        try
            var = 'time';
            time{kk,ii} = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),var);
        catch
            try
                var = 'TIME';
                time{kk,ii} = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                    "/"+filenames(i_models(ii))),var);
            catch
                try
                    var = 'T';
                    time{kk,ii} = ncread(char(data_path{kk}+"/"+char(experiment)+ ...
                        "/"+filenames(i_models(ii))),var);
                catch
                    warning('No time values found')
                end
            end
        end
        try
            var = 'time';
            time_ref{kk,ii} = ncread(char(data_path{1}+"/"+char(experiment)+ ...
                "/"+filenames(i_models(ii))),var);
        catch
            try
                var = 'TIME';
                time_ref{kk,ii} = ncread(char(data_path{1}+"/"+char(experiment)+ ...
                    "/"+filenames(i_models(ii))),var);
            catch
                try
                    var = 'T';
                    time_ref{kk,ii} = ncread(char(data_path{1}+"/"+char(experiment)+ ...
                        "/"+filenames(i_models(ii))),var);
                catch
                    warning('No time values found for historical reference')
                end
            end
        end
    end
    if exist('ohc')
      size(ohc{kk})
    end
end

%% Define timeseries with logical names and calculate means/uncertainty

CMIP_time = [1850:1/12:2015-1/12];
SSP_time = [2015:1/12:2100-1/12];

anom_start = 2004;
anom_end = 2015;
csv_anom_start = 2004; %2004;
csv_anom_end = 2015;  %2015;

anom_indices = find(CMIP_time<=anom_end & CMIP_time>=anom_start);

OHC_CMIP = movmean(ohc{1},12,'Endpoints','shrink')/(1e24);
OHC_SSP126 = movmean(ohc{2}(1:end-12,:),12,'Endpoints','shrink')/(1e24);
OHC_SSP245 = movmean(ohc{3}(1:end-12,:),12,'Endpoints','shrink')/(1e24);
OHC_SSP370 = movmean(ohc{4}(1:end-12,:),12,'Endpoints','shrink')/(1e24);
OHC_SSP585 = movmean(ohc{5}(1:end-12,:),12,'Endpoints','shrink')/(1e24);
OHC_SSP126_ref = movmean(ohc_ref{2},12,'Endpoints','shrink')/(1e24);
OHC_SSP245_ref = movmean(ohc_ref{3},12,'Endpoints','shrink')/(1e24);
OHC_SSP370_ref = movmean(ohc_ref{4},12,'Endpoints','shrink')/(1e24);
OHC_SSP585_ref = movmean(ohc_ref{5},12,'Endpoints','shrink')/(1e24);

OHC_CMIP(OHC_CMIP>1e60)=NaN(1);
OHC_SSP126_ref(OHC_SSP126_ref>1e60)=NaN(1);
OHC_SSP245_ref(OHC_SSP245_ref>1e60)=NaN(1);
OHC_SSP370_ref(OHC_SSP370_ref>1e60)=NaN(1);
OHC_SSP585_ref(OHC_SSP585_ref>1e60)=NaN(1);


OHC_CMIP_anom = OHC_CMIP -  ...
    nanmean(OHC_CMIP(anom_indices,:),1);

OHC_SSP126_anom = OHC_SSP126 -  ...
    nanmean(OHC_SSP126_ref(anom_indices,:),1);
OHC_SSP245_anom = OHC_SSP245 -  ...
    nanmean(OHC_SSP245_ref(anom_indices,:),1);
OHC_SSP370_anom = OHC_SSP370 -  ...
    nanmean(OHC_SSP370_ref(anom_indices,:),1);
OHC_SSP585_anom = OHC_SSP585 -  ...
    nanmean(OHC_SSP585_ref(anom_indices,:),1);

OHC_SSP126_ref_anom = OHC_SSP126_ref -  ...
    nanmean(OHC_SSP126_ref(anom_indices,:),1);
OHC_SSP245_ref_anom = OHC_SSP245_ref -  ...
    nanmean(OHC_SSP245_ref(anom_indices,:),1);
OHC_SSP370_ref_anom = OHC_SSP370_ref -  ...
    nanmean(OHC_SSP370_ref(anom_indices,:),1);
OHC_SSP585_ref_anom = OHC_SSP585_ref -  ...
    nanmean(OHC_SSP585_ref(anom_indices,:),1);

OHC_CMIP_mean = nanmean(OHC_CMIP_anom,2);
OHC_SSP126_mean = nanmean(OHC_SSP126_anom,2);
OHC_SSP245_mean = nanmean(OHC_SSP245_anom,2);
OHC_SSP370_mean = nanmean(OHC_SSP370_anom,2);
OHC_SSP585_mean = nanmean(OHC_SSP585_anom,2);

OHC_CMIP_std = nanstd(OHC_CMIP_anom,1,2);
OHC_SSP126_std = nanstd(OHC_SSP126_anom,1,2);
OHC_SSP245_std = nanstd(OHC_SSP245_anom,1,2);
OHC_SSP370_std = nanstd(OHC_SSP370_anom,1,2);
OHC_SSP585_std = nanstd(OHC_SSP585_anom,1,2);

CMIP_count = size(OHC_CMIP,2);
SSP126_count = size(OHC_SSP126,2);
SSP245_count = size(OHC_SSP245,2);
SSP370_count = size(OHC_SSP370,2);
SSP585_count = size(OHC_SSP585,2);

% CMIP_? are all built from OHC_CMIP_anom

CMIP_median=quantile(OHC_CMIP_anom,0.5,2);
CMIP_Likely_ubound=quantile(OHC_CMIP_anom,0.83,2);
CMIP_Likely_lbound=quantile(OHC_CMIP_anom,0.17,2);
CMIP_Likely_Conf_Bounds = [CMIP_Likely_ubound' flipud(CMIP_Likely_lbound)'];
CMIP_VeryLikely_ubound=quantile(OHC_CMIP_anom,0.95,2);
CMIP_VeryLikely_lbound=quantile(OHC_CMIP_anom,0.05,2);
CMIP_VeryLikely_Conf_Bounds = [CMIP_VeryLikely_ubound' flipud(CMIP_VeryLikely_lbound)'];
CMIP_Time_Conf_Bounds = [CMIP_time fliplr(CMIP_time)];

outstruct.CMIP_time=CMIP_time(:);
outstruct.CMIP=OHC_CMIP_mean(:);
outstruct.CMIP_Likely_lbound=CMIP_Likely_lbound(:);
outstruct.CMIP_VeryLikely_lbound=CMIP_VeryLikely_lbound(:);
outstruct.CMIP_Likely_ubound=CMIP_Likely_ubound(:);
outstruct.CMIP_VeryLikely_ubound=CMIP_VeryLikely_ubound(:);
offset=mean(outstruct.CMIP(find(outstruct.CMIP_time>=csv_anom_start&outstruct.CMIP_time<=csv_anom_end)));

% SSP_? are all built from OHC_SSP_anom

SSP126_median=quantile(OHC_SSP126_anom,0.5,2);
SSP126_Likely_ubound=quantile(OHC_SSP126_anom,0.83,2);
SSP126_Likely_lbound=quantile(OHC_SSP126_anom,0.17,2);
SSP126_Likely_Conf_Bounds = [SSP126_Likely_ubound' flipud(SSP126_Likely_lbound)'];
SSP126_VeryLikely_ubound=quantile(OHC_SSP126_anom,0.95,2);
SSP126_VeryLikely_lbound=quantile(OHC_SSP126_anom,0.05,2);
SSP126_VeryLikely_Conf_Bounds = [SSP126_VeryLikely_ubound' flipud(SSP126_VeryLikely_lbound)'];

outstruct.SSP126_time=SSP_time(:);
outstruct.SSP126=OHC_SSP126_mean(:);
outstruct.SSP126_Likely_lbound=SSP126_Likely_lbound(:);
outstruct.SSP126_VeryLikely_lbound=SSP126_VeryLikely_lbound(:);
outstruct.SSP126_Likely_ubound=SSP126_Likely_ubound(:);
outstruct.SSP126_VeryLikely_ubound=SSP126_VeryLikely_ubound(:);
outstruct.SSP126=outstruct.SSP126-offset;
outstruct.SSP126_Likely_lbound=outstruct.SSP126_Likely_lbound-offset;
outstruct.SSP126_Likely_ubound=outstruct.SSP126_Likely_ubound-offset;
outstruct.SSP126_VeryLikely_lbound=outstruct.SSP126_VeryLikely_lbound-offset;
outstruct.SSP126_VeryLikely_ubound=outstruct.SSP126_VeryLikely_ubound-offset;

SSP245_median=quantile(OHC_SSP245_anom,0.5,2);
SSP245_Likely_ubound=quantile(OHC_SSP245_anom,0.83,2);
SSP245_Likely_lbound=quantile(OHC_SSP245_anom,0.17,2);
SSP245_Likely_Conf_Bounds = [SSP245_Likely_ubound' flipud(SSP245_Likely_lbound)'];
SSP245_VeryLikely_ubound=quantile(OHC_SSP245_anom,0.95,2);
SSP245_VeryLikely_lbound=quantile(OHC_SSP245_anom,0.05,2);
SSP245_VeryLikely_Conf_Bounds = [SSP245_VeryLikely_ubound' flipud(SSP245_VeryLikely_lbound)'];

outstruct.SSP245_time=SSP_time(:);
outstruct.SSP245=OHC_SSP245_mean(:);
outstruct.SSP245_Likely_lbound=SSP245_Likely_lbound(:);
outstruct.SSP245_VeryLikely_lbound=SSP245_VeryLikely_lbound(:);
outstruct.SSP245_Likely_ubound=SSP245_Likely_ubound(:);
outstruct.SSP245_VeryLikely_ubound=SSP245_VeryLikely_ubound(:);
outstruct.SSP245=outstruct.SSP245-offset;
outstruct.SSP245_Likely_lbound=outstruct.SSP245_Likely_lbound-offset;
outstruct.SSP245_Likely_ubound=outstruct.SSP245_Likely_ubound-offset;
outstruct.SSP245_VeryLikely_lbound=outstruct.SSP245_VeryLikely_lbound-offset;
outstruct.SSP245_VeryLikely_ubound=outstruct.SSP245_VeryLikely_ubound-offset;

SSP370_median=quantile(OHC_SSP370_anom,0.5,2);
SSP370_Likely_ubound=quantile(OHC_SSP370_anom,0.83,2);
SSP370_Likely_lbound=quantile(OHC_SSP370_anom,0.17,2);
SSP370_Likely_Conf_Bounds = [SSP370_Likely_ubound' flipud(SSP370_Likely_lbound)'];
SSP370_VeryLikely_ubound=quantile(OHC_SSP370_anom,0.95,2);
SSP370_VeryLikely_lbound=quantile(OHC_SSP370_anom,0.05,2);
SSP370_VeryLikely_Conf_Bounds = [SSP370_VeryLikely_ubound' flipud(SSP370_VeryLikely_lbound)'];

outstruct.SSP370_time=SSP_time(:);
outstruct.SSP370=OHC_SSP370_mean(:);
outstruct.SSP370_Likely_lbound=SSP370_Likely_lbound(:);
outstruct.SSP370_VeryLikely_lbound=SSP370_VeryLikely_lbound(:);
outstruct.SSP370_Likely_ubound=SSP370_Likely_ubound(:);
outstruct.SSP370_VeryLikely_ubound=SSP370_VeryLikely_ubound(:);
outstruct.SSP370=outstruct.SSP370-offset;
outstruct.SSP370_Likely_lbound=outstruct.SSP370_Likely_lbound-offset;
outstruct.SSP370_Likely_ubound=outstruct.SSP370_Likely_ubound-offset;
outstruct.SSP370_VeryLikely_lbound=outstruct.SSP370_VeryLikely_lbound-offset;
outstruct.SSP370_VeryLikely_ubound=outstruct.SSP370_VeryLikely_ubound-offset;

SSP585_median=quantile(OHC_SSP585_anom,0.5,2);
SSP585_Likely_ubound=quantile(OHC_SSP585_anom,0.83,2);
SSP585_Likely_lbound=quantile(OHC_SSP585_anom,0.17,2);
SSP585_Likely_Conf_Bounds = [SSP585_Likely_ubound' flipud(SSP585_Likely_lbound)'];
SSP585_VeryLikely_ubound=quantile(OHC_SSP585_anom,0.95,2);
SSP585_VeryLikely_lbound=quantile(OHC_SSP585_anom,0.05,2);
SSP585_VeryLikely_Conf_Bounds = [SSP585_VeryLikely_ubound' flipud(SSP585_VeryLikely_lbound)'];

outstruct.SSP585_time=SSP_time(:);
outstruct.SSP585=OHC_SSP585_mean(:);
outstruct.SSP585_Likely_lbound=SSP585_Likely_lbound(:);
outstruct.SSP585_VeryLikely_lbound=SSP585_VeryLikely_lbound(:);
outstruct.SSP585_Likely_ubound=SSP585_Likely_ubound(:);
outstruct.SSP585_VeryLikely_ubound=SSP585_VeryLikely_ubound(:);
outstruct.SSP585=outstruct.SSP585-offset;
outstruct.SSP585_Likely_lbound=outstruct.SSP585_Likely_lbound-offset;
outstruct.SSP585_Likely_ubound=outstruct.SSP585_Likely_ubound-offset;
outstruct.SSP585_VeryLikely_lbound=outstruct.SSP585_VeryLikely_lbound-offset;
outstruct.SSP585_VeryLikely_ubound=outstruct.SSP585_VeryLikely_ubound-offset;

SSP_Time_Conf_Bounds = [SSP_time fliplr(SSP_time)];

%% Load hybrid data (Zanna et al 2019)

OHC_Hybrid = ncread('./Processed_Data/OHC_GF_1870_2018_Zanna.nc','OHC_2000m')/1e3;
OHC_Hybrid_std = ncread('./Processed_Data/OHC_GF_1870_2018_Zanna.nc','error_OHC_2000')/1e3;
TIME_Hybrid = ncread('./Processed_Data/OHC_GF_1870_2018_Zanna.nc','time');
OHC_Hybrid_mean = OHC_Hybrid - nanmean(OHC_Hybrid(TIME_Hybrid<=anom_end & TIME_Hybrid>=anom_start));
Hybrid_ubound=OHC_Hybrid_mean+OHC_Hybrid_std;
Hybrid_lbound=OHC_Hybrid_mean-OHC_Hybrid_std;
Hybrid_Conf_Bounds = [Hybrid_ubound; flipud(Hybrid_lbound); Hybrid_ubound(1)];
Hybrid_Time_Conf_Bounds = [TIME_Hybrid; flipud(TIME_Hybrid); TIME_Hybrid(1)];

outstruct.Zanna_time=TIME_Hybrid(:);
outstruct.Zanna=OHC_Hybrid(:);
outstruct.Zanna_Likely_lbound=Hybrid_lbound(:);
outstruct.Zanna_Likely_ubound=Hybrid_ubound(:);
offset=mean(outstruct.Zanna(find(outstruct.Zanna_time>=csv_anom_start&outstruct.Zanna_time<=csv_anom_end)));
outstruct.Zanna=outstruct.Zanna-offset;
outstruct.Zanna_Likely_lbound=outstruct.Zanna_Likely_lbound-offset;
outstruct.Zanna_Likely_ubound=outstruct.Zanna_Likely_ubound-offset;

%% Load observation data (Ishii)

OHC_OBS_table = readtable('./Processed_Data/ishii_ohc_global_1955.txt');
OHC_OBS_mean = (1e-2)*table2array(OHC_OBS_table(:,4)); % Extract 0-2000m OHC data (Units 10^{22} J)
OHC_OBS_std = (1e-2)*table2array(OHC_OBS_table(:,5)); % Extract 0-2000m OHC 95% confidence == 2x st dev.!!
TIME_OBS = table2array(OHC_OBS_table(:,1));
OHC_OBS_mean = OHC_OBS_mean - nanmean(OHC_OBS_mean(TIME_OBS<=csv_anom_end & TIME_OBS>=csv_anom_start));
OBS_ubound=OHC_OBS_mean+OHC_OBS_std/2; % this factor of 2 added by BFK after FGD
OBS_lbound=OHC_OBS_mean-OHC_OBS_std/2; % this factor of 2 added by BFK after FGD
OBS_Conf_Bounds = [OBS_ubound; flipud(OBS_lbound); OBS_ubound(1)];
OBS_Time_Conf_Bounds = [TIME_OBS; flipud(TIME_OBS); TIME_OBS(1)];

outstruct.Ishii2k_time=TIME_OBS;
outstruct.Ishii2k=OHC_OBS_mean(:);
outstruct.Ishii2k_Likely_lbound=OBS_lbound(:);
outstruct.Ishii2k_Likely_ubound=OBS_ubound(:);

offset=mean(outstruct.Ishii2k(find(outstruct.Ishii2k_time>=anom_start&outstruct.Ishii2k_time<=anom_end)));
outstruct.Ishii2k=outstruct.Ishii2k-offset;
outstruct.Ishii2k_Likely_lbound=outstruct.Ishii2k_Likely_lbound-offset;
outstruct.Ishii2k_Likely_ubound=outstruct.Ishii2k_Likely_ubound-offset;

%% Load Hybrid 2 data (Cheng)


OHC_Hybrid2_table = readtable('./Processed_Data/Cheng_2016_Global_OHC_13_Jan_2021.txt');
OHC_Hybrid2_mean = (1e-3)*table2array(OHC_Hybrid2_table(:,2)); % Extract 0-2000m OHC data (Units 10^{22} J)
TIME_Hybrid2 = table2array(OHC_Hybrid2_table(:,1));
OHC_Hybrid2_mean = OHC_Hybrid2_mean - nanmean(OHC_Hybrid2_mean(TIME_Hybrid2<=anom_end & TIME_Hybrid2>=anom_start));

%% Make main timeseries plot

ylims = [-1 3.2];

figure('Position', [10 10 1200 300])
patch(SSP_Time_Conf_Bounds,SSP126_Likely_Conf_Bounds,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
patch(SSP_Time_Conf_Bounds,SSP245_Likely_Conf_Bounds,color_SSP245, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP370_Likely_Conf_Bounds,color_SSP370, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(SSP_Time_Conf_Bounds,SSP585_Likely_Conf_Bounds,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
obs_std = patch(OBS_Time_Conf_Bounds,OBS_Conf_Bounds,color_OBS, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(Hybrid_Time_Conf_Bounds,Hybrid_Conf_Bounds,color_OBS,'EdgeColor', 'none', 'FaceAlpha', 0.2)
likely = patch(CMIP_Time_Conf_Bounds,CMIP_Likely_Conf_Bounds,color_CMIP, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
plot(SSP_time,OHC_SSP126_mean,'Color', color_SSP126, 'LineWidth', width)
plot(SSP_time,OHC_SSP245_mean,'Color', color_SSP245, 'LineWidth', width)
plot(SSP_time,OHC_SSP370_mean,'Color', color_SSP370, 'LineWidth', width)
plot(SSP_time,OHC_SSP585_mean,'Color', color_SSP585, 'LineWidth', width)
means = plot(CMIP_time,OHC_CMIP_mean, 'Color', color_CMIP, 'LineWidth', width);
ishii=plot(TIME_OBS,OHC_OBS_mean, 'Color', color_OBS, 'LineWidth', width/4)
zanna=plot(TIME_Hybrid,OHC_Hybrid_mean, '--', 'Color', color_OBS, 'LineWidth', width/2)
cheng=plot(TIME_Hybrid2,OHC_Hybrid2_mean, ':', 'Color', color_OBS, 'LineWidth', width)
ylim(ylims)
xlim([1850 2100])
set(gca,'Xtick',[1850 1900 1950 2000 2050 2100],'Xticklabel',{'1850', '1900','1950','2000','2050', '2100'})
set(gca,'Ytick',[-1 -0.5 0 0.5 1 1.5 2 2.5 3],'Yticklabel',{'-1', '','0','','1', '','2','','3'})
set(gca,'FontSize',20)
ylabel('10^{24} J            ')
set(get(gca,'YLabel'),'Rotation',0)

txt = "SSP5-8.5_{"+num2str(SSP585_count)+"}";
text(SSP_time(end/3)+3,OHC_SSP585_mean(end/2)+1,txt,'FontSize',16, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = "SSP1-2.6_{"+num2str(SSP126_count)+"}";
text(SSP_time(end/3)+3,OHC_SSP126_mean(end/2)-0.5+0.05,txt,'FontSize',16, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = "SSP2-4.5_{"+num2str(SSP245_count)+"}";
text(SSP_time(2*end/3),OHC_SSP126_mean(end/2)-0.3,txt,'FontSize',16, ...
    'Color', color_SSP245, 'FontWeight', 'bold')
txt = "SSP3-7.0_{"+num2str(SSP370_count)+"}";
text(SSP_time(end/4)-5,OHC_SSP370_mean(end)-0.8+0.1,txt,'FontSize',16, ...
    'Color', color_SSP370, 'FontWeight', 'bold')
txt = "CMIP_{"+num2str(CMIP_count)+" models}";
text(CMIP_time(end/2)+30,OHC_CMIP_mean(end/2)-0.3,txt,'FontSize',16, ...
    'Color', color_CMIP, 'FontWeight', 'bold')
txt = {'Observations',' & Hybrid'};
text(TIME_OBS(ceil(end/3)),OHC_OBS_mean(ceil(end/2))+0.5,txt,'FontSize',16, ...
    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','center')
txt = 'Global OHC (0-2000m depth); Modern history and model projections to 2100';
text(1855,3.0,txt,'FontSize',18, ...
    'Color', 'k', 'FontWeight', 'bold')

set(gca,'Box', 'on','Clipping','off')

ylength = ylims(2)-ylims(1);
patch([anom_start anom_end anom_end anom_start], ...
    [ylims(1)+0.1*ylength ylims(1)+0.1*ylength ylims(1) ylims(1)],'k', ...
    'EdgeColor', 'none','FaceAlpha', 0.2)
txt = {'Baseline', 'Period'};
text(anom_end+8,ylims(1)+0.055*ylength,txt,'FontSize',12, ...
    'Color', 'k','HorizontalAlignment','center')%, 'FontWeight', 'bold')
txt = {'CMIP6','2100 means &', '(very) likely', 'ranges'};
text(2100+9,ylims(1)+0.28*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

plot([1850 2101], [1850 2100]*0, 'k', 'LineWidth', width/10)


% Plot spans of 2100 OHC

plot([2104,2104], [OHC_SSP126_mean(end), OHC_SSP126_mean(end)] ...
    , '.', 'Color',color_SSP126, 'MarkerSize', 20)
plot([2104,2104], [SSP126_Likely_ubound(end), SSP126_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width)
plot([2104,2104], [SSP126_VeryLikely_ubound(end), SSP126_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)

plot([2106,2106], [OHC_SSP245_mean(end), OHC_SSP245_mean(end)] ...
    , '.', 'Color',color_SSP245, 'MarkerSize', 20)
plot([2106,2106], [SSP245_Likely_ubound(end), SSP245_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width)
plot([2106,2106], [SSP245_VeryLikely_ubound(end), SSP245_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP245, 'LineWidth', width/2)

plot([2108,2108], [OHC_SSP370_mean(end), OHC_SSP370_mean(end)] ...
    , '.', 'Color',color_SSP370, 'MarkerSize', 20)
plot([2108,2108], [SSP370_Likely_ubound(end), SSP370_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width)
plot([2108,2108], [SSP370_VeryLikely_ubound(end), SSP370_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP370, 'LineWidth', width/2)

plot([2110,2110], [OHC_SSP585_mean(end), OHC_SSP585_mean(end)] ...
    , '.', 'Color',color_SSP585, 'MarkerSize', 20)
plot([2110,2110], [SSP585_Likely_ubound(end), SSP585_Likely_lbound(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width)
plot([2110,2110], [SSP585_VeryLikely_ubound(end), SSP585_VeryLikely_lbound(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)

legend([means likely ishii zanna cheng obs_std],'Global Mean OHC', ...
    'CMIP6 17-83% ranges', 'Observations (Ishii)', ...
    'Hybrid (Zanna)', 'Hybrid (Cheng)','\pm 1\sigma (Obs. & Hybrid)','Box','off' ...
    ,'Position',[0.22 0.5 0.1 0.1],'FontSize',14)

print(gcf,'../PNGs/OHC_Timeseries.png','-dpng','-r1000', '-painters');


%% Save OHC Timeseries data

savefile = 'OHC_Anomaly_Timeseries.xls';

Time_yr = CMIP_time';
Mean_10tothe24J = OHC_CMIP_mean;
Likely_upper_bound = CMIP_Likely_ubound;
Likely_lower_bound = CMIP_Likely_lbound;
VeryLikely_upper_bound = CMIP_VeryLikely_ubound;
VeryLikely_lower_bound = CMIP_VeryLikely_lbound;
T = table(Time_yr,Mean_10tothe24J,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','CMIP');

Time_yr = TIME_OBS;
Mean_10tothe24J = OHC_OBS_mean;
Standard_Deviation = OHC_OBS_std;
T = table(Time_yr,Mean_10tothe24J,Standard_Deviation);
writetable(T,savefile,'Sheet','OBS (Ishii)');

Time_yr = TIME_Hybrid;
Mean_10tothe24J = OHC_Hybrid_mean;
Standard_Deviation = OHC_Hybrid_std;
T = table(Time_yr,Mean_10tothe24J,Standard_Deviation);
writetable(T,savefile,'Sheet','Hybrid (Zanna)');

Time_yr = TIME_Hybrid2;
Mean_10tothe24J = OHC_Hybrid2_mean;
T = table(Time_yr,Mean_10tothe24J);
writetable(T,savefile,'Sheet','Hybrid (Cheng)');

Time_yr = SSP_time';
Mean_10tothe24J = OHC_SSP126_mean;
Likely_upper_bound = SSP126_Likely_ubound;
Likely_lower_bound = SSP126_Likely_lbound;
VeryLikely_upper_bound = SSP126_VeryLikely_ubound;
VeryLikely_lower_bound = SSP126_VeryLikely_lbound;
T = table(Time_yr,Mean_10tothe24J,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP1-2.6');

Time_yr = SSP_time';
Mean_10tothe24J = OHC_SSP245_mean;
Likely_upper_bound = SSP245_Likely_ubound;
Likely_lower_bound = SSP245_Likely_lbound;
VeryLikely_upper_bound = SSP245_VeryLikely_ubound;
VeryLikely_lower_bound = SSP245_VeryLikely_lbound;
T = table(Time_yr,Mean_10tothe24J,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP2-4.5');

Time_yr = SSP_time';
Mean_10tothe24J = OHC_SSP370_mean;
Likely_upper_bound = SSP370_Likely_ubound;
Likely_lower_bound = SSP370_Likely_lbound;
VeryLikely_upper_bound = SSP370_VeryLikely_ubound;
VeryLikely_lower_bound = SSP370_VeryLikely_lbound;
T = table(Time_yr,Mean_10tothe24J,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP3-7.0');

Time_yr = SSP_time';
Mean_10tothe24J = OHC_SSP585_mean;
Likely_upper_bound = SSP585_Likely_ubound;
Likely_lower_bound = SSP585_Likely_lbound;
VeryLikely_upper_bound = SSP585_VeryLikely_ubound;
VeryLikely_lower_bound = SSP585_VeryLikely_lbound;
T = table(Time_yr,Mean_10tothe24J,Likely_upper_bound,Likely_lower_bound, ...
    VeryLikely_upper_bound,VeryLikely_lower_bound);
writetable(T,savefile,'Sheet','SSP5-8.5');

%% Create csv file with output variables

struct2csv(outstruct,'./Processed_Data/OHC_Timeseries.csv')

%% Load data for paleo OHC panel

% Load in Alan's Excel file of data (contains future OHC/SST and several paleo records

[~,sheet_name]=xlsfinfo("./Processed_Data/9.2.2_ACM_Fig_9.9_OHC_Paleo_Data_update_2020_12_06.xlsx");

for k=1:numel(sheet_name)
  data{k}=xlsread( ...
      './Processed_Data/9.2.2_ACM_Fig_9.9_OHC_Paleo_Data_update_2020_12_06.xlsx', ...
      sheet_name{k});
end

% Extract oldest (LIG) OHC data from Shackleton 2020

tmp_data = cell2mat(data(1,2));

% Extract Shackleton time in ka CE (negative)
Time_OHC_Oldest = tmp_data(1:50,3)/1000;
% Extract Shackleton OHC in 10^4 ZJ
OHC_Oldest = tmp_data(1:50,9)/1e4;

OHC_LIG = OHC_Oldest(Time_OHC_Oldest>=-129 & Time_OHC_Oldest<=-116);

OHC_LIG_Likely_upper = quantile(OHC_LIG,0.83);
OHC_LIG_Likely_lower = quantile(OHC_LIG,0.17);

OHC_LIG_VeryLikely_upper = quantile(OHC_LIG,0.95);
OHC_LIG_VeryLikely_lower = quantile(OHC_LIG,0.05);
OHC_LIG_Mean = nanmean(OHC_LIG);

% Extract recent (LGM/mid-Holocene) OHC data from Baggenstos 2019

tmp_data = cell2mat(data(1,3));

% Extract Baggenstos time in ka CE (negative)
Time_OHC_Old = tmp_data(3:39,19)/1000;
% Extract Shackleton OHC in 10^4 ZJ
OHC_Old = tmp_data(3:39,25)/1e4;
Bag_OHC_Old_min = tmp_data(3:39,26)/1e4;
Bag_OHC_Old_max = tmp_data(3:39,27)/1e4;

OHC_LGM = OHC_Old(Time_OHC_Old>=-23.0 & Time_OHC_Old<=-19.0);
OHC_LGM_Likely_upper = quantile(OHC_LGM,0.83);
OHC_LGM_Likely_lower = quantile(OHC_LGM,0.17);
OHC_LGM_VeryLikely_upper = quantile(OHC_LGM,0.95);
OHC_LGM_VeryLikely_lower = quantile(OHC_LGM,0.05);
OHC_LGM_Mean = nanmean(OHC_LGM);

OHC_MH_Mean = OHC_Old(Time_OHC_Old>=-6.5 & Time_OHC_Old<=-5.5);
OHC_MH_upper = Bag_OHC_Old_max(Time_OHC_Old>=-6.5 & Time_OHC_Old<=-5.5);
OHC_MH_lower = Bag_OHC_Old_min(Time_OHC_Old>=-6.5 & Time_OHC_Old<=-5.5);



%% Plot paleo data

figure('Position', [10 10 200 350])
plot([.5,.5], [OHC_LIG_Mean, OHC_LIG_Mean], '.', 'MarkerSize',22, 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
hold on
plot([.5,.5], [OHC_LIG_Likely_lower, OHC_LIG_Likely_upper], '-', 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS)
plot([.5,.5], [OHC_LIG_VeryLikely_lower, OHC_LIG_VeryLikely_upper], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS)
plot([2,2], [OHC_LGM_Mean, OHC_LGM_Mean], '.', 'MarkerSize',22, 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([2,2], [OHC_LGM_Likely_lower, OHC_LGM_Likely_upper], '-', 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS)
plot([2,2], [OHC_LGM_VeryLikely_lower, OHC_LGM_VeryLikely_upper], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS)
plot([3.5,3.5], [OHC_MH_Mean, OHC_MH_Mean], '.', 'MarkerSize',22, 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([3.5,3.5], [OHC_MH_lower, OHC_MH_upper], '-', 'LineWidth', width,'MarkerEdgeColor', color_OBS,'Color', color_OBS)

xlim([0 4])
plot([0 5], [0 5]*0, 'k', 'LineWidth', width/10)
ylim([-2 2])
set(gca,'Xtick',[0.5 2 3.5],'Xticklabel',[])
set(gca,'Ytick',[-2 -1.5 -1 -0.5 0 0.5 1 1.5 2],'Yticklabel',{'-2','','-1','','0', '','1','','2'})
set(gca,'FontSize',15,'Box', 'on')
txt = {'Observed means and', '(very) likely ranges'};
text(2.1,1.2,txt,'FontSize',14, ...
    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','center')
% ylabel('^o C')
% set(get(gca,'YLabel'),'Rotation',0)

text(0.5,-2.2,{'LIG'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(2,-2.2,{'LGM'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(3.5,-2.2,{'MH'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')

txt = 'Paleo OHC';
text(0.2,1.8,txt,'FontSize',18, ...
    'Color', 'k', 'FontWeight', 'bold')

print(gcf,'../PNGs/Paleo_OHC.png','-dpng','-r1000', '-painters');

%% Write data from modern timeseries into netcdf files

var_name = 'OHC_anomaly';
var_units = '10^24 Joules';
comments = "Data is for panel (a) of Figure 9.6 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp126likelybounds.nc';
title = "Likely range of Global Ocean Heat Content Anomaly for "+ ...
    "SSP1-2.6 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP126_Likely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp245likelybounds.nc';
title = "Likely range of Global Ocean Heat Content Anomaly for "+ ...
    "SSP2-4.5 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP245_Likely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp370likelybounds.nc';
title = "Likely range of Global Ocean Heat Content Anomaly for "+ ...
    "SSP3-7.0 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP370_Likely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp585likelybounds.nc';
title = "Likely range of Global Ocean Heat Content Anomaly for "+ ...
    "SSP5-8.5 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP585_Likely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp126verylikelybounds.nc';
title = "Very likely range of Global Ocean Heat Content Anomaly for "+ ...
    "SSP1-2.6 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP126_VeryLikely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp245verylikelybounds.nc';
title = "Very likely range of Global Ocean Heat Content Anomaly for "+ ...
    "SSP2-4.5 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP245_VeryLikely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp370verylikelybounds.nc';
title = "Very likely range of Global Ocean Heat Content Anomaly for "+ ...
    "SSP3-7.0 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP370_VeryLikely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp585verylikelybounds.nc';
title = "Very likely range of Global Ocean Heat Content Anomaly for "+ ...
    "SSP5-8.5 relative to baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, SSP585_VeryLikely_Conf_Bounds', ...
    SSP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp126mean.nc';
title = "Global Mean Ocean Heat Content Anomaly for SSP1-2.6 relative to "+ ...
    "baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_SSP126_mean', ...
    SSP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp245mean.nc';
title = "Global Mean Ocean Heat Content Anomaly for SSP2-4.5 relative to "+ ...
    "baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_SSP245_mean', ...
    SSP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp370mean.nc';
title = "Global Mean Ocean Heat Content Anomaly for SSP3-7.0 relative to "+ ...
    "baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_SSP370_mean', ...
    SSP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_ssp585mean.nc';
title = "Global Mean Ocean Heat Content Anomaly for SSP5-8.5 relative to "+ ...
    "baseline period using CMIP6 (CMIP & ScenarioMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_SSP585_mean', ...
    SSP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_CMIPlikelybounds.nc';
title = "Likely range of Global Ocean Heat Content Anomaly "+ ...
    "relative to baseline period using CMIP6 (CMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, CMIP_Likely_Conf_Bounds', ...
    CMIP_Time_Conf_Bounds', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_CMIPmean.nc';
title = "Global Mean Ocean Heat Content Anomaly relative to "+ ...
    "baseline period using CMIP6 (CMIP)";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_CMIP_mean', ...
    CMIP_time', title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_Observedmean.nc';
title = "Global Mean Ocean Heat Content Anomaly relative to "+ ...
    "baseline period using observations from Ishii et al., 2017";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_OBS_mean', ...
    TIME_OBS, title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_Observedlikelybounds.nc';
title = "Likely range of Global Ocean Heat Content Anomaly "+ ...
    "relative to baseline period using observations from Ishii et al., 2017";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OBS_Conf_Bounds', ...
    OBS_Time_Conf_Bounds, title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_HybridZannamean.nc';
title = "Global Mean Ocean Heat Content Anomaly relative to "+ ...
    "baseline period using hybrid dataset from Zanna et al., 2019";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Hybrid_mean', ...
    TIME_Hybrid, title, comments)

ncfilename = '../Plotted_Data/Fig9-6a_data_HybridChengmean.nc';
title = "Global Mean Ocean Heat Content Anomaly relative to "+ ...
    "baseline period using hybrid dataset from Cheng et al., 2019";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, OHC_Hybrid_mean', ...
    TIME_Hybrid, title, comments)

%% Write paleo plot data

creator = "Brodie Pearson (brodie.pearson@oregonstate.edu)";
activity = "IPCC AR6 (Chapter 9)";
ncfilename = '../Plotted_Data/Fig9-6a_data_paleo.nc';
title = "Paleo global mean ocean heat content datasets "+ ...
    "with means, likely and very likely ranges. Mid-holocene"+ ...
    "range shows the min and max values across the period due to their small range.";

% Create variables in netcdf files
nccreate(ncfilename,'OHC_LGM_Mean');
nccreate(ncfilename,'OHC_LGM_Likely_upper');
nccreate(ncfilename,'OHC_LGM_Likely_lower');
nccreate(ncfilename,'OHC_LGM_VeryLikely_lower');
nccreate(ncfilename,'OHC_LGM_VeryLikely_upper');
nccreate(ncfilename,'OHC_LIG_Mean');
nccreate(ncfilename,'OHC_LIG_Likely_upper');
nccreate(ncfilename,'OHC_LIG_Likely_lower');
nccreate(ncfilename,'OHC_LIG_VeryLikely_lower');
nccreate(ncfilename,'OHC_LIG_VeryLikely_upper');
nccreate(ncfilename,'OHC_MH_Mean');
nccreate(ncfilename,'OHC_MH_max');
nccreate(ncfilename,'OHC_MH_min');

% Write variables to netcdf files
ncwrite(ncfilename,'OHC_LGM_Mean',OHC_LGM_Mean);
ncwrite(ncfilename,'OHC_LGM_Likely_upper',OHC_LGM_Likely_upper);
ncwrite(ncfilename,'OHC_LGM_Likely_lower',OHC_LGM_Likely_lower);
ncwrite(ncfilename,'OHC_LGM_VeryLikely_upper',OHC_LGM_VeryLikely_upper);
ncwrite(ncfilename,'OHC_LGM_VeryLikely_lower',OHC_LGM_VeryLikely_lower);
ncwrite(ncfilename,'OHC_LIG_Mean',OHC_LIG_Mean);
ncwrite(ncfilename,'OHC_LIG_Likely_upper',OHC_LIG_Likely_upper);
ncwrite(ncfilename,'OHC_LIG_Likely_lower',OHC_LIG_Likely_lower);
ncwrite(ncfilename,'OHC_LIG_VeryLikely_upper',OHC_LIG_VeryLikely_upper);
ncwrite(ncfilename,'OHC_LIG_VeryLikely_lower',OHC_LIG_VeryLikely_lower);
ncwrite(ncfilename,'OHC_MH_Mean',OHC_MH_Mean);
ncwrite(ncfilename,'OHC_MH_max',OHC_MH_upper);
ncwrite(ncfilename,'OHC_MH_min',OHC_MH_lower);


% Write metadata to netcdf file
ncwriteatt(ncfilename,'/','title',title);
ncwriteatt(ncfilename,'/','units',var_units);
ncwriteatt(ncfilename,'/','creator',creator);
ncwriteatt(ncfilename,'/','activity',activity);
ncwriteatt(ncfilename,'/','comments',comments);




