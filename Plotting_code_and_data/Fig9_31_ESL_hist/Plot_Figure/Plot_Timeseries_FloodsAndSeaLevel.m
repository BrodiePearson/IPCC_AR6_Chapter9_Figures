%% IPCC AR6 Chapter 9 Figure 9.31 (Amplification Factor and Flooding)
%
% Code used to plot the map of observected flood frequency changes
%
% Written by Billy Sweet

%compute daily max and number of exceedances above a threshold per year for
%6 UH Sea level Center tide gauge locations

%%obshourly is the matlab matrix variable with all hourly data that exists
%%for the 6 locations over the 1950-2018 period

clear
addpath ./Functions
load Data/uhslc_6hourly_1950_2018;
text=importdata('Data/station_thresholds.xlsx');
stname=text.textdata(:,1);
minor_threshold=text.data(:,4); % this is the 99th% as threshold
t = [datenum('jan-1-1950 00:00'):1/24:datenum('dec-31-2018 23:00')]'; %hourly time step

minor_yr=nan(69,6);

daily_max=nan(25202,6); %with will store daily max values 1950-2018 for 6 tide gauge locations 
annual_msl_yr=nan(69,6); %for years 1950-2018

figure('position',[10 10 1000 1000],'color','white')

counting=0;
for k = 1:6 
counting=counting+1;
minor=minor_threshold(counting);
st_name=stname(counting+1); % station name starts below 'station name' which is row 1

    h = obshourly(:,counting); %this is the stored parameter with all 291 location's hourly data foreced into a 1950 to 2018 hourly matrix with NaN time stamp blanks
    N=length(h);

%DAILY MAX
    [t1,h1,clusterdata]=dailymax(t,h,N);
    daily_max(:,counting)=h1;
    dv=datevec(t1);
    yrs=unique(dv(:,1));
    nyears=length(yrs);
    
    dv_hr=datevec(t);
    
    frq_minor = nan(nyears,1);
    annualmsl=nan(nyears,1);

      for k2 = 1:nyears
        kk=find(dv(:,1)==yrs(k2)); %isolate daily max data for each year
        kk_hr=find(dv_hr(:,1)==yrs(k2)); %isolate hourly data fro each year
        tt = t1(kk); 
        hh = h1(kk); 
        tt_hr=t(kk_hr);
        hh_hr=h(kk_hr);
        if length(find(~isnan(hh))) >= (.8*365.25)%only compute stats during a year with 80% hourly data                 
             
            frq_minor(k2,:) = length(find(hh >= minor));
            annualmsl(k2,:) = nanmean(hh_hr);
        end
      end

minor_yr(:,counting)=frq_minor;
annual_msl_yr(:,counting)=annualmsl;
   
  
    subplot(3,2,counting)

    bar(yrs,frq_minor, 'y')
    hold;
    lim_y = get(gca,'ylim');
    lim_x = get(gca,'xlim');
    xlim([1950 2020]);
    ylabel('Floods (days/year)', 'FontSize',12);
    title([st_name],'FontSize',12);
    %legend('Minor Tidal Flood (99% over 1995-2014)','Location', 'NorthWest');
    grid
    h1=gca;
    h2 = axes('Position',get(h1,'Position'));
    plot(yrs,(annualmsl-min(annualmsl))/1000,'b', 'linewidth',2);
    set(h2,'YAxisLocation','right','Color','none','XTickLabel',[]);
    set(h2,'XLim',get(h1,'XLim'),'Layer','top');
    ylabel('Annual RSL (m)','FontSize',12, 'color', 'blue');
    
end

    
    hgsave('../PNGs/RSL and tidalfloods');



    

    


