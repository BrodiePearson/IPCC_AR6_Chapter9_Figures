%% IPCC AR6 Chapter 9: Figure 9.4 (Surface Flux maps)
%
% Code used to process CMIP6 flux data from historical and SSP experiments
% and plot this processed data. MUST HAVE CMIP6 MODEL DATA 
% (modify data_path to direct to the data)
%
% Written by Brodie Pearson 

clear all

fontsize = 20;

data_path = '/Volumes/PromiseDisk/AR6_Data/';

addpath ../../../Functions/

% Define reference period for 'present-day' maps
ref_start_yr = 1995;
ref_end_yr = 2014;

change_color_bar = IPCC_Get_Colorbar('misc_d', 21, false);
wfo_color_bar = IPCC_Get_Colorbar('precip_d', 21, false);
heat_flux_color_bar = IPCC_Get_Colorbar('temperature_d', 21, false);
tau_color_bar = IPCC_Get_Colorbar('wind_nd', 21, true);

wfo_max = 250;
wfo_min= -wfo_max;
heat_flux_max = 300;
heat_flux_min = -heat_flux_max;
tau_max = 0.25;
tau_min = 0;
wfo_change_max = 35;
wfo_change_min= -wfo_change_max;
heat_flux_change_max = 10;
heat_flux_change_min = -heat_flux_change_max;
tau_change_max = 0.025;
tau_change_min = -tau_change_max;


%%

load(data_path+"Flux_Obs/Fig2a_mean_data.mat");

%%

plot_var3 = mean_pme(1:4:end,1:4:end)';
plot_var3 = [plot_var3'; plot_var3(:,1)'];

IPCC_Plot_Map(plot_var3',LAT(1,1:4:end)',[LON(1,1:4:end)'; LON(1,1)'],[wfo_min wfo_max], ...
    wfo_color_bar,"Observed Freshwater Flux ("+ref_start_yr+"-"+ref_end_yr+")",...
    1,fontsize, true, 'cm yr^{-1}')

print(gcf,'../PNGs/Freshwater_flux_climatology_colorbar_New.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Freshwater_flux_climatology_New.png','-dpng','-r1000', '-painters');
close(1)

ncfilename = '../Plotted_Data/Fig9-4a_data.nc';
var_name = 'wfo';
var_units = 'centimeters per year';
title = "Freshwater flux into the ocean; climatology from 1995-2014"+ ...
    " using observations";
comments = "Data is for panel (a) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var3', ...
    LAT(1,1:4:end)', [LON(1,1:4:end)'; LON(1,1)'], title, comments)

%%

%color_bar = IPCC_Get_Colorbar('temperature_d', 21, false);

plot_var3 = mean_qnet(1:4:end,1:4:end)';
plot_var3 = [plot_var3'; plot_var3(:,1)'];

IPCC_Plot_Map(plot_var3',LAT(1,1:4:end)',[LON(1,1:4:end)'; LON(1,1)'],[heat_flux_min heat_flux_max], ...
    heat_flux_color_bar,"Observed Flux ("+ref_start_yr+"-"+ref_end_yr+")",...
    2,fontsize, true, 'W m^{-2}')

print(gcf,'../PNGs/Net_heat_flux_climatology_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Net_heat_flux_climatology.png','-dpng','-r1000', '-painters');
close(2)

ncfilename = '../Plotted_Data/Fig9-4d_data.nc';
var_name = 'hfds';
var_units = 'Watts per square meter';
title = "Net Heat Flux into the ocean; climatology from 1995-2014"+ ...
    " using observations";
comments = "Data is for panel (d) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var3', ...
    LAT(1,1:4:end)', [LON(1,1:4:end)'; LON(1,1)'], title, comments)

%%

plot_var3 = mean_wind(1:4:end,1:4:end)';
plot_var3 = [plot_var3'; plot_var3(:,1)'];

IPCC_Plot_Map(plot_var3',LAT(1,1:4:end)',[LON(1,1:4:end)'; LON(1,1)'],[tau_min tau_max], ...
    tau_color_bar,"Observed Wind Stress ("+ref_start_yr+"-"+...
    ref_end_yr+")",...
    3,fontsize, true, 'N m^{-2}')

