%% IPCC AR6 Chapter 9: Figure 9.27 (Sea level scenarios)
%
% Code used to plot pre-processed sea level scenarios 
%
% Plotting code written by Bob Kopp
% Processed data provided by Bob Kopp
% Other datasets cited in report/caption

clear all


addpath ../../../Functions/
addpath ../Functions/

savefile='AR6_GMSL_Models_v3.xlsx'

fontsize=15;
width = 3;
start_year=1950;
end_year=2150;

% Colors updated to match updated SPM colors
color_SSP119 = [0   173  207]/255;
color_SSP126 = [23  60   102]/255;
color_SSP245 = [247 148  32]/255;
color_SSP370 = [231 29   37]/255;
color_SSP585 = [149 27   30]/255;

%%
clear hs;
fig1=figure('Position', [10 10 800 500]);
dw=.6;
hs(1)=subplot(2,2,1);
hs(2)=subplot(2,2,2);
%hs(3)=subplot(2,2,3);
%hs(4)=subplot(2,2,4);

pos=get(hs,'position');
pos0=pos;

dw2=dw-pos{1}(3);
pos{2}(1)=pos{2}(1)+dw2-.09;
pos{2}(3)=pos{2}(3)-dw2;
pos{1}(3)=dw;
%pos{3}(3)=pos{1}(3);
%pos{4}([1 3])=pos{2}([1 3]);
for sss=1:2
    set(hs(sss),'position',pos{sss});
end



%% Load mean total Sea Level projections for SSPs (and 5% 95% quantiles)
time = ncread('data/pbox1e_total_ssp585_globalsl_figuredata.nc','years');
timeb = ncread('data/pbox1f_total_ssp585_globalsl_figuredata.nc','years');
subtb=find(timeb>2120);
timec=[time ; timeb(subtb)];
Time_Conf_Bounds = [timec; flipud(timec); timec(1)];

historicaldata=load('GMSL_observed/gmsl_altimeter+TG_ensemble_28012021.mat');

%historicaldata=importdata('figuredata_210119/Dangendorf2019.txt');
historical.t=historicaldata.merged_time_TG_altim;
historical.y=historicaldata.merged_SL_TG_altim;
historical.dy=historicaldata.merged_error_TG_altim;
subt=find((historical.t>=1995).*(historical.t<=2015));
historical.y=historical.y-mean(historical.y(subt));

historicalextrap.t=2005:end_year;
historicalextrap.accel=0.094;
historicalextrap.accelstd=0.0115*norminv(0.83)/norminv(0.95);
historicalextrap.rate=3.22;
historicalextrap.ratestd=0.365*norminv(0.83)/norminv(0.95);
historicalextrap.y=.5*(historicalextrap.t-2005).^2*historicalextrap.accel + (historicalextrap.t-2005)*historicalextrap.rate;
historicalextrap.dy=sqrt((.5*(historicalextrap.t-2005).^2*historicalextrap.accelstd).^2 + ((historicalextrap.t-2005)*historicalextrap.ratestd).^2);
historicalextrap.y=historicalextrap.y;
historicalextrap.dy=historicalextrap.dy;


scens={'ssp585','ssp370','ssp245','ssp126','ssp119'};
scencolors=[color_SSP585 ; color_SSP370 ; color_SSP245 ; color_SSP126 ; color_SSP119];

clear SL_quant Conf_Bounds SL_quantb SL_quantc;
for sss=1:length(scens)
    SL_quant{sss}=squeeze(single(ncread(['data/pbox1e_total_' scens{sss} '_globalsl_figuredata.nc'],'sea_level_change')));
    SL_quantb{sss}=squeeze(single(ncread(['data/pbox1f_total_' scens{sss} '_globalsl_figuredata.nc'],'sea_level_change')));
    SL_quantc{sss}=[SL_quant{sss} ; SL_quantb{sss}(subtb,:)];
    
    Conf_Bounds{sss}=[SL_quantc{sss}(:,4) ; flipud(SL_quantc{sss}(:,2)) ; SL_quantc{sss}(1,4)]/1000;
