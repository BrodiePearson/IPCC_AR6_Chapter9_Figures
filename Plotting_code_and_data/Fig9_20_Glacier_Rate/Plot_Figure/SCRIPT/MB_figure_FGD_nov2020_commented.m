clear all
clc
format long g

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description
%Figure 9.21: Global and regional glacier mass change rate between 1960 and 2019.
%
% Includes:
%
% Annual and decadal glacier mass change rates and its respective uncertainty from Zemp et al.
% (2019) and Zemp et al. (2020).
%
% Glacier mass change rates between 2002-2016 and its respective uncertainty obtained by Wouters et al. (2019).
%
% Glacier mass change rate between 2006-2016 and its respective uncertainty as it was assessed in SROCC (Table A2 of SROCC)
%
% Glacier mass change rates between 2000-2009 and 2010-2019 and its respective uncertainty obtained by Hugonnet et al. (submitted). 
%
% Global(all) =  All glaciers of world.
%
% Global(excep 5&19) = All glaciers except those peripheral to ice sheets
% (RGI regions 5 and 19).
%
% RGI regions like in the SROCC, where High Mountain Asia (HMA) is the sum of 
% RGI regions 13, 14 and 15).
%
% Inputs:

% Zemp et al., (2019) Regional glacier mass balance
%
% Wouters et al., (2019) 2002-2016 regional glacier mass balance
%
% SROCC Table 2A 2006-2015 regional glacier mass balance
%
% Hugonnet et al., (2021) 2000-2009 and 2010-2019 regional glacier mass
% balance
%
%  Aðalgeirsdóttir et al., (2020) annual glacier mass balance for Iceland

 
  %% Figure filename
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Define the name of  *.eps and *.pdf file 
 figure_filename= 'Glacier_mb_FGD_v5';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% Time period
t_mean = [1962 2016];
%decadal time period
time_period = [1960:10:2020];
n=1;
% create xticks names
for j = 1:2:length(time_period);
tick_time(1,j) = {num2str(time_period(j))};

end

 %% Regions names and numbers
 % Names and numbers (used in the titles of each plot)
 regionnames = { 'Global' 'Global' 'Alaska' 'West Canada and U.S.' 'Arctic Canada (N)' 'Arctic Canada (S)' 'Greenland periphery' 'Iceland' 'Svalbard' 'Scandinavia' 'Russian Arctic' 'North Asia' 'Central Europe' 'Caucasus' 'High Mountain Asia' 'Low Latitudes' 'Southern Andes' 'New Zealand' 'Antarctic periphery.'};
 
 regions_numbers = { 'all' 'except 5&19' '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13-15' '16' '17' '18' '19'}; 

 %% Define Regions variable
 
  %Used to select time series from input files
regions = (1:1:19);

% Used to merge regions 13,14 and 15 into High Mountain Asia HMA (13) 
regions_new = [20,21,1,2,3,4,5,6,7,8,9,10,11,12,13,16,17,18,19];

%Select what to use for High Mountain of Asia (13)
HMA = [13 14 15];

%Select what to use for Global with peripheral glaciers (20).
GLOBAL =(1:1:19);