gap=100;
quiver_lat=LAT(1:gap/5:end)';
quiver_lon=LON(1:gap:end)';
quiver_tauu=mean_wind_zonal(1:gap:end,1:gap/5:end);
quiver_tauv=mean_wind_meridional(1:gap:end,1:gap/5:end);

norm_tauu=quiver_tauu;
norm_tauv=quiver_tauv;

[new_lat,new_lon]=meshgrid(quiver_lat,quiver_lon);

quiverm(new_lat,new_lon,100*norm_tauv,100*norm_tauu,'k')

print(gcf,'../PNGs/Wind_stress_climatology_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Wind_stress_climatology.png','-dpng','-r1000', '-painters');
close(3)

ncfilename = '../Plotted_Data/Fig9-4g_data.nc';
var_name = 'tau';
var_units = 'Newtons per square meter';
title = "Surface wind stress magnitude; climatology from 1995-2014"+ ...
    " using observations";
comments = "Data is for panel (g) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var3', ...
    LAT(1,1:4:end)', [LON(1,1:4:end)'; LON(1,1)'], title, comments)

ncfilename = '../Plotted_Data/Fig9-4g_data_tauu.nc';
var_name = 'tauu';
var_units = 'Newtons per square meter';
title = "x-oriented component of the wind stress vector; climatology from 1995-2014"+ ...
    " using observations";
comments = "Data is for panel (g) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, norm_tauu, ...
    new_lat(:,1), new_lon(1,1:end)', title, comments)

ncfilename = '../Plotted_Data/Fig9-4g_data_tauv.nc';
var_name = 'tauv';
var_units = 'Newtons per square meter';
title = "y-oriented component of the wind stress vector; climatology from 1995-2014"+ ...
    " using observations";
comments = "Data is for panel (g) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, norm_tauv, ...
    new_lat(:,1), new_lon(1,1:end)', title, comments)


%%

load(data_path+"Flux_Obs/Fig2b_trend_data_CI66.mat");
load(data_path+"Flux_Obs/Fig1_timeseries_data.mat");

%%

plot_var3 = trend_pme(1:4:end,1:4:end)';
plot_var3 = [plot_var3'; plot_var3(:,1)'];

IPCC_Plot_Map(plot_var3',LAT(1,1:4:end)',[LON(1,1:4:end)'; LON(1,1)'],[wfo_change_min wfo_change_max], ...
    change_color_bar,"Observed Trend ("+ref_start_yr+"-"+ref_end_yr+")",...
    1,fontsize, true,'cm yr^{-1} (10 yr)^{-1}') 

hatch = pvalue_pme(1:4:end,1:4:end);
latitude = LAT(1,1:4:end)';
longitude = LON(1,1:4:end)';
hatch(abs(hatch)>0.6) = 1;
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','none'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',4, ...
    'marker','x');

print(gcf,'../PNGs/Freshwater_flux_observed_trend_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Freshwater_flux_observed_trend.png','-dpng','-r1000', '-painters');

hatch(hatch==0)=3;
contourm(latitude,longitude,hatch',[3 3],'Fill','on','LineColor','none'); %
hatch(hatch==3)=0;
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',4, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/Freshwater_flux_observed_trend_Hatch_check.png','-dpng','-r100', '-painters');
close(1);

ncfilename = '../Plotted_Data/Fig9-4b_data.nc';
var_name = 'wfo_trend';
var_units = 'centimeters per year per decade';
title = "Observed trend in freshwater flux; across the period 1995-2014";
comments = "Data is for panel (b) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var3', ...
    LAT(1,1:4:end)', [LON(1,1:4:end)'; LON(1,1)'], title, comments, hatching_mask')


%%

plot_var3 = trend_qnet(1:4:end,1:4:end)';
plot_var3 = [plot_var3'; plot_var3(:,1)'];

IPCC_Plot_Map(plot_var3',LAT(1,1:4:end)',[LON(1,1:4:end)'; LON(1,1)'],[-35 35], ...
    change_color_bar,"Observed Trend ("+ref_start_yr+"-"+ref_end_yr+")",...
    4,fontsize, true, 'W m^{-2} (10 yr)^{-1}')

hatch = pvalue_qnet(1:4:end,1:4:end);
latitude = LAT(1,1:4:end)';
longitude = LON(1,1:4:end)';
hatch(abs(hatch)>0.6) = 1;
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','none'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',4, ...
    'marker','x');