end

clear SL_quantLCas SL_quantLCbs SL_quantLCs Conf_BoundsLCsvl Conf_BoundsLCsl;
for sss=[1 4]
    SL_quantLCas{sss}=squeeze(single(ncread(['data/pbox2e_total_' scens{sss} '_globalsl_figuredata.nc'],'sea_level_change')));
    SL_quantLCbs{sss}=squeeze(single(ncread(['data/pbox2f_total_' scens{sss} '_globalsl_figuredata.nc'],'sea_level_change')));
    SL_quantLCs{sss}=[SL_quantLCas{sss} ; SL_quantLCbs{sss}(subtb,:)];
    Conf_BoundsLCsvl{sss}=[SL_quantLCs{sss}(:,5) ; flipud(SL_quantLCs{sss}(:,1)) ; SL_quantLCs{sss}(1,5)]/1000;
    Conf_BoundsLCsl{sss}=[SL_quantLCs{sss}(:,4) ; flipud(SL_quantLCs{sss}(:,2)) ; SL_quantLCs{sss}(1,5)]/1000;
end

SL_quantLC=SL_quantLCs{1};
Conf_BoundsLCvl=Conf_BoundsLCsvl{1};
Conf_BoundsLCl=Conf_BoundsLCsl{1};

SL_quantLClo=SL_quantLCs{4};
Conf_BoundsLCvllo=Conf_BoundsLCsvl{4};
Conf_BoundsLCllo=Conf_BoundsLCsl{4};

axes(hs(1));

plot([start_year end_year],[0 0],'Color','k','linewidth',0.5); hold on;


%Plot the low-confidence process ranges
ppp=[];
clear hp hpb;
%hplc(1) = patch(Time_Conf_Bounds,Conf_BoundsLCvl,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.03); hold on;
%hplc(2) = patch(Time_Conf_Bounds,Conf_BoundsLCl,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.03); hold on;

collabs={'A','G','L','Q','V','AA','AF'};
writematrix('Change in global mean sea level (GMSL) in meters compared to 1995-2014 average - FACTS Probabilistic Emulator Product',savefile,'Range','A1');

year=[2005; Time_Conf_Bounds(1:12)];
verylikely_ubound_m=[0; Conf_BoundsLCvl(1:12)];
verylikely_lbound_m=[0; Conf_BoundsLCvl(end-1:-1:end-12)];
likely_ubound_m=[0; Conf_BoundsLCl(1:12)];
likely_lbound_m=[0; Conf_BoundsLCl(end-1:-1:end-12)];
T = table(year,likely_lbound_m,likely_ubound_m,verylikely_lbound_m,verylikely_ubound_m);

writematrix('SSP5-8.5 Low Confidence Processes',savefile,'Range',[cell2mat(collabs(1)),'2']);
writetable(T,savefile,'Range',[cell2mat(collabs(1)),'3']);

year=[2005; Time_Conf_Bounds(1:12)];
verylikely_ubound_m=[0; Conf_BoundsLCvllo(1:12)];
verylikely_lbound_m=[0; Conf_BoundsLCvllo(end-1:-1:end-12)];
likely_ubound_m=[0; Conf_BoundsLCllo(1:12)];
likely_lbound_m=[0; Conf_BoundsLCllo(end-1:-1:end-12)];
T = table(year,likely_lbound_m,likely_ubound_m,verylikely_lbound_m,verylikely_ubound_m);

writematrix('SSP1-2.6 Low Confidence Processes',savefile,'Range',[cell2mat(collabs(7)),'2']);
writetable(T,savefile,'Range',[cell2mat(collabs(7)),'3']);