%select what to use for Global without  peripheral glaciers (21). 
GLOBAL_2 = [1,2,3,4,6,7,8,9,10,13,14,15,16,17,18];


 %% Data input
 % Please include each correct path
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Just include the path where the figure folder is located (Must be changed)

 Baylor=1;
 Lucas=2;
 User=Baylor;
 
 if User==Lucas
 folder_path ='c:\Users\lcsru\OneDrive\Documents\IPCC-AR6\09-FGD\';
 elseif User==Baylor
 folder_path ='../../';
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 if User==Lucas
 % Zemp et al. (2019) time series of global mass balance changes 
  % (supplementary materials)
 folder_ZEMP_SM = [folder_path,'Chapter9_Obs_glacier_mass_balance_figure\INPUT_DATA\Zemp_etal_results_regions\'];
 
 % Copy of  SROCC Table A2
 file_SROCC= [folder_path,'Chapter9_Obs_glacier_mass_balance_figure\INPUT_DATA\SROCC_TABLE_A2.xlsx'];
 
% Copy of Wouters et al., (2019) Table 1 
 wouters_file =[folder_path,'Chapter9_Obs_glacier_mass_balance_figure\INPUT_DATA\Wouters_etal_2019_table1.xlsx'];
  
 % Table with 10yr period mass change from Hugonnet et al., (2021) prepared by the authors for the AR6
 file_hugonnet = [folder_path,'Chapter9_Obs_glacier_mass_balance_figure\INPUT_DATA\table_hugonnet_regions_10yr_ar6period.xlsx'];

 % % Table with annual glacier mass balance for Iceland's glaciers from
 % Aðalgeirsdóttir et al., (2020) prepared by the authors for the AR6.
iceland_file = [folder_path,'Chapter9_Obs_glacier_mass_balance_figure\INPUT_DATA\Iceland_bn_all_glaciers-1890_91-2018_19.xlsx'];
 elseif User==Baylor
     
     % Zemp et al. (2019) time series of global mass balance changes 
  % (supplementary materials)
 folder_ZEMP_SM = [folder_path,'Chapter9_Obs_glacier_mass_balance_figure/INPUT_DATA/Zemp_etal_results_regions/'];
 
 % Copy of  SROCC Table A2
 file_SROCC= [folder_path,'Chapter9_Obs_glacier_mass_balance_figure/INPUT_DATA/SROCC_TABLE_A2.xlsx'];
 
% Copy of Wouters et al., (2019) Table 1 
 wouters_file =[folder_path,'Chapter9_Obs_glacier_mass_balance_figure/INPUT_DATA/Wouters_etal_2019_table1.xlsx'];
  
 % Table with 10yr period mass change from Hugonnet et al., (2021) prepared by the authors for the AR6
 file_hugonnet = [folder_path,'Chapter9_Obs_glacier_mass_balance_figure/INPUT_DATA/table_hugonnet_regions_10yr_ar6period.xlsx'];

 % % Table with annual glacier mass balance for Iceland's glaciers from
 % Aðalgeirsdóttir et al., (2020) prepared by the authors for the AR6.
iceland_file = [folder_path,'Chapter9_Obs_glacier_mass_balance_figure/INPUT_DATA/Iceland_bn_all_glaciers-1890_91-2018_19.xlsx'];
     
 end
 
%% Set figure format and colors for each line
 
% Define the color of each shaded area and line
% following IPCC Colorscheme

if User==Lucas
% load colorscheme file
    load([folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\colorscheme.mat.mat'])
elseif User==Baylor
    load(['../INPUT_DATA/colorscheme.mat.mat'])
end

% Shaded areas colors
shade_rgb =  colorscheme_RGB. shade_0_RGB;

% Line colors
line_rgb =  colorscheme_RGB. line_6_RGB;

% Aðalgeirsdóttir et al., (2020) data for Iceland's glaciers
Iceland_shading =  [shade_rgb(2,:)];
Iceland_line =  [line_rgb(2,:)];

 % Zemp et al., (2019 and 2020) 
Zemp_shading = [shade_rgb(4,:)]; 
Zemp_line = [line_rgb(4,:)];

% SROCC Table 2A
SROCC_shading = [shade_rgb(3,:)]; 
SROCC_line =[line_rgb(3,:)]; 

% Wouters et al., (2019)
Wouters_shading = [shade_rgb(5,:)]; 
Wouters_line =[line_rgb(5,:)]; 

%  Hugonnet et al., (2021) 
Hugonnet_shading = [shade_rgb(6,:)]; 
Hugonnet_line = [line_rgb(6,:)]; 

%delete variables created to upload colorscheme
clear colorscheme_RGB line_RGB shade_rgb

% Define the extent and position of  the figure and the different subplots
% Figure width [mm]
w_fig = 180; 
% Figure height [mm]
h_fig = 250; 

% Margins and separation of subplots 
bot_line =15; % bottom space [mm]
sep_v =15; % vertical separation between subplots [mm]
sep_h = 10; % horizontal separation between subplots [mm]
left_line =15; % left margin [mm]

% Width of the subplot [mm]
w = 30; 
% Height of the subplot [mm]
h = 32; 

% Create Position vector for each of the subplots  [left, bottom,width,height]./normalized
bottom =[(4*h+4*sep_v+bot_line);(4*h+4*sep_v+bot_line);(4*h+4*sep_v+bot_line);(4*h+4*sep_v+bot_line);...
                    (3*h+3*sep_v+bot_line);(3*h+3*sep_v+bot_line);(3*h+3*sep_v+bot_line);(3*h+3*sep_v+bot_line);...
                    (2*h+2*sep_v+bot_line);(2*h+2*sep_v+bot_line);(2*h+2*sep_v+bot_line);(2*h+2*sep_v+bot_line);...
                    (1*h+1*sep_v+bot_line);(1*h+1*sep_v+bot_line);(1*h+1*sep_v+bot_line);(1*h+1*sep_v+bot_line);...
                    bot_line;bot_line;bot_line;bot_line];
                
left = [left_line;(1*w+1*sep_h+left_line);(2*w+2*sep_h+left_line);(3*w+3*sep_h+left_line);...                    
         left_line;(1*w+1*sep_h+left_line);(2*w+2*sep_h+left_line);(3*w+3*sep_h+left_line);...               
         left_line;(1*w+1*sep_h+left_line);(2*w+2*sep_h+left_line);(3*w+3*sep_h+left_line);...          
          left_line;(1*w+1*sep_h+left_line);(2*w+2*sep_h+left_line);(3*w+3*sep_h+left_line);...          
         left_line;(1*w+1*sep_h+left_line);(2*w+2*sep_h+left_line);(3*w+3*sep_h+left_line)];
     
w = w.*ones(20,1);
h = h.*ones(20,1); 

%position vector [left, bottom,width,height]./normalized
position_plots = [left./w_fig,bottom./h_fig,w./w_fig,h./h_fig]; 

%delete variables created to generate the position vector
clear width height left bottom
 
 %% Read Wouters et al., (2019) data set 
 [raw_wouters] = xlsread(wouters_file,1,'A4:H19');
 
 % Regions
wouters_regions = raw_wouters(:,1);
% Glacier mass balance as kg m-2 yr-1
mb_wouters = raw_wouters(:,5:6);
% Time period
 wouters_time = [2002 2016];
 
 % delete the variables created to upload Wouters et al., (2020) data
 clear raw_wouters

%% Read  and Process glacier mass change between 1962 to 2015 of Zemp et al., (2019) 
% Read Zemp et al. (2019) supplementary file  for each region with the
% annual glacier mass change time serie.
% Uncertainty is 90% CI

% File order could be different in other PC. 
file_order =[10,11,12,13,14,15,16,17,18,19,1,2,3,4,5,6,7,8,9];

% List of file in the folder 
list= dir(folder_ZEMP_SM);

% Loop to extract the data of Zemp et al., (2019) for each region and create the matrix with all
% the regions
for j=1:1:19;
   
    % Search for the regions using file_order
    location = find(file_order==j);
    
     %filename
    filename = [folder_ZEMP_SM,list(location+2).name];
    
    %Display filename and location to check matching
    display(['Region = ',num2str(j)]);
    display(list(location+2).name);
    
    % Read the csv file
    M = csvread(filename,28,0);
    % time vector
    time =M(:,1);
    %Selection of time from 1962
    sel_time =find(time>=1962);
    
    % Time reference vector for all the Zemp et al., (2019) data
    zemp_time = time(sel_time);
    
    % Read the different variables of Zemp et al., (2019)
     int_mwe(:,j) = M(sel_time,2);
     e_glac_mwe(:,j) = M(sel_time,5);
     e_geod_mwe(:,j) = M(sel_time,6);
     e_int_mwe(:,j) = M(sel_time,7);
     e_tot_mwe(:,j) = M(sel_time,8);
     area_km2(:,j) = M(sel_time,9);
     int_gt(:,j) = M(sel_time,11); 
     e_glac_gt(:,j) = M(sel_time,14); 
     e_geod_gt(:,j) = M(sel_time,15);
     e_int_gt(:,j) = M(sel_time,16);
     e_area_gt(:,j) = M(sel_time,17);
     e_cross_gt(:,j) = M(sel_time,18);
     e_tot_gt(:,j) = M(sel_time,19);
     
     % Delete variables create in the loop
    clear M
end

% Delete variables create to upload the data
clear file_order list
 
 % Select time
  sel_time = find(zemp_time>=t_mean(1) & zemp_time<=t_mean(2));

  % Calculate the annual glacier mass balance for each regions as SROCC
  % between 1962 and 2015
   for j =1:1:length(regions_new);
      m = regions_new(j);
      if m<13;
                      % Annual glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]
                     mb_zemp_time_serie(j,:) = (int_mwe(sel_time,m)).*1e3;
                     % Uncertainty in annual glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]
                      e_mb_zemp_serie(j,:) = (e_tot_mwe(sel_time,m))*1e3;
             
      elseif m==13;
                     area = sum(area_km2(sel_time,HMA),2); 
                     int = sum(int_gt(sel_time,HMA),2);
                     e = sqrt(sum(e_tot_gt(sel_time,HMA).^2,2));
                     % Annual glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]
                     mb_zemp_time_serie(j,:) = (int./area).*1e6;
                     % Uncertainty in annual glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]
                    e_mb_zemp_serie(j,:) = (e./area).*1e6;    
                    
                    % Delete variables create in the conditional
                    clear area int e           
                      
      elseif m>=16 && m<=19;
                     % Annual glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]
                     mb_zemp_time_serie(j,:) = (int_mwe(sel_time,m)).*1e3;
                     % Uncertainty in annual glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]
                     e_mb_zemp_serie(j,:) = (e_tot_mwe(sel_time,m))*1e3;
             
      elseif m==20;
                     area = sum(area_km2(sel_time,GLOBAL),2); 
                     int = sum(int_gt(sel_time,GLOBAL),2);
                     e = sqrt(sum(e_tot_gt(sel_time,GLOBAL).^2,2));
                     % Global annual glacier mass balance  between 1962-2015 [kg m-2 yr-1]
                     mb_zemp_time_serie(j,:) = (int./area).*1e6;
                      % Uncertainty in Global annual glacier mass balance  between 1962-2015 [kg m-2 yr-1]
                    e_mb_zemp_serie(j,:) = (e./area).*1e6; 
                    % Delete variables create in the conditional
                   clear area int e           
                        
      elseif m==21;               
                     area = sum(area_km2(sel_time,GLOBAL_2),2); 
                     int = sum(int_gt(sel_time,GLOBAL_2),2);
                     e = sqrt(sum(e_tot_gt(sel_time,GLOBAL_2).^2,2));
                      % Global (exp RGI 5 and 19) annual glacier mass balance  between 1962-2015 [kg m-2 yr-1]
                      mb_zemp_time_serie(j,:) = (int./area).*1e6;
                      % Uncertainty in global (exp RGI 5 and 19) annual glacier mass balance  between 1962-2015 [kg m-2 yr-1]
                      e_mb_zemp_serie(j,:) = (e./area).*1e6;    
                      
                      % Delete variables create in the conditional
                      clear area int e     
   end
 end
 
 