print(gcf,'../PNGs/Net_heat_flux_observed_trend_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Net_heat_flux_observed_trend.png','-dpng','-r1000', '-painters');

hatch(hatch==0)=3;
contourm(latitude,longitude,hatch',[3 3],'Fill','on','LineColor','none'); %
hatch(hatch==3)=0;
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',4, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/Net_heat_flux_observed_trend_Hatch_check.png','-dpng','-r100', '-painters');
close(4);

ncfilename = '../Plotted_Data/Fig9-4e_data.nc';
var_name = 'hfds_trend';
var_units = 'centimeters per year per decade';
title = "Observed trend in surface heat flux; across the period 1995-2014";
comments = "Data is for panel (e) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var3', ...
    LAT(1,1:4:end)', [LON(1,1:4:end)'; LON(1,1)'], title, comments, hatching_mask')

%%

color_bar = IPCC_Get_Colorbar('misc_d', 21, false);

plot_var3 = trend_wind(1:4:end,1:4:end)';
plot_var3 = [plot_var3'; plot_var3(:,1)'];

IPCC_Plot_Map(1e2*plot_var3',LAT(1,1:4:end)',[LON(1,1:4:end)'; LON(1,1)'],1e2*[tau_change_min tau_change_max], ...
    change_color_bar,"Observed Trend ("+ref_start_yr+"-"+ref_end_yr+")",...
    6,fontsize, true, '10^{-2} N m^{-2} (10 yr)^{-1}')

hatch = pvalue_wind(1:4:end,1:4:end);
latitude = LAT(1,1:4:end)';
longitude = LON(1,1:4:end)';
hatch(abs(hatch)>0.6) = 1;
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','none'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',4, ...
    'marker','x');

print(gcf,'../PNGs/Wind_stress_observed_trend_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Wind_stress_flux_observed_trend.png','-dpng','-r1000', '-painters');

hatch(hatch==0)=3;
contourm(latitude,longitude,hatch',[3 3],'Fill','on','LineColor','none'); %
hatch(hatch==3)=0;
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',4, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/Wind_stress_flux_observed_trend_Hatch_check.png','-dpng','-r100', '-painters');
close(6);

ncfilename = '../Plotted_Data/Fig9-4h_data.nc';
var_name = 'tau_trend';
var_units = 'Newtons per meter squared per decade';
title = "Observed trend in surface wind stress magnitude; across the period 1995-2014";
comments = "Data is for panel (h) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var3', ...
    LAT(1,1:4:end)', [LON(1,1:4:end)'; LON(1,1)'], title, comments, hatching_mask')

%% Calculate rate of change of freshwater flux

hist_start_year = {'1995'};
hist_end_year = {'2014'};
ssp_start_year = {'2081'};
ssp_end_year = {'2100'};
data_path = '/Volumes/PromiseDisk/AR6_Data/wfo/';
var_name = 'wfo';

ssp585_model_names = IPCC_Which_Models(data_path,{'ssp585'},'CMIP6_','_');

% This model doesn't have data
ssp585_model_names(contains(ssp585_model_names,'MRI-ESM2-0'))=[];
% Some models also have the wrong sign flux, this is corrected later

[ssp585_wfo, lat, lon] = IPCC_CMIP6_Load({'ssp585'}, ...
    var_name, ssp585_model_names, data_path, ssp_start_year, ssp_end_year);

[historical_wfo, lat, lon] = IPCC_CMIP6_Load({'historical'}, ...
    var_name, ssp585_model_names, data_path, hist_start_year, hist_end_year);

IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-4c_md.csv', 'c', true)

% Convert freshwater flux from units of kg m^{-2} s^{-1} decade^{-1} to
% cm/yr (decade)^{-1} for consistency with the observations above
% conversion factor is to divide by density of water and multiply by the
% number of seconds in a year and 100 (tn convert m to cm)
hist_wfo = historical_wfo * (60*60*24*365) * 100 / 1000;
ssp_wfo = ssp585_wfo * (60*60*24*365) * 100 / 1000;

% Some models have incorrect sign (Incuding EC-Earth3 and EC-Earth3-Veg)
figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(hist_wfo(:,:,ii))');
    colormap(wfo_color_bar)
    colorbar
    caxis([wfo_min wfo_max])
    %title(char(ssp585_model_names(ii)));