for sss=1:length(scens)
    ppp(sss)=patch(Time_Conf_Bounds,Conf_Bounds{sss},scencolors(sss,:), 'EdgeColor', 'none', 'FaceAlpha', 0.2); hold on;
    
    year=[2005; Time_Conf_Bounds(1:12)];
    verylikely_ubound_m=[0; SL_quantc{sss}(1:12,5)/1000];
    verylikely_lbound_m=[0; SL_quantc{sss}(1:12,1)/1000];
    likely_ubound_m=[0; SL_quantc{sss}(1:12,4)/1000];
    likely_lbound_m=[0; SL_quantc{sss}(1:12,2)/1000];
    central_m=[0 ; SL_quantc{sss}(1:12,3)/1000];
    T = table(year,central_m,likely_lbound_m,likely_ubound_m);
    writematrix([cell2mat(scens(sss)),' Medium Confidence Processes'],savefile,'Range',[cell2mat(collabs(1+sss)),'1']);
    writetable(T,savefile,'Range',[cell2mat(collabs(1+sss)),'2']);
end

outstruct.historical_time=historical.t(:);
outstruct.historical=historical.y(:)/1000;
outstruct.historical_boundstime=historicalextrap.t(:);
outstruct.historical_Likely_lbound=(historical.y(:)-historical.dy(:))/1000;
outstruct.historical_Likely_ubound=(historical.y(:)+historical.dy(:))/1000;

%Plot the historical data and extrapolation
ph=plot(historical.t,historical.y/1000,'k', 'LineWidth', width);
phdash=plot(historicalextrap.t,historicalextrap.y/1000,'Color',[1 1 1]*0.3, 'LineStyle','-', 'LineWidth', width/4);
phdot=plot(historicalextrap.t,(historicalextrap.y-historicalextrap.dy)/1000,'Color',[1 1 1]*0.3, 'LineStyle','-.', 'LineWidth', width/4);
phx=plot(historicalextrap.t,(historicalextrap.y+historicalextrap.dy)/1000,'Color',[1 1 1]*0.3, 'LineStyle','-.', 'LineWidth', width/4);


%Plot the medium-confidence process scenarios
pp=[];
for sss=1:length(scens)
    pp(sss)=plot([2005 ; timec],[0 ; SL_quantc{sss}(:,3)/1000],'Color',scencolors(sss,:),'LineStyle','-', 'LineWidth', width); hold on
end

hplc(1) = plot(Time_Conf_Bounds(1:end/2),Conf_BoundsLCvl(1:end/2),'Color',color_SSP585, ...
    'LineStyle',':','LineWidth',width/4); hold on;
hplc(2) = plot(Time_Conf_Bounds(1:end/2),Conf_BoundsLCl(1:end/2),'Color',color_SSP585, ...
    'LineStyle','--','LineWidth',width/4); hold on;

% outstruct.historical_time=historical.t(:);
% outstruct.historical=historical.y(:)/1000;
% outstruct.historical_boundstime=historicalextrap.t(:);
% outstruct.historical_Likely_lbound=(historical.y(:)-historical.dy(:))/1000;
% outstruct.historical_Likely_ubound=(historical.y(:)+historical.dy(:))/1000;
% 
% %Plot the historical data and extrapolation
% ph=plot(historical.t,historical.y/1000,'k', 'LineWidth', width);
% phdash=plot(historicalextrap.t,historicalextrap.y/1000,'Color',[1 1 1]*0.3, 'LineStyle','-', 'LineWidth', width/4);
% phdot=plot(historicalextrap.t,(historicalextrap.y-historicalextrap.dy)/1000,'Color',[1 1 1]*0.3, 'LineStyle','-.', 'LineWidth', width/4);
% phx=plot(historicalextrap.t,(historicalextrap.y+historicalextrap.dy)/1000,'Color',[1 1 1]*0.3, 'LineStyle','-.', 'LineWidth', width/4);
% 

xlim([start_year end_year]); ylim([-.1 2.5]);
ylabel('(m)     ')
set(get(gca,'YLabel'),'Rotation',0,'FontSize',18)

set(gca,'Xtick',[1950 2000 2050 2100 2150],'Xticklabel',{'1950','2000','2050', '2100', '2150         '})