% Calculate decadal glacier mass balance for each regions as SROCC
% between 1962 and 2015
 for j =1:1:length(regions_new);
    for k =1:1:length(time_period)-1;
      % select decade  
      sel_time = find(zemp_time>=time_period(k) & zemp_time<=time_period(k+1));
      % select regions
      m = regions_new(j);
      if m<13;
                     % Decadal glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]
                      mean_mb_period(j,1,k) = mean(int_mwe(sel_time,m))*1e3;
                      
                      e_glac = (sqrt(sum(e_glac_mwe(sel_time,m).^2)))/length(sel_time);
                      e_geod = sum(e_geod_mwe(sel_time,m))/length(sel_time);
                      e_int = (sqrt(sum(e_int_mwe(sel_time,m).^2)))/length(sel_time);
                      
                      % Uncertainty in decadal glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]         
                      mean_mb_period(j,2,k) = sqrt(e_glac^2+e_geod^2+e_int^2)*1e3;
                      
                      % delete variables create in the conditional
                      clear e_glac e_geod e_int
             
      elseif m==13;
                  
                     area = sum(area_km2(sel_time,HMA),2); 
                     int = sum(int_gt(sel_time,HMA),2);
                     
                     % Decadal glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]
                     mean_mb_period(j,1,k) = (mean(int)/mean(area))*1e6;
                                          
                      e_glac = sqrt(sum(e_glac_gt(sel_time,HMA).^2,2));
                      e_geod = sqrt(sum(e_geod_gt(sel_time,HMA).^2,2));
                      e_int = sqrt(sum(e_int_gt(sel_time,HMA).^2,2));
                      e_area = sqrt(sum(e_area_gt(sel_time,HMA).^2,2));
                      e_cross = sqrt(sum(e_cross_gt(sel_time,HMA).^2,2));
                      
                      % Uncertainty in decadal glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]         
                       mean_mb_period(j,2,k)  = (sqrt((sqrt(sum(e_glac.^2))/length(e_glac))^2+(sum(e_geod)/length(e_geod))^2+...
                                                     (sqrt(sum(e_int.^2))/length(e_int))^2+(sum(e_area)/length(e_area))^2+...
                                                     (sqrt(sum(e_cross.^2))/length(e_cross))^2))/mean(area)*1e6;    
                       
                       % Delete variables created in then conditional
                       clear area int e_glac e_geod e_int e_area e_cross           
                      
      elseif m>=16 && m<=19;
                      % Decadal glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]
                      mean_mb_period(j,1,k) = mean(int_mwe(sel_time,m))*1e3;
                      
                      e_glac = (sqrt(sum(e_glac_mwe(sel_time,m).^2)))/length(sel_time);
                      e_geod = sum(e_geod_mwe(sel_time,m))/length(sel_time);
                      e_int = (sqrt(sum(e_int_mwe(sel_time,m).^2)))/length(sel_time);
                      
                       % Uncertainty in decadal glacier mass balance for each region between 1962-2015 [kg m-2 yr-1]         
                      mean_mb_period(j,2,k) = sqrt(e_glac^2+e_geod^2+e_int^2)*1e3;
                      
                      % Delete variables create in the conditional
                      clear e_glac e_geod e_int
      
      elseif m==20;
               
                     area = sum(area_km2(sel_time,GLOBAL),2); 
                     int = sum(int_gt(sel_time,GLOBAL),2);
                     % Global decadal glacier mass balance  between 1962-2015 [kg m-2 yr-1]
                     mean_mb_period(j,1,k) = (mean(int)/mean(area))*1e6;
                                          
                      e_glac = sqrt(sum(e_glac_gt(sel_time,GLOBAL).^2,2));
                      e_geod = sqrt(sum(e_geod_gt(sel_time,GLOBAL).^2,2));
                      e_int = sqrt(sum(e_int_gt(sel_time,GLOBAL).^2,2));
                      e_area = sqrt(sum(e_area_gt(sel_time,GLOBAL).^2,2));
                      e_cross = sqrt(sum(e_cross_gt(sel_time,GLOBAL).^2,2));
                      
                      % Uncertainty in global decadal glacier mass balance  between 1962-2015 [kg m-2 yr-1]
                      mean_mb_period(j,2,k)  = (sqrt((sqrt(sum(e_glac.^2))/length(e_glac))^2+(sum(e_geod)/length(e_geod))^2+...
                                                     (sqrt(sum(e_int.^2))/length(e_int))^2+(sum(e_area)/length(e_area))^2+...
                                                     (sqrt(sum(e_cross.^2))/length(e_cross))^2))/mean(area)*1e6;    
                      
                      % Delete variables create in the conditional
                      clear area int e_glac e_geod e_int e_area e_cross  
                      
      elseif m==21;
               
                     area = sum(area_km2(sel_time,GLOBAL_2),2); 
                     int = sum(int_gt(sel_time,GLOBAL_2),2);
                     
                     % Global (exp RGI 5 and 19) decadal glacier mass balance  between 1962-2015 [kg m-2 yr-1]
                     mean_mb_period(j,1,k) = (mean(int)/mean(area))*1e6;
                                          
                      e_glac = sqrt(sum(e_glac_gt(sel_time,GLOBAL_2).^2,2));
                      e_geod = sqrt(sum(e_geod_gt(sel_time,GLOBAL_2).^2,2));
                      e_int = sqrt(sum(e_int_gt(sel_time,GLOBAL_2).^2,2));
                      e_area = sqrt(sum(e_area_gt(sel_time,GLOBAL_2).^2,2));
                      e_cross = sqrt(sum(e_cross_gt(sel_time,GLOBAL_2).^2,2));
               
                      % Uncertainty in global (exp RGI 5 and 19) decadal glacier mass balance  between 1962-2015 [kg m-2 yr-1]
                       mean_mb_period(j,2,k)  = (sqrt((sqrt(sum(e_glac.^2))/length(e_glac))^2+(sum(e_geod)/length(e_geod))^2+...
                                                     (sqrt(sum(e_int.^2))/length(e_int))^2+(sum(e_area)/length(e_area))^2+...
                                                     (sqrt(sum(e_cross.^2))/length(e_cross))^2))/mean(area)*1e6;    
                      
                      % Delete variables create in the conditional
                      clear area int e_glac e_geod e_int e_area e_cross           
       
      end
      % Delete variables create in the loop
      clear sel_time
    end
 end
 
 % Delete variables create make the calculations
 clear e_area_gt e_cross_gt e_geod_gt e_geod_mwe e_glac_gt e_int_gt 
 
