%% Code to process CMIP6 data froAm historical and SSP experiments
% This example is for sea surface temperature (SST) - named tos in CMIP6/PMIP
% Baylor Fox-Kemper, 2020

clear all

addpath ../../../Functions/
fontsize=15;

color_OBS = IPCC_Get_SSPColors('Observations');
color_HRMIP = IPCC_Get_SSPColors('HighResMIP');
color_HRSSP = IPCC_Get_SSPColors('HighResMIP');
color_CMIP = IPCC_Get_SSPColors('CMIP');
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

%% Load paleo data and calculate means/stds

dd=dir('./Data/output');

AMOC_LIG=[];
TIME_LIG=[];

AMOC_mHOL=[];
TIME_mHOL=[];

AMOC_pre=[];
TIME_pre=[];

for ff=[4:6]  % have to skip GISS and INM due to missing runs...

AMOC_LIG=[AMOC_LIG;squeeze(ncread(['./Data/output/',dd(ff).name,'/lig127k_amoc.nc'],'AMOC'))'];
TIME_LIG=[TIME_LIG;squeeze(ncread(['./Data/output/',dd(ff).name,'/lig127k_amoc.nc'],'TIME'))'];

AMOC_mHOL=[AMOC_mHOL;squeeze(ncread(['./Data/output/',dd(ff).name,'/midHolocene_amoc.nc'],'AMOC'))'];
TIME_mHOL=[TIME_mHOL;squeeze(ncread(['./Data/output/',dd(ff).name,'/midHolocene_amoc.nc'],'TIME'))'];

AMOC_pre=[AMOC_pre;squeeze(ncread(['Data/output/',dd(ff).name,'/piControl_amoc.nc'],'AMOC'))'];
TIME_pre=[TIME_pre;squeeze(ncread(['Data/output/',dd(ff).name,'/piControl_amoc.nc'],'TIME'))'];

end

AMOC_pre_mn = nanmean(AMOC_pre,2);
AMOC_LIG_mn = nanmean(AMOC_LIG,2)-AMOC_pre_mn; % Anomaly vs. AMOC_pre_mn
AMOC_mHOL_mn = nanmean(AMOC_mHOL,2)-AMOC_pre_mn;

AMOC_LIG_std = nanstd(AMOC_mHOL_mn); % Ensemble St. Dev.
AMOC_mHOL_std = nanstd(AMOC_mHOL_mn);
AMOC_pre_std = nanstd(AMOC_pre_mn);

%% Calculate std/mean bounds for drawing polygon shading for uncertainty
%% Create Figures

figure('Position', [10 10 1200 400])

set(gca,'Box', 'on','Clipping','off')

figure('Position', [10 10 200 450])

subplot(1,100,25:100)
width=3;
plot([1,1], [mean(AMOC_LIG_mn), mean(AMOC_LIG_mn)]/1e9, 'ro-', 'MarkerSize',15) 

hold on
plot([1,1], [mean(AMOC_LIG_mn)-AMOC_LIG_std, mean(AMOC_LIG_mn)+AMOC_LIG_std]/1e9, 'r-', 'LineWidth', width) % LIG
plot([2,2], [mean(AMOC_mHOL_mn)-AMOC_mHOL_std, mean(AMOC_mHOL_mn)+AMOC_mHOL_std]/1e9, 'b-', 'LineWidth', width) % LIG
plot([2,2], [mean(AMOC_mHOL_mn), mean(AMOC_mHOL_mn)]/1e9, 'bo-', 'MarkerSize',15) 

xlim([0.5 2.5])
ylim([-13 4])
ylabel('PMIP AMOC Anomaly (Sv)','FontSize',25)
set(gca,'Xtick',[1 2 3],'Xticklabel',[])
set(gca,'FontSize',20,'Box', 'on')
txt = {'LIG'};
text(1,-2,txt,'FontSize',20, ...
    'Color', 'r', 'FontWeight', 'bold','HorizontalAlignment','center')
txt = {'mHOL'};
text(1.95,-2.6,txt,'FontSize',20, ...
    'Color', 'b', 'FontWeight', 'bold','HorizontalAlignment','center')
%txt = {'pre-I'};
%text(3,-3.2,txt,'FontSize',15, ...
%    'Color', 'k', 'FontWeight', 'bold','HorizontalAlignment','center')

figure('Position', [10 10 200 400])


set(gca,'Box', 'on','Clipping','off')

plot([1,1], [mean(AMOC_LIG_mn), mean(AMOC_LIG_mn)]/1e9, 'o-','MarkerEdgeColor', color_CMIP,'Color', color_CMIP, 'MarkerSize',15, 'LineWidth', width/2) 

hold on
plot([1,1], [mean(AMOC_LIG_mn)-AMOC_LIG_std, mean(AMOC_LIG_mn)+AMOC_LIG_std]/1e9, '-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', 3) % LIG
plot([3,3], [mean(AMOC_mHOL_mn)-AMOC_mHOL_std, mean(AMOC_mHOL_mn)+AMOC_mHOL_std]/1e9, '-','MarkerEdgeColor', color_CMIP,'Color', color_CMIP, 'MarkerSize',15, 'LineWidth', 3) % PMIP
plot([3,3], [mean(AMOC_mHOL_mn), mean(AMOC_mHOL_mn)]/1e9, 'o-','MarkerEdgeColor', color_CMIP, 'MarkerSize',15,'Color', color_CMIP, 'LineWidth', width/2) % PMIP

ylabel('AMOC Anomaly (Sv)','FontSize',28)
set(gca,'Xtick',[1 2 3],'Xticklabel',[])
set(gca,'FontSize',28,'Box', 'on')

xlim([0 4])
plot([0 4], [0 4]*0, 'k', 'LineWidth', width/10)
ylim([-13 4])
set(gca,'Xtick',[1  3],'Xticklabel',[])
set(gca,'Ytick',[-12 -10 -8 -6 -4 -2 0 2 4],'Yticklabel',{'-12','-10','-8','-6','-4','-2','0','2','4'})
set(gca,'FontSize',28,'Box', 'on')
%txt = {'Observations'};
%text(2,2.8,txt,'FontSize',16, ...
%    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','center')
txt = {'PMIP'};
text(2,2.5,txt,'FontSize',24, ...
    'Color', color_CMIP, 'FontWeight', 'bold','HorizontalAlignment','center')
%ylabel('Sv')
%set(get(gca,'YLabel'),'Rotation',0)

%text(0.5,-4.6,{'mPLI'},'FontSize',12, ...
%    'HorizontalAlignment','center', 'Interpreter','latex')
text(0.5,-14,{'LIG'},'FontSize',22, ...
    'HorizontalAlignment','center','FontWeight', 'bold', 'Interpreter','latex')
text(3.0,-14,{'mHOL'},'FontSize',22, ...
    'HorizontalAlignment','center','FontWeight', 'bold', 'Interpreter','latex')

saveas(gcf,'../PNGs/PMIP_AMOC.png')