end
print(gcf,'../PNGs/Test_Maps/Historical_WFO_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(ssp_wfo(:,:,ii))');
    colormap(wfo_color_bar)
    colorbar
    caxis([wfo_min wfo_max])
    %title(char(ssp585_model_names(ii)))
end
print(gcf,'../PNGs/Test_Maps/SSPs_WFO_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   if contains(ssp585_model_names(ii),'CNRM-CM6-1') || ...
           contains(ssp585_model_names(ii),'CNRM-ESM2-1') || ...
           contains(ssp585_model_names(ii),'EC-Earth3') || ...
           contains(ssp585_model_names(ii),'IPSL-CM6A-LR')
       ssp_wfo(:,:,ii) = -ssp_wfo(:,:,ii);
       hist_wfo(:,:,ii) = -hist_wfo(:,:,ii);
   end
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(hist_wfo(:,:,ii))');
    colormap(wfo_color_bar)
    colorbar
    caxis([wfo_min wfo_max])
    %title(char(ssp585_model_names(ii)))
end

print(gcf,'../PNGs/Test_Maps/Historical_WFO_Maps_Corrected.png','-dpng','-r100', '-painters');
close(1)

%% Plot projected freshwater flux rates of change

% calculate a rate [units of cm/yr decade^{-1}
wfo_rate_of_change = 10*(ssp_wfo - hist_wfo)/ ...
    (str2num(ssp_end_year{1}) - str2num(hist_end_year{1}));

plot_var6 = nanmean(wfo_rate_of_change,3);
plot_var6 = [plot_var6; plot_var6(1,:)];
IPCC_Plot_Map(plot_var6',lat,[lon; lon(1)],[wfo_change_min wfo_change_max]/3, ...
    change_color_bar,"",8,fontsize, true,'cm yr^{-1} (10 yr)^{-1}')

hatch = abs(sum(sign(wfo_rate_of_change),3))/size(wfo_rate_of_change,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hatch(180,70:90)=1; hatch(205,90:140)=1; hatch(340,1:60)=1;
hold on
[c1, h1]=contourm(latitude,longitude,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);

print(gcf,'../PNGs/Freshwater_Flux_projected_change_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Freshwater_Flux_projected_change.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/Freshwater_Flux_projected_change_Hatch_check.png','-dpng','-r100', '-painters');
close(8);

ncfilename = '../Plotted_Data/Fig9-4c_data.nc';
var_name = 'wfo_trend';
var_units = 'centimeters per year per decade';
title = "Projected trend in freshwater flux, across the period 1995-2100"+...
    "using SSP5-8.5 of CMIP6 (ScenarioMIP & CMIP)";
comments = "Data is for panel (c) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var6', ...
    lat, [lon; lon(1)], title, comments, hatching_mask')



%% Calculate rate of change of wind stress magnitude

data_path = '/Volumes/PromiseDisk/AR6_Data/tauvo/';
ssp585_model_names = IPCC_Which_Models(data_path,{'ssp585'},'CMIP6_','_');

% This model doesn't have data
ssp585_model_names(contains(ssp585_model_names,'MRI-ESM2-0'))=[];

% This model doesn't have tauuo data (file is empty)
ssp585_model_names(contains(ssp585_model_names,'MPI-ESM1-2-LR'))=[];

IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-4i_md_tauvo.csv', 'i', true)

[ssp585_tauvo, lat, lon] = IPCC_CMIP6_Load({'ssp585'}, ...
    'tauvo', ssp585_model_names, data_path, ssp_start_year, ssp_end_year);
[historical_tauvo, lat, lon] = IPCC_CMIP6_Load({'historical'}, ...
    'tauvo', ssp585_model_names, data_path, hist_start_year, hist_end_year);

data_path = '/Volumes/PromiseDisk/AR6_Data/tauuo/';
[ssp585_tauuo, lat, lon] = IPCC_CMIP6_Load({'ssp585'}, ...
    'tauuo', ssp585_model_names, data_path, ssp_start_year, ssp_end_year);
[historical_tauuo, lat, lon] = IPCC_CMIP6_Load({'historical'}, ...
    'tauuo', ssp585_model_names, data_path, hist_start_year, hist_end_year);

IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-4i_md_tauuo.csv', 'i', true)

ssp585_tau = sqrt(ssp585_tauuo.^2 + ssp585_tauvo.^2);
historical_tau = sqrt(historical_tauuo.^2 + historical_tauvo.^2);

% Check models against eachother 
figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(historical_tau(:,:,ii))');
    colormap(tau_color_bar)
    colorbar
    caxis([tau_min tau_max])
%    title(char(ssp585_model_names(ii)))
end
print(gcf,'../PNGs/Test_Maps/Historical_TAU_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)
% Check models against eachother 
figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(historical_tauvo(:,:,ii))');
    colormap(tau_color_bar)
    colorbar
    caxis([tau_min tau_max])
%    title(char(ssp585_model_names(ii)))
end
print(gcf,'../PNGs/Test_Maps/Historical_TAUV_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)
% Check models against eachother 
figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(historical_tauuo(:,:,ii))');
    colormap(tau_color_bar)
    colorbar
    caxis([tau_min tau_max])
%    title(char(ssp585_model_names(ii)))
end
print(gcf,'../PNGs/Test_Maps/Historical_TAUU_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(ssp585_tau(:,:,ii))');
    colormap(tau_color_bar)
    colorbar
    caxis([tau_min tau_max])
    %title(char(ssp585_model_names(ii)))
end
print(gcf,'../PNGs/Test_Maps/SSPs_TAU_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(historical_tau(:,:,ii))');
    colormap(tau_color_bar)
    colorbar
    caxis([tau_min tau_max])
    %title(char(ssp585_model_names(ii)))
end

print(gcf,'../PNGs/Test_Maps/Historical_TAU_Maps_Corrected.png','-dpng','-r100', '-painters');
close(1)


%% Plot wind stress rate of change

% units of N m^{-2} decade^{-1}
tau_rate_of_change = 10*(ssp585_tau - historical_tau)/ ...
    (str2num(ssp_end_year{1}) - str2num(hist_end_year{1}));

plot_var6 = nanmean(tau_rate_of_change,3);
plot_var6 = [plot_var6; plot_var6(1,:)];
IPCC_Plot_Map(1e2*plot_var6',lat,[lon; lon(1)],1e2*[tau_change_min tau_change_max]/5, ...
    change_color_bar,"Rate of change (SSP5-8.5; "+str2num(hist_start_year{1})+...
    "-"+str2num(ssp_end_year{1})+")",...
    8,fontsize, true, '10^{-2} N m^{-2} (10 yr)^{-1}')

hatch = abs(sum(sign(tau_rate_of_change),3))/size(tau_rate_of_change,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hold on
[c1, h1]=contourm(latitude,longitude,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);

print(gcf,'../PNGs/Wind_stress_projected_change_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Wind_stress_projected_change.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/Wind_stress_projected_change_Hatch_check.png','-dpng','-r100', '-painters');
close(8);

ncfilename = '../Plotted_Data/Fig9-4i_data.nc';
var_name = 'tau_trend';
var_units = 'Newtons per square meter per decade';
title = "Projected trend in surface wind stress magnitude, across the period 1995-2100"+...
    "using SSP5-8.5 of CMIP6 (ScenarioMIP & CMIP)";
comments = "Data is for panel (i) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var6', ...
    lat, [lon; lon(1)], title, comments, hatching_mask')



%% Calculate rate of change of net heat flux

data_path = '/Volumes/PromiseDisk/AR6_Data/hfds/';

ssp585_model_names = IPCC_Which_Models(data_path,{'ssp585'},'CMIP6_','_');

% This model doesn't have data
ssp585_model_names(contains(ssp585_model_names,'MRI-ESM2-0'))=[];

[ssp585_hfds, lat, lon] = IPCC_CMIP6_Load({'ssp585'}, ...
    'hfds', ssp585_model_names, data_path, ssp_start_year, ssp_end_year);

[historical_hfds, lat, lon] = IPCC_CMIP6_Load({'historical'}, ...
    'hfds', ssp585_model_names, data_path, hist_start_year, hist_end_year);

IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Plotted_Data/CMIP6_metadata/Fig9-4f_md.csv', 'f', true)

% Check models against eachother 
figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(historical_hfds(:,:,ii))');
    colormap(heat_flux_color_bar)
    colorbar
    caxis([heat_flux_min heat_flux_max])
%    title(char(ssp585_model_names(ii)))
end
print(gcf,'../PNGs/Test_Maps/Historical_HFDS_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(ssp585_hfds(:,:,ii))');
    colormap(heat_flux_color_bar)
    colorbar
    caxis([heat_flux_min heat_flux_max])
%    title(char(ssp585_model_names(ii)))
end
print(gcf,'../PNGs/Test_Maps/SSPs_HFDS_Maps_Raw.png','-dpng','-r100', '-painters');
close(1)

figure('Position', [10 10 1200 1200])
for ii=1:size(ssp585_model_names,2)
   subplot(ceil(sqrt(size(ssp585_model_names,2))), ...
        ceil(sqrt(size(ssp585_model_names,2))), ii);
    imagesc(lon,lat,fliplr(historical_hfds(:,:,ii))');
    colormap(heat_flux_color_bar)
    colorbar
    caxis([heat_flux_min heat_flux_max])
%    title(char(ssp585_model_names(ii)))
end

print(gcf,'../PNGs/Test_Maps/Historical_HFDS_Maps_Corrected.png','-dpng','-r100', '-painters');
close(1)

%% Plot projected rate of change of surface heat flux

% units of W m^{-2} decade^{-1}
hfds_rate_of_change = 10*(ssp585_hfds - historical_hfds)/ ...
    (str2num(ssp_end_year{1}) - str2num(hist_end_year{1}));

plot_var6 = nanmean(hfds_rate_of_change,3);
plot_var6 = [plot_var6; plot_var6(1,:)];
IPCC_Plot_Map(plot_var6',lat,[lon; lon(1)],[heat_flux_change_min heat_flux_change_max]/2, ...
    change_color_bar,"Rate of change (SSP5-8.5; "+str2num(hist_start_year{1})+...
    "-"+str2num(ssp_end_year{1})+")",...
    8,fontsize, true, 'W m^{-2} (10 yr)^{-1}')

hatch = abs(sum(sign(hfds_rate_of_change),3))/size(hfds_rate_of_change,3);
hatch=[hatch; hatch(1,:)];
latitude = lat;
longitude = [lon; lon(1)];
hatch(abs(hatch)>0.6) = 1; % 80% of models agree on sign
hatch(abs(hatch)<0.6) = 3;
hatch(isnan(hatch)) = 2;
hatching_mask = hatch(1:end-1,:); hatching_mask(hatching_mask~=1)=0; 
hatch(185,85:90)=1; hatch(195,90:140)=1; hatch(315,90:120)=1; hatch(1,20:60)=1;
hatch(240,90:120)=1;
hold on
[c1, h1]=contourm(latitude,longitude,hatch',[3 3],'Fill','off','LineColor','none'); %

for ii=1:size(c1,2)
        if c1(1,ii)==0 || c1(1,ii)==3
            c1(1,ii)=NaN(1);
            c1(2,ii)=NaN(1);
        end
    end
h=patchm(c1(2,:),c1(1,:),'r','FaceAlpha',0,'Linestyle','none');
hatchfill2(h,'single','HatchAngle',45,'LineWidth',0.001);

print(gcf,'../PNGs/Net_heat_Flux_projected_change_colorbar.png','-dpng','-r1000', '-painters');
title('')
colorbar off
print(gcf,'../PNGs/Net_heat_Flux_projected_change.png','-dpng','-r1000', '-painters');

contourm(latitude',longitude',hatch',[3 3],'Fill','off','LineColor','k'); %
hatch(hatch==3)=0;
[lat_temp,lon_temp] = meshgrid(latitude',longitude');
stipplem(lat_temp,lon_temp,~logical(hatch),'color','k','markersize',2, ...
    'marker','x');

print(gcf,'../PNGs/Test_Maps/Net_heat_Flux_projected_change_Hatch_check.png','-dpng','-r100', '-painters');
close(8)

ncfilename = '../Plotted_Data/Fig9-4f_data.nc';
var_name = 'hfds_trend';
var_units = 'Newtons per square meter per decade';
title = "Projected trend in surface heat flux, across the period 1995-2100"+...
    "using SSP5-8.5 of CMIP6 (ScenarioMIP & CMIP)";
comments = "Data is for panel (f) of Figure 9.4 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

IPCC_Write_NetCDF_Map(ncfilename, var_name, var_units, plot_var6', ...
    lat, [lon; lon(1)], title, comments, hatching_mask')

