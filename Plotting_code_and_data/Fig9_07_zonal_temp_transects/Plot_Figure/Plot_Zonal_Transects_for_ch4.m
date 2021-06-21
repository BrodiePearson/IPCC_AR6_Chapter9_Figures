%% IPCC AR6 Chapter 9: Chapter 4 collaboration (Temperature Transects)
%
% Code used to plot temperature transects for Chapter 4 of IPCC AR6
%
% Plotting code written by Brodie Pearson

clear all

addpath ../../../Functions/

fontsize = 25;

savefile = './Processed_Data/Temperature_Transects_Full_Depth.mat';
load(savefile)

%% Define colorbars and calculate rates of change

div_colors = IPCC_Get_Colorbar('temperature_d',20,false);
nondiv_colors = IPCC_Get_Colorbar('temperature_nd',20,false);
bias_colors = IPCC_Get_Colorbar('chem_d', 20, true);
        
Global_ChangeRate_ssp126 = (Global_mean_ssp126 - Global_mean_hist);
Global_ChangeRate_ssp370 = (Global_mean_ssp370 - Global_mean_hist);
Global_ChangeRate_ssp585 = (Global_mean_ssp585 - Global_mean_hist);

Pacific_ChangeRate_ssp126 = (Pacific_mean_ssp126 - Pacific_mean_hist);
Pacific_ChangeRate_ssp370 = (Pacific_mean_ssp370 - Pacific_mean_hist);
Pacific_ChangeRate_ssp585 = (Pacific_mean_ssp585 - Pacific_mean_hist);

Atlantic_ChangeRate_ssp126 = (Atlantic_mean_ssp126 - Atlantic_mean_hist);
Atlantic_ChangeRate_ssp370 = (Atlantic_mean_ssp370 - Atlantic_mean_hist);
Atlantic_ChangeRate_ssp585 = (Atlantic_mean_ssp585 - Atlantic_mean_hist);

Indian_ChangeRate_ssp126 = (Indian_mean_ssp126 - Indian_mean_hist);
Indian_ChangeRate_ssp370 = (Indian_mean_ssp370 - Indian_mean_hist);
Indian_ChangeRate_ssp585 = (Indian_mean_ssp585 - Indian_mean_hist);

temp_mask = nan(size(Global_mean_hist));