txt = 'SSP5-8.5';
text(20+2100,2.0, ...
    txt,'FontSize',13, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = 'SSP3-7.0';
text(20+2080,1.6, ...
    txt,'FontSize',13, ...
    'Color', color_SSP370, 'FontWeight', 'bold')
txt = 'SSP2-4.5';
text(20+2060,1.2, ...
    txt,'FontSize',13, ...
    'Color', color_SSP245, 'FontWeight', 'bold')
txt = 'SSP1-2.6';
text(20+2100,0.2, ...
    txt,'FontSize',13, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = 'SSP1-1.9';
text(20+2072,0.2, ...
    txt,'FontSize',13, ...
    'Color', color_SSP119, 'FontWeight', 'bold')
txt = 'Historical';
text(1970,0.2, ...
    txt,'FontSize',14, ...
    'Color', 'k', 'FontWeight', 'bold')

legend([pp(1) ppp(1) phdash phdot hplc(2) hplc(1)], ...
    'Median (medium confidence)','Likely range (medium confidence)', ...
    'Satellite extrapolation (see caption)','Likely range of extrapolation', ...
    'SSP5-8.5 Low confidence 83^{rd} percentile', ...
    'SSP5-8.5 Low confidence 95^{th} percentile', 'Location','NorthWest',...
    'FontSize',10,'Box','off')


axes(hs(2));

set(gca,'Box', 'on','Clipping','off')
xlim([.5 5.5]);
subt=find(timec==end_year);
sss=1;
for sss=1:length(scens)
    plot([sss sss]-2,[SL_quantc{sss}(subt,[2 4])]/1000,'Color',[scencolors(sss,:)],'LineStyle','-', 'LineWidth', width); hold on
%    plot([sss sss]-2,[SL_quantc{sss}(subt,[1 5])]/1000,'Color',scencolors(sss,:),'LineStyle','-', 'LineWidth', width/2); hold on
    plot([sss sss]-2,[SL_quantc{sss}(subt,3)]/1000,'Color',[scencolors(sss,:)],'Marker','.', 'MarkerSize', 20); hold on
end

for sss=[1 4]
    if sss==1
        tmp_x=6;
    else
        tmp_x=7;
    end
    colorw=.95;
%     colort=colorw*[1 1 1]+(1-colorw)*scencolors(sss,:);
    plot([sss sss]-2,[SL_quantLCs{sss}(subt,[1 5])]/1000,'Color',[scencolors(sss,:) 0.2],'LineStyle','-', 'LineWidth', width/2); hold on
%     colorw=.9;
%     colort=colorw*[1 1 1]+(1-colorw)*scencolors(sss,:);
    plot([sss sss]-2,[SL_quantLCs{sss}(subt,[2 4])]/1000,'Color',[scencolors(sss,:) 0.2],'LineStyle','-', 'LineWidth', width); hold on
%    plot([sss sss]-2,[SL_quantLCs{sss}(subt,3)]/1000,'Marker','.','Color',scencolors(sss,:), 'MarkerSize', 20); hold on
    if sss==1
        [SL_quantLCs{sss}(subt,[4 5])]/1000
    end
end

%plot([4.5 4.5], [-.2 3] ...
%    , '-', 'Color','k', 'LineWidth', width/4)

% txt = {'2150 med. conf. [dark;',' medians & likely range]','and low conf. [light;','(very) likely range]'};
% text(0 ,0. ,txt,'FontSize',10, ...
%     'Color', 'k','HorizontalAlignment','center')

txt = {'2150 medium','& low confidence','projections', '(see caption)'};
text(.5 ,0. ,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

% txt = {'Low','conf.'};
% text(6.5 ,.2 ,txt,'FontSize',10, ...
%     'Color', 'k','HorizontalAlignment','center')
% 
% txt = {'Medium','confidence'};
% text(0. ,.2 ,txt,'FontSize',10, ...
%     'Color', 'k','HorizontalAlignment','center')

set(hs,'FontSize',fontsize)
set(hs,'ylim',[-.1 2.5]);
set(hs([2]),'color','none','ycolor','none','xcolor','none','xdir','reverse');

print(gcf,'../PNGs/SL_Scenarios_Timeseries.png','-dpng','-r1000', '-painters');
print(gcf,'../PNGs/SL_Scenarios_Timeseries.eps','-depsc','-r1000', '-painters');

% saveas(gcf, 'SL_Scenarios_Timeseries', 'png')
% 
% year=outstruct.historical_time;
% central_m=outstruct.historical;
% likely_lbound_m=outstruct.historical_Likely_lbound;
% likely_ubound_m=outstruct.historical_Likely_ubound;
% T = table(year,central_m,likely_lbound_m,likely_ubound_m);
% writetable(T,savefile,'Sheet','Historical');

%% Save plotted data

%% Save data from figures

var_name = 'SL_change';
var_units = 'meters';
comments = "Data is for Figure 9.27 in the IPCC Working Group"+ ...
    " I contribution to the Sixth Assesment Report";

ncfilename = '../Plotted_Data/Fig9-27_data_ssp119_median.nc';
title = "Median projected Sea Level Rise under SSP1-1.9";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, [0 ; SL_quantc{5}(:,3)/1000], ...
    [2005 ; timec], title, comments)

ncfilename = '../Plotted_Data/Fig9-27_data_ssp126_median.nc';
title = "Median projected Sea Level Rise under SSP1-2.6";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, [0 ; SL_quantc{4}(:,3)/1000], ...
    [2005 ; timec], title, comments)

ncfilename = '../Plotted_Data/Fig9-27_data_ssp245_median.nc';
title = "Median projected Sea Level Rise under SSP2-4.5";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, [0 ; SL_quantc{3}(:,3)/1000], ...
    [2005 ; timec], title, comments)

