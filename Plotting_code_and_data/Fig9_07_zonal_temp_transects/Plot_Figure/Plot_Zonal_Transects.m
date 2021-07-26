%% IPCC AR6 Chapter 9: Figure 9.7 (Temperature Transects)
%
% Code used to plot the pre-calculated temperature transects
%
% Plotting code written by Brodie Pearson

clear all

addpath ../../../Functions/

fontsize = 25;

savefile = './Data/Temperature_Transects.mat';
load(savefile)

data_path = '/Volumes/PromiseDisk/AR6_Data/thetao_with_chapter_4/';

IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Data/CMIP6_metadata/Fig9-4d_md.csv', 'd', true)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Data/CMIP6_metadata/Fig9-4h_md.csv', 'h', true)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Data/CMIP6_metadata/Fig9-4l_md.csv', 'l', true)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp585'}, ...
    '../Data/CMIP6_metadata/Fig9-4p_md.csv', 'p', true)

IPCC_Get_CMIP6_Metadata(data_path, {'ssp126'}, ...
    '../Data/CMIP6_metadata/Fig9-4c_md.csv', 'c', true)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp126'}, ...
    '../Data/CMIP6_metadata/Fig9-4g_md.csv', 'g', true)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp126'}, ...
    '../Data/CMIP6_metadata/Fig9-4k_md.csv', 'k', true)
IPCC_Get_CMIP6_Metadata(data_path, {'ssp126'}, ...
    '../Data/CMIP6_metadata/Fig9-4o_md.csv', 'o', true)

data_path='/Volumes/PromiseDisk/AR6_Data/thetao/'

IPCC_Get_CMIP6_Metadata(data_path, {'historical'}, ...
    '../Data/CMIP6_metadata/Fig9-4b_md.csv', 'b', false)
IPCC_Get_CMIP6_Metadata(data_path, {'historical'}, ...
    '../Data/CMIP6_metadata/Fig9-4f_md.csv', 'f', false)
IPCC_Get_CMIP6_Metadata(data_path, {'historical'}, ...
    '../Data/CMIP6_metadata/Fig9-4j_md.csv', 'j', false)
IPCC_Get_CMIP6_Metadata(data_path, {'historical'}, ...
    '../Data/CMIP6_metadata/Fig9-4n_md.csv', 'n', false)

%% Define colorbars and calculate rates of change

div_colors = IPCC_Get_Colorbar('temperature_d',20,false);
nondiv_colors = IPCC_Get_Colorbar('temperature_nd',20,false);
bias_colors = IPCC_Get_Colorbar('chem_d', 20, true);
        
Global_ChangeRate_ssp126 = (Global_mean_ssp126 - Global_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));
Global_ChangeRate_ssp370 = (Global_mean_ssp370 - Global_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));
Global_ChangeRate_ssp585 = (Global_mean_ssp585 - Global_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));

Pacific_ChangeRate_ssp126 = (Pacific_mean_ssp126 - Pacific_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));
Pacific_ChangeRate_ssp370 = (Pacific_mean_ssp370 - Pacific_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));
Pacific_ChangeRate_ssp585 = (Pacific_mean_ssp585 - Pacific_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));

Atlantic_ChangeRate_ssp126 = (Atlantic_mean_ssp126 - Atlantic_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));
Atlantic_ChangeRate_ssp370 = (Atlantic_mean_ssp370 - Atlantic_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));
Atlantic_ChangeRate_ssp585 = (Atlantic_mean_ssp585 - Atlantic_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));

Indian_ChangeRate_ssp126 = (Indian_mean_ssp126 - Indian_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));
Indian_ChangeRate_ssp370 = (Indian_mean_ssp370 - Indian_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));
Indian_ChangeRate_ssp585 = (Indian_mean_ssp585 - Indian_mean_hist)*10/ ...
    (str2num(start_year_ssp) - str2num(start_year_historicalvsssp));

temp_mask = nan(size(Global_mean_hist));


%% Make Global plots (Once for titles, once for colorbars, once for non-colorbars)