%% Read SROCC Table A2

% read file
srocc_table =xlsread(file_SROCC);
% SROCC regions
srocc_regions = srocc_table(:,1);
% SROCC glacier mass balance [kg m-2 yr-1]
srocc_mb = srocc_table(:,4);
% SROCC glacier mass balance  uncertainty [kg m-2 yr-1]
srocc_mb_e = srocc_table(:,5);
% SROCC time span
srocc_time = [2006 2015];
% delete variables created to upload the data
clear srocc_table

 %% Read Hugonnet et al., (2021) decadal values

%Read file
 [raw,text,all] = xlsread(file_hugonnet,1,'A2:F58');
 
 
 % time periods
 time_periods = cell2mat(text(1:end,1));
  [time_idx,time_label] = grp2idx(time_periods);
 t_1 = str2num(time_periods(:,1:4));
 t_2 = str2num(time_periods(:,12:15));
 time_window = [t_1 t_2];
 
 % Regions
  regions_file = raw(:,1);
 
  % mass balance kg m-2 yr-1
  mass_balance_kg = raw(:,5:6);
  
  % mass balance Gt yr-1
  mass_balance_gt = raw(:,3:4);
  
  % first period selection
 p1_hugonnet = 1:3:55;
 % second period selection
 p2_hugonnet = 2:3:56;

 % Mass balance period value 10 yr period  
 hugo_mb_p1 =   mass_balance_kg(p1_hugonnet,:);
 hugo_mb_p2 =   mass_balance_kg(p2_hugonnet,:);
 
 hugo_gt_p1 =   mass_balance_gt(p1_hugonnet,:);
 hugo_gt_p2 =   mass_balance_gt(p2_hugonnet,:);

 t1_hugonnet = [2000 2009];
 t2_hugonnet = [2010 2019];
 
 % Area values from Extended data Table 1 of Hugonnet et al., (2021)
 % used to calculate the mass balance [km2]
 HMA_area = sum([49903;33568;14734]);
 GLOBAL_area = 705997;
 GLOBAL_2_area = 483413;
 
