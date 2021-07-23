%% Code to process CMIP5 data from Bronselaer and Zanna
% Baylor Fox-Kemper, 2020
% Info on these files.
% They were downloaded by Baylor Fox-Kemper on Nov 24, 2020 from 
% https://zenodo.org/record/3981292#.X7wJhi2cZTa


clear all
clf

hist_change_start_year = 1972;  % 1951 is the actual baseline in the data, others can be used after 1970
hist_change_end_year = 2011;
RCP_change_start_year = 2021;
RCP_change_end_year = 2060;
%HRSSP_change_end_year = 2050;

addpath ../../../Functions/

% Units of various H are
% GJ/m^2 of linear change in 0-2000m heat content since 1951

fname='./Data/H_total_CMIP5.nc'
readncfile
CMIP_t=time;
CMIP_H=H_total;

fname='./Data/H_redis_CMIP5.nc'
readncfile
CMIP_Hr=H_redis;

fname='./Data/H_added_CMIP5.nc'
readncfile
CMIP_Ha=H_added;

fname='./Data/H_total_Obs.nc'
readncfile
Obs_t=time;
Obs_H=H_total;

fname='./Data/H_redis_Obs.nc'
readncfile
Obs_Hr=H_redis;

fname='./Data/H_added_Obs.nc'
readncfile
Obs_Ha=H_added;

hist_change_start_ndx = find(CMIP_t==hist_change_start_year);
hist_change_end_ndx = find(CMIP_t==hist_change_end_year);
RCP_change_start_ndx = find(CMIP_t==RCP_change_start_year);
RCP_change_end_ndx = find(CMIP_t==RCP_change_end_year);
Obs_change_start_ndx = find(Obs_t==hist_change_start_year);
Obs_change_end_ndx = find(Obs_t==hist_change_end_year);

if hist_change_start_year>1970
 hist_H=CMIP_H(:,:,hist_change_end_ndx)-CMIP_H(:,:,hist_change_start_ndx);
 hist_Hr=CMIP_Hr(:,:,hist_change_end_ndx)-CMIP_Hr(:,:,hist_change_start_ndx);
 hist_Ha=CMIP_Ha(:,:,hist_change_end_ndx)-CMIP_Ha(:,:,hist_change_start_ndx);
elseif hist_change_start_year==1951
 hist_H=CMIP_H(:,:,Obs_change_end_ndx);
 hist_Hr=CMIP_Hr(:,:,Obs_change_end_ndx);
 hist_Ha=CMIP_Ha(:,:,Obs_change_end_ndx);  
end

RCP_H=CMIP_H(:,:,RCP_change_end_ndx)-CMIP_H(:,:,RCP_change_start_ndx);
RCP_Hr=CMIP_Hr(:,:,RCP_change_end_ndx)-CMIP_Hr(:,:,RCP_change_start_ndx);
RCP_Ha=CMIP_Ha(:,:,RCP_change_end_ndx)-CMIP_Ha(:,:,RCP_change_start_ndx);

if hist_change_start_year>1970
 % This is used for different baselines later than 1970
 Obs_H=Obs_H(:,:,Obs_change_end_ndx)-Obs_H(:,:,Obs_change_start_ndx);
 Obs_Hr=Obs_Hr(:,:,Obs_change_end_ndx)-Obs_Hr(:,:,Obs_change_start_ndx);
 Obs_Ha=Obs_Ha(:,:,Obs_change_end_ndx)-Obs_Ha(:,:,Obs_change_start_ndx);
elseif hist_change_start_year==1951
 Obs_H=Obs_H(:,:,Obs_change_end_ndx);
 Obs_Hr=Obs_Hr(:,:,Obs_change_end_ndx);
 Obs_Ha=Obs_Ha(:,:,Obs_change_end_ndx);  
end


% Fix dateline issue, convert units to W/m^2
lon(lon < 0)=lon(lon < 0)+ 360;
lon=[(lon(end)-360);lon];
lon(end+1)=lon(2)+360;

Obs_H=[Obs_H(end,:);Obs_H];
Obs_H(end+1,:)=Obs_H(2,:)./1e9/86400/365/40;
Obs_Ha=[Obs_Ha(end,:);Obs_Ha];
Obs_Ha(end+1,:)=Obs_Ha(2,:)./1e9/86400/365/40;
Obs_Hr=[Obs_Hr(end,:);Obs_Hr];
Obs_Hr(end+1,:)=Obs_Hr(2,:)./1e9/86400/365/40;

RCP_H=[RCP_H(end,:);RCP_H];
RCP_H(end+1,:)=RCP_H(2,:)./1e9/86400/365/40;
RCP_Ha=[RCP_Ha(end,:);RCP_Ha];
RCP_Ha(end+1,:)=RCP_Ha(2,:)./1e9/86400/365/40;
RCP_Hr=[RCP_Hr(end,:);RCP_Hr];
RCP_Hr(end+1,:)=RCP_Hr(2,:)./1e9/86400/365/40;