%% Make Global plots (Once for titles, once for colorbars, once for non-colorbars)
figure('Position', [10 10 1200 1200])
for ii=3:5  
    h=colorbar('Location','SouthOutside');
    if ii==3
        subplot(4,3,1)
        contourf(latitudes,fliplr(-depths),flipud(Global_ChangeRate_ssp126'),20,'LineColor','none')
        caxis([-5 5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP1-2.6 Change"}, 'fontsize', 25);
        hold on
        temp_mask(Global_mask_ssp126==1)=0;
        temp_mask(Global_mask_ssp126==0 & isnan(Global_mean_hist))=0;
        temp_mask(Global_mask_ssp126==0 & ~isnan(Global_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
    elseif ii==4
        subplot(4,3,2)
        contourf(latitudes,fliplr(-depths),flipud(Global_ChangeRate_ssp370'),20,'LineColor','none')
        caxis([-5 5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP3-7.0 Change"}, 'fontsize', 25);
        hold on
        temp_mask(Global_mask_ssp370==1)=0;
        temp_mask(Global_mask_ssp370==0 & isnan(Global_mean_hist))=0;
        temp_mask(Global_mask_ssp370==0 & ~isnan(Global_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
    elseif ii==5
        subplot(4,3,3)
        contourf(latitudes,fliplr(-depths),flipud(Global_ChangeRate_ssp585'),20,'LineColor','none')
        caxis([-5 5])
        colormap(gca,div_colors)
        h=colorbar('Location','SouthOutside');
        title({"SSP5-8.5 Change"}, 'fontsize', 25);
        hold on
        temp_mask(Global_mask_ssp585==1)=0;
        temp_mask(Global_mask_ssp585==0 & isnan(Global_mean_hist))=0;
        temp_mask(Global_mask_ssp585==0 & ~isnan(Global_mean_hist))=1;
        [c2,h2] = contourf(latitudes,fliplr(-depths),flipud(temp_mask'),[1 1],'Fill','off'); % 
        set(h2,'linestyle','none','Tag','HatchingRegion');
        hp = findobj(gca,'Tag','HatchingRegion');
        hh = hatchfill2(hp(1),'single','HatchAngle',45,'LineWidth',1,'Fill','off');
    end
    xlim([-80 90])
    ylim([-6000 0])
    xticks([-80 -40 0 40 80])
    xticklabels({'', '', '', '', ''})
    yticks([-6000 -4500 -3000 -1500 0])
     if ii==1
        yticklabels({'6', '', '3', '', '0'})
    else
        yticklabels({'', '', '', '', ''})
    end
    set(gca,'FontSize',fontsize)
%     if ii==1
%         print(gcf,"../PNGs/Observed_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
%         title('');
% %        print(gcf,"../PNGs/Observed_Global_Temperature_Transects_Colorbar.png",'-dpng','-r1000', '-painters');
%         colorbar off
%         yticklabels({'', '', '', '', ''})
%         print(gcf,"../PNGs/Observed_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==2
%         print(gcf,"../PNGs/Bias_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
%         title('');
% %        print(gcf,"../PNGs/Bias_Global_Temperature_Transects_Colorbar.png",'-dpng','-r1000', '-painters');
%         colorbar off
%         print(gcf,"../PNGs/Bias_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==3
%         print(gcf,"../PNGs/SSP126_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
%         title('');
% %        print(gcf,"../PNGs/SSP126_Global_Temperature_Transects_Colorbar.png",'-dpng','-r1000', '-painters');
%         colorbar off
%         print(gcf,"../PNGs/SSP126_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==4
%         print(gcf,"../PNGs/SSP370_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP370_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==5
%         print(gcf,"../PNGs/SSP585_Global_Temperature_Transects_Titled.png",'-dpng','-r1000', '-painters');
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP585_Global_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     end
%    close(1)
end

%% Make Pacific plots 

for ii=3:5  
    h=colorbar('Location','SouthOutside');
    if ii==3
        subplot(4,3,4)
        contourf(latitudes,fliplr(-depths),flipud(Pacific_ChangeRate_ssp126'),20,'LineColor','none')
        caxis([-5 5])
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
    elseif ii==4
        subplot(4,3,5)
        contourf(latitudes,fliplr(-depths),flipud(Pacific_ChangeRate_ssp370'),20,'LineColor','none')
        caxis([-5 5])
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
        subplot(4,3,6)
        contourf(latitudes,fliplr(-depths),flipud(Pacific_ChangeRate_ssp585'),20,'LineColor','none')
        caxis([-5 5])
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
    end
    xlim([-80 90])
    ylim([-6000 0])
    xticks([-80 -40 0 40 80])
    xticklabels({'', '', '', '', ''})
    yticks([-6000 -4500 -3000 -1500 0])
     if ii==1
        yticklabels({'6', '', '3', '', '0'})
    else
        yticklabels({'', '', '', '', ''})
    end
    set(gca,'FontSize',fontsize)
%     if ii==1
%         title('');
%         colorbar off
%         yticklabels({'', '', '', '', ''})
%         print(gcf,"../PNGs/Observed_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==2
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/Bias_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==3
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP126_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==4
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP370_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==5
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP585_Pacific_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     end
%    close(1)
end

%% Make Atlantic plots

for ii=3:5  
    h=colorbar('Location','SouthOutside');
    if ii==3
        subplot(4,3,7)
        contourf(latitudes,fliplr(-depths),flipud(Atlantic_ChangeRate_ssp126'),20,'LineColor','none')
        caxis([-5 5])
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
    elseif ii==4
        subplot(4,3,8)
        contourf(latitudes,fliplr(-depths),flipud(Atlantic_ChangeRate_ssp370'),20,'LineColor','none')
        caxis([-5 5])
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
        subplot(4,3,9)
        contourf(latitudes,fliplr(-depths),flipud(Atlantic_ChangeRate_ssp585'),20,'LineColor','none')
        caxis([-5 5])
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
    end
    xlim([-80 90])
    ylim([-6000 0])
    xticks([-80 -40 0 40 80])
    xticklabels({'', '', '', '', ''})
    yticks([-6000 -4500 -3000 -1500 0])
     if ii==1
        yticklabels({'6', '', '3', '', '0'})
    else
        yticklabels({'', '', '', '', ''})
    end
    set(gca,'FontSize',fontsize)
%     if ii==1
%         title('');
%         colorbar off
%         yticklabels({'', '', '', '', ''})
%         print(gcf,"../PNGs/Observed_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==2
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/Bias_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==3
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP126_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==4
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP370_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==5
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP585_Atlantic_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     end
%    close(1)
end

%% Make Indian plots

for ii=3:5  
    h=colorbar('Location','SouthOutside');
    if ii==3
        subplot(4,3,10)
        contourf(latitudes,fliplr(-depths),flipud(Indian_ChangeRate_ssp126'),20,'LineColor','none')
        caxis([-5 5])
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
    elseif ii==4
        subplot(4,3,11)
        contourf(latitudes,fliplr(-depths),flipud(Indian_ChangeRate_ssp370'),20,'LineColor','none')
        caxis([-5 5])
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
        subplot(4,3,12)
        contourf(latitudes,fliplr(-depths),flipud(Indian_ChangeRate_ssp585'),20,'LineColor','none')
        caxis([-5 5])
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
    end
    xlim([-80 90])
    ylim([-6000 0])
    xticks([-80 -40 0 40 80])
    xticklabels({'-80', '', '0', '', '80'})
    yticks([-6000 -4500 -3000 -1500 0])
     if ii==1
        yticklabels({'6', '', '3', '', '0'})
    else
        yticklabels({'', '', '', '', ''})
    end
    set(gca,'FontSize',fontsize)
%     if ii==1
%         title('');
%         colorbar off
%         yticklabels({'', '', '', '', ''})
%         print(gcf,"../PNGs/Observed_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==2
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/Bias_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==3
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP126_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==4
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP370_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     elseif ii==5
%         title('');
%         colorbar off
%         print(gcf,"../PNGs/SSP585_Indian_Temperature_Transects.png",'-dpng','-r1000', '-painters');
%     end
%    close(1)
end