% Create the decadal mass balance for the HMA, Global and Global (exp RGI 5
% and 19)
  for j =1:1:length(regions_new);
       m = regions_new(j);
       if m<13;          
           % For regions 1 to 13 just take the original values
           mass_balance1(j,:) = hugo_mb_p1(m,:); 
           mass_balance2(j,:) = hugo_mb_p2(m,:);
       elseif m==13;
           % For the HMA sum the values of RGI 13, 14 and 15)
           mass_balance1(j,1) = (sum(hugo_gt_p1(HMA,1))./HMA_area).*1e6;
           mass_balance1(j,2) = ((sqrt(sum(hugo_gt_p1(HMA,2).^2)))./HMA_area).*1e6;
           mass_balance2(j,1) =  (sum(hugo_gt_p2(HMA,1))./HMA_area).*1e6;
           mass_balance2(j,2) = ((sqrt(sum(hugo_gt_p1(HMA,2).^2)))./HMA_area).*1e6;
      elseif m>=16 && m<=19;
          % For regions 16 to 19 just take the original values
           mass_balance1(j,:) = hugo_mb_p1(m,:); 
           mass_balance2(j,:) = hugo_mb_p2(m,:);
       elseif m==20;
            % For the Global sum all the regions (1 to 19)
           mass_balance1(j,1) = (sum(hugo_gt_p1(GLOBAL,1))./GLOBAL_area).*1e6;
           mass_balance1(j,2) = ((sqrt(sum(hugo_gt_p1(GLOBAL,2).^2)))./GLOBAL_area).*1e6;
           mass_balance2(j,1) =  (sum(hugo_gt_p2(GLOBAL,1))./GLOBAL_area).*1e6;
           mass_balance2(j,2) = ((sqrt(sum(hugo_gt_p1(GLOBAL,2).^2)))./GLOBAL_area).*1e6;
      elseif m==21;
          % For the Global (exp RGI 5 and 19)
           mass_balance1(j,1) = (sum(hugo_gt_p1(GLOBAL_2,1))./GLOBAL_2_area).*1e6;
           mass_balance1(j,2) = ((sqrt(sum(hugo_gt_p1(GLOBAL_2,2).^2)))./GLOBAL_2_area).*1e6;
           mass_balance2(j,1) =  (sum(hugo_gt_p2(GLOBAL_2,1))./GLOBAL_2_area).*1e6;
           mass_balance2(j,2) = ((sqrt(sum(hugo_gt_p1(GLOBAL_2,2).^2)))./GLOBAL_2_area).*1e6;  
      end
  end
  