hist_H=[hist_H(end,:);hist_H];
hist_H(end+1,:)=hist_H(2,:)./1e9/86400/365/40;
hist_Ha=[hist_Ha(end,:);hist_Ha];
hist_Ha(end+1,:)=hist_Ha(2,:)./1e9/86400/365/40;
hist_Hr=[hist_Hr(end,:);hist_Hr];
hist_Hr(end+1,:)=hist_Hr(2,:)./1e9/86400/365/40;

%savefile = 'Hf_Maps';
%load(savefile)

fontsize = 20;

%% Plot mean SST averaged over past few decades

color_bar = IPCC_Get_Colorbar('temperature_d', 21, false);

lims = [-10 10];

%% TEST
% BSF_hist_wrapped = [BSF_hist; BSF_hist(1,:,:)]/1e9;
% latitude = lat';
% longitude = [lon'; lon(1)];
% 
% plot_var1 = nanmean(BSF_hist_wrapped,3);
% 
% 
% IPCC_Plot_Map(plot_var1',latitude,longitude,lims, ...
%     color_bar,"CMIP_{"+num2str(count_hist)+" models} BSF [10^9 kg s^{-1}]",...
%     1,fontsize, true, '(10^9 kg s^{-1})')

% RCP_H_wrapped = [RCP_H; RCP_H(1,:,:)];
latitude = lat;
longitude = [lon; lon(1)];

%IPCC_Plot_Map([RCP_H; RCP_H(1,:,:)]',latitude,longitude,lims, ...
%    color_bar,['RCP8.5 Total Warming Rate (',num2str(RCP_change_start_year),'-',num2str(RCP_change_end_year),')'],...
%    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})',[])

%% TOTAL

IPCC_Plot_Map([hist_H; hist_H(1,:,:)]',latitude,longitude,lims, ...
    color_bar,['CMIP5 Total Warming Rate (',num2str(hist_change_start_year),'-',num2str(hist_change_end_year),')'],...
    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})')

print(gcf,'../PNGs/Hist_total_colorbar.png','-dpng','-r1000', '-painters');
%title('')
colorbar off
print(gcf,'../PNGs/Hist_total.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map([RCP_H; RCP_H(1,:,:)]',latitude,longitude,lims, ...
    color_bar,['RCP8.5 Total Warming Rate (',num2str(RCP_change_start_year),'-',num2str(RCP_change_end_year),')'],...
    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})')

colorbar off
print(gcf,'../PNGs/RCP_total.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map([Obs_H; Obs_H(1,:,:)]',latitude,longitude,lims, ...
    color_bar,['Observed Total Warming Rate (',num2str(hist_change_start_year),'-',num2str(hist_change_end_year),')'],...
    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})')

colorbar off
print(gcf,'../PNGs/Obs_total.png','-dpng','-r1000', '-painters');
close(1);

%% Added

IPCC_Plot_Map([hist_Ha; hist_Ha(1,:,:)]',latitude,longitude,lims, ...
    color_bar,['CMIP5 Added Warming Rate (',num2str(hist_change_start_year),'-',num2str(hist_change_end_year),')'],...
    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})')

colorbar off
print(gcf,'../PNGs/Hist_added.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map([RCP_Ha; RCP_Ha(1,:,:)]',latitude,longitude,lims, ...
    color_bar,['RCP8.5 Added Warming Rate (',num2str(RCP_change_start_year),'-',num2str(RCP_change_end_year),')'],...
    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})')

colorbar off
print(gcf,'../PNGs/RCP_added.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map([Obs_Ha; Obs_Ha(1,:,:)]',latitude,longitude,lims, ...
    color_bar,['Observed Added Warming Rate (',num2str(hist_change_start_year),'-',num2str(hist_change_end_year),')'],...
    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})')

colorbar off
print(gcf,'../PNGs/Obs_added.png','-dpng','-r1000', '-painters');
close(1);

%% Redistributed

IPCC_Plot_Map([hist_Hr; hist_Hr(1,:,:)]',latitude,longitude,lims, ...
    color_bar,['CMIP5 Redistributed Warming Rate (',num2str(hist_change_start_year),'-',num2str(hist_change_end_year),')'],...
    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})')

colorbar off
print(gcf,'../PNGs/Hist_redis.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map([RCP_Hr; RCP_Hr(1,:,:)]',latitude,longitude,lims, ...
    color_bar,['RCP8.5 Redistributed Warming Rate (',num2str(RCP_change_start_year),'-',num2str(RCP_change_end_year),')'],...
    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})')

colorbar off
print(gcf,'../PNGs/RCP_redis.png','-dpng','-r1000', '-painters');
close(1);

IPCC_Plot_Map([Obs_Hr; Obs_Hr(1,:,:)]',latitude,longitude,lims, ...
    color_bar,['Observed Redistributed Warming Rate (',num2str(hist_change_start_year),'-',num2str(hist_change_end_year),')'],...
    1,fontsize, true, 'Ocean Heating Rate (W m^{-2})')

colorbar off
print(gcf,'../PNGs/Obs_redis.png','-dpng','-r1000', '-painters');
close(1);