ncfilename = '../Plotted_Data/Fig9-27_data_ssp370_median.nc';
title = "Median projected Sea Level Rise under SSP3-7.0";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, [0 ; SL_quantc{2}(:,3)/1000], ...
    [2005 ; timec], title, comments)

ncfilename = '../Plotted_Data/Fig9-27_data_ssp585_median.nc';
title = "Median projected Sea Level Rise under SSP5-8.5";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, [0 ; SL_quantc{1}(:,3)/1000], ...
    [2005 ; timec], title, comments)

ncfilename = '../Plotted_Data/Fig9-27_data_ssp119_likelyrange.nc';
title = "Likely range of projected Sea Level Rise under SSP1-1.9";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, Conf_Bounds{5}, ...
    Time_Conf_Bounds, title, comments)

ncfilename = '../Plotted_Data/Fig9-27_data_ssp126_likelyrange.nc';
title = "Likely range of projected Sea Level Rise under SSP1-2.6";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, Conf_Bounds{4}, ...
    Time_Conf_Bounds, title, comments)

ncfilename = '../Plotted_Data/Fig9-27_data_ssp245_likelyrange.nc';
title = "Likely range of projected Sea Level Rise under SSP2-4.5";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, Conf_Bounds{3}, ...
    Time_Conf_Bounds, title, comments)

ncfilename = '../Plotted_Data/Fig9-27_data_ssp370_likelyrange.nc';
title = "Likely range of projected Sea Level Rise under SSP3-7.0";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, Conf_Bounds{2}, ...
    Time_Conf_Bounds, title, comments)

ncfilename = '../Plotted_Data/Fig9-27_data_ssp585_likelyrange.nc';
title = "Likely range of projected Sea Level Rise under SSP5-8.5";
IPCC_Write_NetCDF_Timeseries(ncfilename, var_name, var_units, Conf_Bounds{1}, ...
    Time_Conf_Bounds, title, comments)