% delete variables created to upload the data 
clear raw text all
  %% Read and process Aðalgeirsdóttir et al., (2020) data 
  % Read file
  raw_iceland = xlsread(iceland_file);
  % Time
  time_iceland = raw_iceland(:,1);
  % Selection of time variable
   sel_time_ice = find(time_iceland>=1962);
  % Time variable used in the plot
  t_iceland = time_iceland(sel_time_ice);
  % Iceland's glaciers annual mass balance [kg m-2 yr-1]
  mb_iceland = raw_iceland(sel_time_ice,7).*1e3;
  % Delete variables create to upload the data
  clear raw_iceland sel_time_ice time_iceland

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %% Create the figure
    figure(1)
    % size of figure defined by IPCC visual style guide [cm]
     figSize = [1 1 w_fig/10 h_fig/10]; 
 % set size and position
     set(gcf,'units','centimeters','position',figSize,'paperposition',figSize);

% Start the loop of the figure
  for k = 1:1:length(regions_new)
  
   j = regions_new(k);  %to be used if the order of the plots and time series do not agree
  
   % subplot positions
   subplot('Position',position_plots(k,:) ) 
        
  % Plot annual glacier mass balance from Zemp et al., (2019) uncertainty 
  y_zemp1_annual =  (mb_zemp_time_serie(k,:)+e_mb_zemp_serie(k,:));
  y_zemp2_annual =  (mb_zemp_time_serie(k,:)-e_mb_zemp_serie(k,:));
  shadedplot(zemp_time, y_zemp1_annual, y_zemp2_annual,Zemp_shading);
  hold on
  
  % Plot annual glacier mass balance from Zemp et al., (2019) data   
  p_zemp_annual = plot(zemp_time,mb_zemp_time_serie(k,:),'LineStyle', '-','Color',Zemp_line,'LineWidth',1);
  hold on
  
  % Condition to include the  Aðalgeirsdóttir et al., (2020) data 
  % in the Iceland (RGI region 6) subplot
  if j == 6;
  
  % Plot annual glacier mass balance from Aðalgeirsdóttir et al., (2020) uncertainty
  % ATTENTION WE ARE USING A 25% UNCERTAINTY TO BE UPDATED
  y_ice1_annual =  mb_iceland+0.25.*abs(mb_iceland);
  y_ice2_annual =   mb_iceland-0.25.*abs(mb_iceland);
  shadedplot(t_iceland, y_ice1_annual', y_ice2_annual',Iceland_shading);
  hold on
   % Plot annual glacier mass balance from Aðalgeirsdóttir et al., (2020)
   % data
  p_ice_annual = plot(t_iceland,mb_iceland,'LineStyle', '-','Color',Iceland_line,'LineWidth',2);
  hold on
 
  end
  
  % Internal loop to plot the decadal mass balance rate for each region
  for t_idx = 1:1:length(time_period)-1;
     %
     % Plot decadal glacier mass balance from Zemp et al., (2019) uncertainty 
     y_zemp1 =  (mean_mb_period(k,1,t_idx)+mean_mb_period(k,2,t_idx)).*ones(1,2);
     y_zemp2 = (mean_mb_period(k,1,t_idx)-mean_mb_period(k,2,t_idx)).*ones(1,2);
     shadedplot(time_period(1,t_idx:t_idx+1), y_zemp1, y_zemp2,Zemp_shading.*1.2);
     hold on
       
      % Plot decadal glacier mass balance from Zemp et al., (2019) data   
     p_zemp = plot(time_period(1,t_idx:t_idx+1),mean_mb_period(k,1,t_idx).*ones(1,2),...
         'LineStyle', '-','Color',Zemp_line.*1.2,'LineWidth',2);
     hold on
  end
      % Plot Wouters et al., (2019) uncertainty  
      % Since there is no data for all of the regions, first we need to
      % check if there is data to plot
      if isempty(mb_wouters(wouters_regions==j,1))==0;
          % upper curve of uncertainty       
          y_1_wouters = (mb_wouters(wouters_regions==j,1)+mb_wouters(wouters_regions==j,2)).*ones(1,2);
         % lower curve of uncertainty
         y_2_wouters =(mb_wouters(wouters_regions==j,1)-mb_wouters(wouters_regions==j,2)).*ones(1,2);
        %Plot uncertaintyin Wouters et al., (2019) as shaded area
         shadedplot(wouters_time, y_1_wouters, y_2_wouters,Wouters_shading);
      end
     
     hold on
    
        
     % Plot SROCC Table 2A uncertainty
     % upper curve of uncertainty
     y_1_srocc = (srocc_mb(srocc_regions==j,1)+srocc_mb_e(srocc_regions==j,1)).*ones(1,2);
      % lower curve of uncertainty
     y_2_srocc =(srocc_mb(srocc_regions==j,1)-srocc_mb_e(srocc_regions==j,1)).*ones(1,2);
     %Plot uncertainty in SROCC asshaded area
     shadedplot( srocc_time, y_1_srocc, y_2_srocc,SROCC_shading);
      hold on
    
     % Plot Hugonnet et al., (2021) first period uncertainty
     % upper curve of uncertainty
     y_1_hugo =(mass_balance1(k,1)+mass_balance1(k,2))*ones(1,2);
      % lower curve of uncertainty
     y_2_hugo =(mass_balance1(k,1)-mass_balance1(k,2))*ones(1,2);
     %Plot uncertainty in Hugonnet et al., (2021) as shaded area
     shadedplot(t1_hugonnet , y_1_hugo, y_2_hugo,Hugonnet_shading);
     hold on
     
      % Plot Hugonnet et al., (2021) second period uncertainty
     y_1_hugo =(mass_balance2(k,1)+mass_balance2(k,2))*ones(1,2);
      % lower curve of uncertainty
     y_2_hugo =(mass_balance2(k,1)-mass_balance2(k,2))*ones(1,2);
     %Plot uncertainty in Hugonnet et al., (2021) as shaded area
     shadedplot(t2_hugonnet , y_1_hugo, y_2_hugo,Hugonnet_shading);
     hold on
     
      % Plot Wouters et al., (2019) data   
      % Since there is no data for all of the regions, first we need to
      % check if there is data to plot
     if isempty(mb_wouters(wouters_regions==j,1))==0;
      p_wouters = plot( wouters_time, mb_wouters(wouters_regions==j,1).*ones(1,2),...
          'LineStyle', '-','Color',Wouters_line,'LineWidth',2);
     end
     
     hold on
          
     % Plot SROCC Table 2A data
    p_srocc = plot(srocc_time, srocc_mb(srocc_regions==j,1).*ones(1,2),...
          'LineStyle', '-','Color',SROCC_line,'LineWidth',2);
           
     % Plot Hugonnet et al., (2021) first period data
    p_hugo = plot( t1_hugonnet, mass_balance1(k,1).*ones(1,2),...
         'LineStyle', '-','Color',Hugonnet_line,'LineWidth',2);
     hold on
     % Plot Hugonnet et al., (2021) second period data
    p_hugo = plot( t2_hugonnet, mass_balance2(k,1).*ones(1,2),...
         'LineStyle', '-','Color',Hugonnet_line,'LineWidth',2);
     hold on
     
   
      % Include y axis label just in the left plots
     if k== 1 ||  k== 2 ;
           set(gca,'FontSize',8,'YTick',[-1000 -500  0 500],'YTickLabel',...
           {'-1000';'-500';'0';'500' },'YLim', [-1000 500])
      
       box on
     else
           set(gca,'FontSize',8,'YTick',[ -2000 -1000  0 1000],'YTickLabel',...
            {'-2000';'-1000';'0';'1000'},'YLim', [-2000 1000]) 
     end
    % include Ylabel in the middle of the yaxis
   if k ==9
         ylabel(['Mass change rate [kg m^-^2 yr^-^1]'],'FontSize',9,'FontWeight','Bold' );
   end
   
    % Include x axis label at the bottom
    if k== 16  || k==17  || k==18 || k ==19;   
        set(gca,'FontSize',8,'XTick', time_period,'XTickLabel',...
          tick_time,'XLim', [time_period(1) time_period(end)])
       xlabel('Years','FontSize',8,'FontWeight','Bold') 
    else
       set(gca,'FontSize',8,'XTick', time_period,'XTickLabel',[],'XLim', [time_period(1) time_period(end)])
    end

     % Title of each subplot   (regionsname and number) 
      title([cell2mat(regionnames(k)),' (',cell2mat(regions_numbers(k)),')'],'FontSize',9,'FontWeight','Bold') 
     
      % Legend
      if k==19;
          legend1 =  legend( [p_zemp p_wouters p_srocc p_hugo p_ice_annual ],...
              {'Zemp et al. (2019)','Wouters et al. (2019)','SROCC', 'Hugonnet et al (2021)','Aðalgeirsdóttir et al. (2020)'});
          set(legend1,'FontSize',7,'FontWeight','Bold','Position',[position_plots(20,1),position_plots(20,2)+0.01,position_plots(20,3),0.8*position_plots(20,4)]);
      end
     
 end

 %%  Print figure files as eps ad pdf (uncommet to create files)
fig1=gcf;
% Figure as eps to be customized
set(fig1,'PaperUnits','centimeters');
set(fig1,'PaperSize',[18 25]);
set(fig1,'PaperPosition',[0. 0. 18 25]);

if User==Lucas
 print(fig1,'-depsc', [ folder_path,'Chapter9_Obs_glacier_mass_balance_figure\OUTPUT_FIGURES\',figure_filename])
 %Figure as pdf
 print(fig1,'-dpdf', [ folder_path,'Chapter9_Obs_glacier_mass_balance_figure\OUTPUT_FIGURES\',figure_filename])
 display('Figure printed as eps & pdf')
 close(fig1)
elseif User==Baylor
 print(fig1,'-dpng', [ folder_path,'Chapter9_Obs_glacier_mass_balance_figure\OUTPUT_FIGURES\',figure_filename],'-r300', '-painters')
 close(fig1)    
end