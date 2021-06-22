clear all, close all, clc

% plots Figure 9.34 of AR6 CH9, i.e., the 2050 and 2100 amplification factors which are the output of the FACTS ESL module.

% note that controlling the colorbar through IPCC_Plot_Map.m is a little
% awkward, so I hardcoded the colorbar ticks and ticklabels and center the
% colorbar by hand before saving the figure.

%THJ Hermans created: 07-01-2020; last edited: 10-12-2020

in_path = '/Users/thermans/Documents/IPCC_AR6/FACTS/development/ESL/esl_facts/output/run_20200103'
in_path = '../data/'

%% load amplification factors
%2050
%af_ssp126_2050 = importdata(fullfile(in_path,'facts_esl_af_allow_total_ssp126ssp1_localsl_2050.txt'));
af_ssp126_2050 = importdata(fullfile(in_path,'facts_esl_af_allow_ssp126_2050.txt'));
 
af_ssp126_2050.lon = af_ssp126_2050.data(:,1);
af_ssp126_2050.lat = af_ssp126_2050.data(:,2);
af_ssp126_2050.af50 = af_ssp126_2050.data(:,11);
 
%af_ssp245_2050 = importdata(fullfile(in_path,'facts_esl_af_allow_total_ssp245ssp2_localsl_2050.txt'));
af_ssp245_2050 = importdata(fullfile(in_path,'facts_esl_af_allow_ssp245_2050.txt'));

af_ssp245_2050.lon = af_ssp245_2050.data(:,1);
af_ssp245_2050.lat = af_ssp245_2050.data(:,2);
af_ssp245_2050.af50 = af_ssp245_2050.data(:,11);
 
%af_ssp585_2050 = importdata(fullfile(in_path,'facts_esl_af_allow_total_ssp585ssp5_localsl_2050.txt'));
af_ssp585_2050 = importdata(fullfile(in_path,'facts_esl_af_allow_ssp585_2050.txt'));

af_ssp585_2050.lon = af_ssp585_2050.data(:,1);
af_ssp585_2050.lat = af_ssp585_2050.data(:,2);
af_ssp585_2050.af50 = af_ssp585_2050.data(:,11);

%2100
%af_ssp126_2100 = importdata(fullfile(in_path,'facts_esl_af_allow_total_ssp126ssp1_localsl_2100.txt'));
af_ssp126_2100 = importdata(fullfile(in_path,'facts_esl_af_allow_ssp126_2100.txt'));

af_ssp126_2100.lon = af_ssp126_2100.data(:,1);
af_ssp126_2100.lat = af_ssp126_2100.data(:,2);
af_ssp126_2100.af50 = af_ssp126_2100.data(:,11);

%af_ssp245_2100 = importdata(fullfile(in_path,'facts_esl_af_allow_total_ssp245ssp2_localsl_2100.txt'));
af_ssp245_2100 = importdata(fullfile(in_path,'facts_esl_af_allow_ssp245_2100.txt'));

af_ssp245_2100.lon = af_ssp245_2100.data(:,1);
af_ssp245_2100.lat = af_ssp245_2100.data(:,2);
af_ssp245_2100.af50 = af_ssp245_2100.data(:,11);

%af_ssp585_2100 = importdata(fullfile(in_path,'facts_esl_af_allow_total_ssp585ssp5_localsl_2100.txt'));
af_ssp585_2100 = importdata(fullfile(in_path,'facts_esl_af_allow_ssp585_2100.txt'));

af_ssp585_2100.lon = af_ssp585_2100.data(:,1);
af_ssp585_2100.lat = af_ssp585_2100.data(:,2);
af_ssp585_2100.af50 = af_ssp585_2100.data(:,11);

%% plot figure 9.34
fontsize = 18;

%generate grid
lon = linspace(0,359,360);
lat = linspace(-90,90,181);
[LON,LAT]=meshgrid(lon,lat);

dummy_data = nan*LON';

%load colorbar (%Note: IPCC_Get_Colorbar_2016a.m replaces 'contains' with 'strcmp' in IPCC_Get_Colorbar.m, because 'contains' does not work for MATLAB 2016a)
color_bar = IPCC_Get_Colorbar_2016a('sealevel_nd', 21, true);

%set colorbar limits
lim_max = 100;%[-] should be set to correspond to the colorbar ticks hardcoded in IPCC_Plot_Map_9_34.m
lim_min = 0;%[-]

%plot figure
ax=figure

%Note: I've highjacked IPCC_Plot_Map.m (using IPCC_Plot_Map_9_34.m instead) since I
%needed to change the last ticklabel to '>100' from '100'. I didn't see an
%easy way to fetch the colorbar object, it's a bit awkward

%2050 panels
%SSP126
IPCC_Plot_Map_9_34(dummy_data',LAT,LON,[lim_min lim_max], ...
    color_bar,'SSP126',[3,2,5],fontsize, false,'Amplifiation Factor [-]'); hold on;
scatterm(af_ssp126_2050.lat,af_ssp126_2050.lon,40,af_ssp126_2050.af50,'filled','markeredgecolor','k'); hold on;
set(gca,'Position',[0.05 0.1 .45 0.3]);
 
%SSP245
IPCC_Plot_Map_9_34(dummy_data',LAT,LON,[lim_min lim_max], ...
    color_bar,'SSP245',[3,2,3],fontsize, false,''); hold on;
scatterm(af_ssp245_2050.lat,af_ssp245_2050.lon,40,af_ssp245_2050.af50,'filled','markeredgecolor','k'); hold on;
set(gca,'Position',[0.05 0.38 .45 0.3]);
 
%SSP585
IPCC_Plot_Map_9_34(dummy_data',LAT,LON,[lim_min lim_max], ...
    color_bar,'SSP585',[3,2,1],fontsize, false,''); hold on;
scatterm(af_ssp585_2050.lat,af_ssp585_2050.lon,40,af_ssp585_2050.af50,'filled','markeredgecolor','k'); hold on;
set(gca,'Position',[0.05 0.66 .45 0.3]);

%2100 panels
%SSP126
IPCC_Plot_Map_9_34(dummy_data',LAT,LON,[lim_min lim_max], ...
    color_bar,'SSP126',[3,2,6],fontsize, true,'Amplification Factor [-]'); hold on;
scatterm(af_ssp126_2100.lat,af_ssp126_2100.lon,40,af_ssp126_2100.af50,'filled','markeredgecolor','k'); hold on;
set(gca,'Position',[0.50 0.1 .45 0.3]);

%SSP245
IPCC_Plot_Map_9_34(dummy_data',LAT,LON,[lim_min lim_max], ...
    color_bar,'SSP245',[3,2,4],fontsize, false,''); hold on;
scatterm(af_ssp245_2100.lat,af_ssp245_2100.lon,40,af_ssp245_2100.af50,'filled','markeredgecolor','k'); hold on;
set(gca,'Position',[0.50 0.38 .45 0.3]);

%SSP585
IPCC_Plot_Map_9_34(dummy_data',LAT,LON,[lim_min lim_max], ...
    color_bar,'SSP585',[3,2,2],fontsize, false,''); hold on;
scatterm(af_ssp585_2100.lat,af_ssp585_2100.lon,40,af_ssp585_2100.af50,'filled','markeredgecolor','k'); hold on;
set(gca,'Position',[0.50 0.66 .45 0.3]);

set(gcf,'color','white'); %set background color
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, .5, 0.85]);