creator = "Brodie Pearson (brodie.pearson@oregonstate.edu)";
activity = "IPCC AR6 (Chapter 9)";
ncfilename = '../Plotted_Data/Fig9-27_2150_barranges.nc';
title = "2150 sea level change ranges from medium and low confidence projections";

% Create bar variables in netcdf files

nccreate(ncfilename,'ssp119_median');
nccreate(ncfilename,'ssp119_medium_confidence_upper');
nccreate(ncfilename,'ssp119_medium_confidence_lower');
ncwrite(ncfilename,'ssp119_median',SL_quantc{5}(subt,3)/1000);
ncwrite(ncfilename,'ssp119_medium_confidence_upper',SL_quantc{5}(subt,2)/1000);
ncwrite(ncfilename,'ssp119_medium_confidence_lower',SL_quantc{5}(subt,4)/1000);

nccreate(ncfilename,'ssp126_median');
nccreate(ncfilename,'ssp126_medium_confidence_upper');
nccreate(ncfilename,'ssp126_medium_confidence_lower');
nccreate(ncfilename,'ssp126_low_confidence_upper');
nccreate(ncfilename,'ssp126_low_confidence_lower');
ncwrite(ncfilename,'ssp126_median',SL_quantc{4}(subt,3)/1000);
ncwrite(ncfilename,'ssp126_medium_confidence_upper',SL_quantc{4}(subt,2)/1000);
ncwrite(ncfilename,'ssp126_medium_confidence_lower',SL_quantc{4}(subt,4)/1000);
ncwrite(ncfilename,'ssp126_low_confidence_upper',SL_quantc{4}(subt,1)/1000);
ncwrite(ncfilename,'ssp126_low_confidence_lower',SL_quantc{4}(subt,5)/1000);

nccreate(ncfilename,'ssp245_median');
nccreate(ncfilename,'ssp245_medium_confidence_upper');
nccreate(ncfilename,'ssp245_medium_confidence_lower');
ncwrite(ncfilename,'ssp245_median',SL_quantc{3}(subt,3)/1000);
ncwrite(ncfilename,'ssp245_medium_confidence_upper',SL_quantc{3}(subt,2)/1000);
ncwrite(ncfilename,'ssp245_medium_confidence_lower',SL_quantc{3}(subt,4)/1000);

nccreate(ncfilename,'ssp370_median');
nccreate(ncfilename,'ssp370_medium_confidence_upper');
nccreate(ncfilename,'ssp370_medium_confidence_lower');
ncwrite(ncfilename,'ssp370_median',SL_quantc{4}(subt,3)/1000);
ncwrite(ncfilename,'ssp370_medium_confidence_upper',SL_quantc{4}(subt,2)/1000);
ncwrite(ncfilename,'ssp370_medium_confidence_lower',SL_quantc{4}(subt,4)/1000);

nccreate(ncfilename,'ssp585_median');
nccreate(ncfilename,'ssp585_medium_confidence_upper');
nccreate(ncfilename,'ssp585_medium_confidence_lower');
nccreate(ncfilename,'ssp585_low_confidence_upper');
nccreate(ncfilename,'ssp585_low_confidence_lower');
ncwrite(ncfilename,'ssp585_median',SL_quantc{1}(subt,3)/1000);
ncwrite(ncfilename,'ssp585_medium_confidence_upper',SL_quantc{1}(subt,2)/1000);
ncwrite(ncfilename,'ssp585_medium_confidence_lower',SL_quantc{1}(subt,4)/1000);
ncwrite(ncfilename,'ssp585_low_confidence_upper',SL_quantc{1}(subt,1)/1000);
ncwrite(ncfilename,'ssp585_low_confidence_lower',SL_quantc{1}(subt,5)/1000);

% Write metadata to netcdf file
ncwriteatt(ncfilename,'/','title',title);
ncwriteatt(ncfilename,'/','units',var_units);
ncwriteatt(ncfilename,'/','creator',creator);
ncwriteatt(ncfilename,'/','activity',activity);
ncwriteatt(ncfilename,'/','comments',comments);