for ii=1:5  
    figure('Position', [10 10 500 200])
    h=colorbar('Location','SouthOutside');
    if ii==1
        contourf(latitudes,fliplr(-depths),flipud(Global_observations'),20,'LineColor','none')
        caxis([-2 30])
        colormap(gca,nondiv_colors)
        h=colorbar('Location','SouthOutside');
        title({"Observed Temperature", "(ARGO; "+ ...
            char(start_year_historicalvsobs)+"-"+ ...
            char(end_year_historicalvsobs)+")"}, 'fontsize', 25);
        
        ncfilename = '../Data/Fig9-7a_data.nc';
        var_name = 'thetao';
        var_units = 'degrees Celsius';
        title = "Zonally-averaged Potential Temperature in the Global Ocean "+...
            "climatology between 2005-2014 using Argo";
        comments = "Data is for panel (a) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Global_observations'), ...
            latitudes',fliplr(-depths)', title, comments)
        clear title
        
    elseif ii==2
        contourf(latitudes,fliplr(-depths),flipud(Global_bias_mean'),20,'LineColor','none')
        caxis([-5 5])
        colormap(gca,bias_colors)
        h=colorbar('Location','SouthOutside');
        title({"CMIP Bias", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_historicalvsobs)+"-"+ ...
            char(end_year_historicalvsobs)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Global_bias_mask==1)=0;
        temp_mask(Global_bias_mask==0 & isnan(Global_bias_mean))=0;
        temp_mask(Global_bias_mask==0 & ~isnan(Global_bias_mean))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp,'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7b_data.nc';
        var_name = 'thetao_Bias';
        var_units = 'degrees Celsius';
        title = "Zonally-averaged Potential Temperature Bias in the Global Ocean "+...
            "between 2005-2014; CMIP6 (CMIP) relative to Argo observations";
        comments = "Data is for panel (b) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Global_bias_mean'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    elseif ii==3
        contourf(latitudes,fliplr(-depths),flipud(Global_ChangeRate_ssp126'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP1-2.6 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Global_mask_ssp126==1)=0;
        temp_mask(Global_mask_ssp126==0 & isnan(Global_mean_hist))=0;
        temp_mask(Global_mask_ssp126==0 & ~isnan(Global_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7c_data.nc';
        var_name = 'thetao_ChangeRate';
        var_units = 'degrees Celsius per decade';
        title = "Zonally-averaged Potential Temperature Rate of Change in the Global Ocean "+...
            "under SSP1-2.6 between 1995 and 2100; CMIP6 (CMIP & ScenarioMIP)";
        comments = "Data is for panel (c) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Global_ChangeRate_ssp126'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    elseif ii==4
        contourf(latitudes,fliplr(-depths),flipud(Global_ChangeRate_ssp370'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP3-7.0 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Global_mask_ssp370==1)=0;
        temp_mask(Global_mask_ssp370==0 & isnan(Global_mean_hist))=0;
        temp_mask(Global_mask_ssp370==0 & ~isnan(Global_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
    elseif ii==5
        contourf(latitudes,fliplr(-depths),flipud(Global_ChangeRate_ssp585'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP5-8.5 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Global_mask_ssp585==1)=0;
        temp_mask(Global_mask_ssp585==0 & isnan(Global_mean_hist))=0;
        temp_mask(Global_mask_ssp585==0 & ~isnan(Global_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7d_data.nc';
        var_name = 'thetao_ChangeRate';
        var_units = 'degrees Celsius per decade';
        title = "Zonally-averaged Potential Temperature Rate of Change in the Global Ocean "+...
            "under SSP5-8.5 between 1995 and 2100; CMIP6 (CMIP & ScenarioMIP)";
        comments = "Data is for panel (d) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Global_ChangeRate_ssp585'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
    end
    xlim([-80 90])
    ylim([-2000 0])
    xticks([-80 -40 0 40 80])
    xticklabels({'', '', '', '', ''})
    yticks([-2000 -1500 -1000 -500 0])
     if ii==1
        yticklabels({'2', '', '1', '', '0'})
    else
        yticklabels({'', '', '', '', ''})
    end
    set(gca,'FontSize',fontsize)
    if ii==1
        print(gcf,"../PNGs/Observed_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
        title('');
%        print(gcf,"../PNGs/Observed_Global_Temperature_Transects_Colorbar.png",'-dpng','-r1000', '-painters');
        colorbar off
        yticklabels({'', '', '', '', ''})
        print(gcf,"../PNGs/Observed_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==2
        print(gcf,"../PNGs/Bias_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
        title('');
%        print(gcf,"../PNGs/Bias_Global_Temperature_Transects_Colorbar.png",'-dpng','-r1000', '-painters');
        colorbar off
        print(gcf,"../PNGs/Bias_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==3
        print(gcf,"../PNGs/SSP126_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
        title('');
%        print(gcf,"../PNGs/SSP126_Global_Temperature_Transects_Colorbar.png",'-dpng','-r1000', '-painters');
        colorbar off
        print(gcf,"../PNGs/SSP126_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==4
        print(gcf,"../PNGs/SSP370_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP370_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==5
        print(gcf,"../PNGs/SSP585_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP585_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    end
   close(1)
end

%% Make Pacific plots 

for ii=1:5  
    figure('Position', [10 10 500 200])
    h=colorbar('Location','SouthOutside');
    if ii==1
        contourf(latitudes,fliplr(-depths),flipud(Pacific_observations'),20,'LineColor','none')
        caxis([-2 30])
        colormap(gca,nondiv_colors)
        h=colorbar('Location','SouthOutside');
        title({"Observed Temperature", "(ARGO; "+ ...
            char(start_year_historicalvsobs)+"-"+ ...
            char(end_year_historicalvsobs)+")"}, 'fontsize', 25);
        
        ncfilename = '../Data/Fig9-7e_data.nc';
        var_name = 'thetao';
        var_units = 'degrees Celsius';
        title = "Zonally-averaged Potential Temperature in the Pacific Ocean "+...
            "climatology between 2005-2014 using Argo";
        comments = "Data is for panel (e) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Pacific_observations'), ...
            latitudes',fliplr(-depths)', title, comments)
        clear title
        
    elseif ii==2
        contourf(latitudes,fliplr(-depths),flipud(Pacific_bias_mean'),20,'LineColor','none')
        caxis([-5 5])
        colormap(gca,bias_colors)
        h=colorbar('Location','SouthOutside');
        title({"CMIP Bias", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_historicalvsobs)+"-"+ ...
            char(end_year_historicalvsobs)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Pacific_bias_mask==1)=0;
        temp_mask(Pacific_bias_mask==0 & isnan(Pacific_bias_mean))=0;
        temp_mask(Pacific_bias_mask==0 & ~isnan(Pacific_bias_mean))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp,'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7f_data.nc';
        var_name = 'thetao_Bias';
        var_units = 'degrees Celsius';
        title = "Zonally-averaged Potential Temperature Bias in the Pacific Ocean "+...
            "between 2005-2014; CMIP6 (CMIP) relative to Argo observations";
        comments = "Data is for panel (f) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Pacific_bias_mean'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    elseif ii==3
        contourf(latitudes,fliplr(-depths),flipud(Pacific_ChangeRate_ssp126'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP1-2.6 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Pacific_mask_ssp126==1)=0;
        temp_mask(Pacific_mask_ssp126==0 & isnan(Pacific_mean_hist))=0;
        temp_mask(Pacific_mask_ssp126==0 & ~isnan(Pacific_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7g_data.nc';
        var_name = 'thetao_ChangeRate';
        var_units = 'degrees Celsius per decade';
        title = "Zonally-averaged Potential Temperature Rate of Change in the Pacific Ocean "+...
            "under SSP1-2.6 between 1995 and 2100; CMIP6 (CMIP & ScenarioMIP)";
        comments = "Data is for panel (g) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Pacific_ChangeRate_ssp126'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    elseif ii==4
        contourf(latitudes,fliplr(-depths),flipud(Pacific_ChangeRate_ssp370'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP3-7.0 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Pacific_mask_ssp370==1)=0;
        temp_mask(Pacific_mask_ssp370==0 & isnan(Pacific_mean_hist))=0;
        temp_mask(Pacific_mask_ssp370==0 & ~isnan(Pacific_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
    elseif ii==5
        contourf(latitudes,fliplr(-depths),flipud(Pacific_ChangeRate_ssp585'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP5-8.5 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Pacific_mask_ssp585==1)=0;
        temp_mask(Pacific_mask_ssp585==0 & isnan(Pacific_mean_hist))=0;
        temp_mask(Pacific_mask_ssp585==0 & ~isnan(Pacific_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7h_data.nc';
        var_name = 'thetao_ChangeRate';
        var_units = 'degrees Celsius per decade';
        title = "Zonally-averaged Potential Temperature Rate of Change in the Pacific Ocean "+...
            "under SSP5-8.5 between 1995 and 2100; CMIP6 (CMIP & ScenarioMIP)";
        comments = "Data is for panel (h) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Pacific_ChangeRate_ssp585'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    end
    xlim([-80 90])
    ylim([-2000 0])
    xticks([-80 -40 0 40 80])
    xticklabels({'', '', '', '', ''})
    yticks([-2000 -1500 -1000 -500 0])
     if ii==1
        yticklabels({'2', '', '1', '', '0'})
    else
        yticklabels({'', '', '', '', ''})
    end
    set(gca,'FontSize',fontsize)
    if ii==1
        title('');
        colorbar off
        yticklabels({'', '', '', '', ''})
        print(gcf,"../PNGs/Observed_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==2
        title('');
        colorbar off
        print(gcf,"../PNGs/Bias_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==3
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP126_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==4
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP370_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==5
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP585_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    end
   close(1)
end

%% Make Atlantic plots

for ii=1:5  
    figure('Position', [10 10 500 200])
    h=colorbar('Location','SouthOutside');
    if ii==1
        contourf(latitudes,fliplr(-depths),flipud(Atlantic_observations'),20,'LineColor','none')
        caxis([-2 30])
        colormap(gca,nondiv_colors)
        h=colorbar('Location','SouthOutside');
        title({"Observed Temperature", "(ARGO; "+ ...
            char(start_year_historicalvsobs)+"-"+ ...
            char(end_year_historicalvsobs)+")"}, 'fontsize', 25);
        
        ncfilename = '../Data/Fig9-7i_data.nc';
        var_name = 'thetao';
        var_units = 'degrees Celsius';
        title = "Zonally-averaged Potential Temperature in the Atlantic Ocean "+...
            "climatology between 2005-2014 using Argo";
        comments = "Data is for panel (i) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Atlantic_observations'), ...
            latitudes',fliplr(-depths)', title, comments)
        clear title
        
    
    elseif ii==2
        contourf(latitudes,fliplr(-depths),flipud(Atlantic_bias_mean'),20,'LineColor','none')
        caxis([-5 5])
        colormap(gca,bias_colors)
        h=colorbar('Location','SouthOutside');
        title({"CMIP Bias", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_historicalvsobs)+"-"+ ...
            char(end_year_historicalvsobs)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Atlantic_bias_mask==1)=0;
        temp_mask(Atlantic_bias_mask==0 & isnan(Atlantic_bias_mean))=0;
        temp_mask(Atlantic_bias_mask==0 & ~isnan(Atlantic_bias_mean))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp,'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7j_data.nc';
        var_name = 'thetao_Bias';
        var_units = 'degrees Celsius';
        title = "Zonally-averaged Potential Temperature Bias in the Atlantic Ocean "+...
            "between 2005-2014; CMIP6 (CMIP) relative to Argo observations";
        comments = "Data is for panel (j) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Atlantic_bias_mean'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    elseif ii==3
        contourf(latitudes,fliplr(-depths),flipud(Atlantic_ChangeRate_ssp126'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP1-2.6 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Atlantic_mask_ssp126==1)=0;
        temp_mask(Atlantic_mask_ssp126==0 & isnan(Atlantic_mean_hist))=0;
        temp_mask(Atlantic_mask_ssp126==0 & ~isnan(Atlantic_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7k_data.nc';
        var_name = 'thetao_ChangeRate';
        var_units = 'degrees Celsius per decade';
        title = "Zonally-averaged Potential Temperature Rate of Change in the Atlantic Ocean "+...
            "under SSP1-2.6 between 1995 and 2100; CMIP6 (CMIP & ScenarioMIP)";
        comments = "Data is for panel (k) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Atlantic_ChangeRate_ssp126'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    elseif ii==4
        contourf(latitudes,fliplr(-depths),flipud(Atlantic_ChangeRate_ssp370'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP3-7.0 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Atlantic_mask_ssp370==1)=0;
        temp_mask(Atlantic_mask_ssp370==0 & isnan(Atlantic_mean_hist))=0;
        temp_mask(Atlantic_mask_ssp370==0 & ~isnan(Atlantic_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
    elseif ii==5
        contourf(latitudes,fliplr(-depths),flipud(Atlantic_ChangeRate_ssp585'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP5-8.5 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Atlantic_mask_ssp585==1)=0;
        temp_mask(Atlantic_mask_ssp585==0 & isnan(Atlantic_mean_hist))=0;
        temp_mask(Atlantic_mask_ssp585==0 & ~isnan(Atlantic_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7l_data.nc';
        var_name = 'thetao_ChangeRate';
        var_units = 'degrees Celsius per decade';
        title = "Zonally-averaged Potential Temperature Rate of Change in the Atlantic Ocean "+...
            "under SSP5-8.5 between 1995 and 2100; CMIP6 (CMIP & ScenarioMIP)";
        comments = "Data is for panel (l) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Atlantic_ChangeRate_ssp585'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    end
    xlim([-80 90])
    ylim([-2000 0])
    xticks([-80 -40 0 40 80])
    xticklabels({'', '', '', '', ''})
    yticks([-2000 -1500 -1000 -500 0])
     if ii==1
        yticklabels({'2', '', '1', '', '0'})
    else
        yticklabels({'', '', '', '', ''})
    end
    set(gca,'FontSize',fontsize)
    if ii==1
        title('');
        colorbar off
        yticklabels({'', '', '', '', ''})
        print(gcf,"../PNGs/Observed_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==2
        title('');
        colorbar off
        print(gcf,"../PNGs/Bias_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==3
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP126_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==4
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP370_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==5
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP585_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    end
   close(1)
end

%% Make Indian plots

for ii=1:5  
    figure('Position', [10 10 500 200])
    h=colorbar('Location','SouthOutside');
    if ii==1
        contourf(latitudes,fliplr(-depths),flipud(Indian_observations'),20,'LineColor','none')
        caxis([-2 30])
        colormap(gca,nondiv_colors)
        h=colorbar('Location','SouthOutside');
        title({"Observed Temperature", "(ARGO; "+ ...
            char(start_year_historicalvsobs)+"-"+ ...
            char(end_year_historicalvsobs)+")"}, 'fontsize', 25);
        
        ncfilename = '../Data/Fig9-7m_data.nc';
        var_name = 'thetao';
        var_units = 'degrees Celsius';
        title = "Zonally-averaged Potential Temperature in the Indian Ocean "+...
            "climatology between 2005-2014 using Argo";
        comments = "Data is for panel (m) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Indian_observations'), ...
            latitudes',fliplr(-depths)', title, comments)
        clear title
        
    elseif ii==2
        contourf(latitudes,fliplr(-depths),flipud(Indian_bias_mean'),20,'LineColor','none')
        caxis([-5 5])
        colormap(gca,bias_colors)
        h=colorbar('Location','SouthOutside');
        title({"CMIP Bias", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_historicalvsobs)+"-"+ ...
            char(end_year_historicalvsobs)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Indian_bias_mask==1)=0;
        temp_mask(Indian_bias_mask==0 & isnan(Indian_bias_mean))=0;
        temp_mask(Indian_bias_mask==0 & ~isnan(Indian_bias_mean))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp,'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7n_data.nc';
        var_name = 'thetao_Bias';
        var_units = 'degrees Celsius';
        title = "Zonally-averaged Potential Temperature Bias in the Indian Ocean "+...
            "between 2005-2014; CMIP6 (CMIP) relative to Argo observations";
        comments = "Data is for panel (n) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Indian_bias_mean'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    elseif ii==3
        contourf(latitudes,fliplr(-depths),flipud(Indian_ChangeRate_ssp126'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP1-2.6 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Indian_mask_ssp126==1)=0;
        temp_mask(Indian_mask_ssp126==0 & isnan(Indian_mean_hist))=0;
        temp_mask(Indian_mask_ssp126==0 & ~isnan(Indian_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7o_data.nc';
        var_name = 'thetao_ChangeRate';
        var_units = 'degrees Celsius per decade';
        title = "Zonally-averaged Potential Temperature Rate of Change in the Indian Ocean "+...
            "under SSP1-2.6 between 1995 and 2100; CMIP6 (CMIP & ScenarioMIP)";
        comments = "Data is for panel (o) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Indian_ChangeRate_ssp126'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    elseif ii==4
        contourf(latitudes,fliplr(-depths),flipud(Indian_ChangeRate_ssp370'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP3-7.0 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Indian_mask_ssp370==1)=0;
        temp_mask(Indian_mask_ssp370==0 & isnan(Indian_mean_hist))=0;
        temp_mask(Indian_mask_ssp370==0 & ~isnan(Indian_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
    elseif ii==5
        contourf(latitudes,fliplr(-depths),flipud(Indian_ChangeRate_ssp585'),20,'LineColor','none')
        caxis([-0.5 0.5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP5-8.5 Rate of Change", "("+size(model_names_sspvshistorical,2)+" models; "+ ...
            char(start_year_ssp)+"-"+ ...
            char(end_year_ssp)+")"}, 'fontsize', 25);
        hold on
        temp_mask(Indian_mask_ssp585==1)=0;
        temp_mask(Indian_mask_ssp585==0 & isnan(Indian_mean_hist))=0;
        temp_mask(Indian_mask_ssp585==0 & ~isnan(Indian_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
        
        ncfilename = '../Data/Fig9-7p_data.nc';
        var_name = 'thetao_ChangeRate';
        var_units = 'degrees Celsius per decade';
        title = "Zonally-averaged Potential Temperature Rate of Change in the Indian Ocean "+...
            "under SSP5-8.5 between 1995 and 2100; CMIP6 (CMIP & ScenarioMIP)";
        comments = "Data is for panel (p) of Figure 9.7 in the IPCC Working Group"+ ...
            " I contribution to the Sixth Assesment Report";
        IPCC_Write_NetCDF_Transect(ncfilename, var_name, var_units, flipud(Indian_ChangeRate_ssp585'), ...
            latitudes',fliplr(-depths)', title, comments, flipud(temp_mask'))
        clear title
        
    end
    xlim([-80 90])
    ylim([-2000 0])
    xticks([-80 -40 0 40 80])
    xticklabels({'', '', '', '', ''})
    yticks([-2000 -1500 -1000 -500 0])
     if ii==1
        yticklabels({'2', '', '1', '', '0'})
    else
        yticklabels({'', '', '', '', ''})
    end
    set(gca,'FontSize',fontsize)
    if ii==1
        title('');
        colorbar off
        yticklabels({'', '', '', '', ''})
        print(gcf,"../PNGs/Observed_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==2
        title('');
        colorbar off
        print(gcf,"../PNGs/Bias_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==3
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP126_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==4
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP370_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    elseif ii==5
        title('');
        colorbar off
        print(gcf,"../PNGs/SSP585_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
    end
   close(1)
end














