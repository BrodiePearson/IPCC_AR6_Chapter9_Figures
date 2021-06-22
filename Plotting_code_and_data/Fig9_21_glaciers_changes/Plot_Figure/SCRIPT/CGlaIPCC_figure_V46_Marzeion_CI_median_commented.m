clear all
clc
format long g

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description
% Figure 9.22: Glacier mass relative to 2015 as a function of time between
% 1902 and 2100.
%
% Global(all) =  All glaciers of world.
%
% Global(excep 5&19) = All glaciers except those peripheral to ice sheets
% (RGI regions 5 and 19).
%
% RGI regions like in the SROCC, where High Mountain Asia (HMA) is the sum of 
% RGI regions 13, 14 and 15).
%
% Explanation:

% % 20th century glacier mass is presented relative to mass  for year 2000. 

% Uncertainties in all cases is transformed to CI (90%). 
% We use 90% CI = 1.645.*std

% Projections results are expressed as median +/- 90% CI
%
% Inputs:
% It needs time series and table data to create the figures.
% Main input data are:

% Glacier mass/volume for each region as a mat file (Farinotti2019.mat)
% create by Lucas Ruiz from Table 1 of Farinotti et al. (2019). 
% Structure of the mat flie =  Region | km3 | accuracy | mm slr eq | accuracy


% Zemp et al (2019) supplementary materials

% Marzeion et al (2015) supplementary materials
% Marzeion et al. (2020) supplementary materials.
% 
% 
% Lucas Ruiz
 
 %% Figure filename
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Define the name of  *.eps and *.pdf file 
 figure_filename= 'Glacier_change_fig_FGD_testing';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 %% Reference year 2015
 t1 = 2015;
 
  %% Regions names and numbers
  % Names and numbers (used in the titles of each plot)
  regionnames = { 'Global' 'Global' 'Alaska' 'West Canada and U.S.' 'Arctic Canada (N)' 'Arctic Canada (S)' 'Greenland periphery' 'Iceland' 'Svalbard' 'Scandinavia' 'Russian Arctic' 'North Asia' 'Central Europe' 'Caucasus' 'High Mountain Asia' 'Low Latitudes' 'Southern Andes' 'New Zealand' 'Antarctic periphery'};
  
  regions_numbers = { 'all' 'except 5&19' '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13-15' '16' '17' '18' '19'}; 
  
 %% Define Regions variable
 
 %Used to select time series from input files
 regions = (1:1:19);

% Used to merge regions 13,14 and 15 into High Mountain Asia HMA (13) 
regions_short = [1,2,3,4,5,6,7,8,9,10,11,12,13,16,17,18,19];

%Select what to use for High Mountain of Asia (13)
HMA = [13 14 15]; % 

%Select what to use for Global with peripheral glaciers (20).
GLOBAL =(1:1:19);

%select what to use for Global without  peripheral glaciers (21). 
GLOBAL_2 = [1,2,3,4,6,7,8,9,10,13,14,15,16,17,18];

 %% Data input
 % Please include each correct path
 Baylor=1;
 Lucas=2;
 User=Baylor;
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Just include the path where the figure folder is located (Must be changed)
 if User==Lucas
  folder_path ='c:\Users\lcsru\OneDrive\Documents\IPCC-AR6\09-FGD\';
 elseif User==Baylor
  folder_path ='../../';
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 if User==Lucas
 % Farinotti et al. (2019) glacier volume for each region 
 Farinotti_2019_file = [folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Farinotti2019.mat'];

 % Folder with the Zemp et al. (2019) time series of mass balance changes for each region
 % (supplementary materials)
 folder_ZEMP_SM = [folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Zemp_etal_results_regions\'];
 
 % Zemp et al. (2019) time series of global mass balance changes  (supplementary materials)
 global_file_ZEMP_SM = [folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Zemp_etal_results_global.csv'];
 
 % xls file Annex table  AR6 Chapter 9
 file_Table_9_4= 'c:\Users\lcsru\OneDrive\Documents\IPCC-AR6\07-SOD\Table 9_4_TBD.xlsx';
  
% Marzeion et al. (2020) supplementary materials file
GlacierMIP_file =  [folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\suppl_GlacierMIP_results.nc'];
 
%  Marzeion et al. (2015) 20th century regional glacier mass data
 Marzeion2015_file =  [folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\data_marzeion_etal_update_2015_regional.txt'];
 Marzeion2015_file_error =  [folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\error_marzeion_etal_update_2015_regional.txt'];

%  Marzeion et al. (2015) 20th century global glacier mass data
Marzeion2015_global_file =   [folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\data_marzeion_etal_update_2015.txt'];
 
% Leclerq et al. (2011) updated in Marzeion et al. (2015) 20th century global
 Leclerq2015_global_file =  [folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\data_leclercq_etal_update_2015.txt'];
  
 % Bamber et al (2018) supplementary material.
 bamber_file = [folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\Bamber-etal_2018.TAB'];

 %% Set figure format and colors for each line
 
% Define the color of each shaded area and line
% following IPCC Colorscheme

% load colorscheme file
load([folder_path,'Chapter9_Relative_glacier_mass_figure\INPUT_DATA\colorscheme.mat.mat'])

 elseif User==Baylor
  
     % Farinotti et al. (2019) glacier volume for each region 
 Farinotti_2019_file = [folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/Farinotti2019.mat'];

 % Folder with the Zemp et al. (2019) time series of mass balance changes for each region
 % (supplementary materials)
 folder_ZEMP_SM = [folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/Zemp_etal_results_regions/'];
 
 % Zemp et al. (2019) time series of global mass balance changes  (supplementary materials)
 global_file_ZEMP_SM = [folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/Zemp_etal_results_global.csv'];
 
 % xls file Annex table  AR6 Chapter 9
 % file_Table_9_4= 'c:/Users/lcsru/OneDrive/Documents/IPCC-AR6/07-SOD/Table 9_4_TBD.xlsx';
  
% Marzeion et al. (2020) supplementary materials file
GlacierMIP_file =  [folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/suppl_GlacierMIP_results.nc'];
 
%  Marzeion et al. (2015) 20th century regional glacier mass data
 Marzeion2015_file =  [folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/data_marzeion_etal_update_2015_regional.txt'];
 Marzeion2015_file_error =  [folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/error_marzeion_etal_update_2015_regional.txt'];

%  Marzeion et al. (2015) 20th century global glacier mass data
Marzeion2015_global_file =   [folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/data_marzeion_etal_update_2015.txt'];
 
% Leclerq et al. (2011) updated in Marzeion et al. (2015) 20th century global
 Leclerq2015_global_file =  [folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/data_leclercq_etal_update_2015.txt'];
  
 % Bamber et al (2018) supplementary material.
 bamber_file = [folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/Bamber-etal_2018.TAB'];
 
%% Set figure format and colors for each line
 
% Define the color of each shaded area and line
% following IPCC Colorscheme

% load colorscheme file
load([folder_path,'Chapter9_Relative_glacier_mass_figure/INPUT_DATA/colorscheme.mat.mat'])

end

% Shaded areas colors
shade_rgb =  colorscheme_RGB. shade_0_RGB;

% Line colors
line_rgb =  colorscheme_RGB. line_6_RGB;

% Zemp et al (2019)
Zemp_line = [line_rgb(1,:)]; % zemp time serie color line.
Zemp_shading = [shade_rgb(1,:)]; %z emp uncertainty

% Regional MB
Regional_line =[line_rgb(6,:)]; % Regional MB line
Regional_shading = [shade_rgb(6,:)]; % Regional MB data uncertainty

% Marzeion et al. (2015)
Marzeion_line =[line_rgb(3,:)]; % 20th Century reconstruction line
Marzeion15_shading = [shade_rgb(3,:)]; % 20th Century reconstruction uncertainty

% Leclerq et al (2011)
Leclerq_line =[line_rgb(2,:)]; % 20th Century reconstruction line
Leclerq15_shading = [shade_rgb(2,:)]; % 20th Century reconstruction uncertainty

% Bamber et al. (2018)
Bamber18_line =[line_rgb(6,:)]; % 20th Century reconstruction line
Bamber18_shading = [shade_rgb(6,:)]; % 20th Century reconstruction uncertainty

% Marzeion et al. (2020) RCP 2.6
RCP26_line = colorscheme_RGB.RCP26_line_RGB; % RCP 2.6
RCP26_shading =  colorscheme_RGB.RCP26_shade_RGB; % RCP 2.6 uncertainty

% Marzeion et al. (2020) RCP 4.5
RCP45_line = colorscheme_RGB.RCP45_line_RGB; % RCP 4.5
RCP45_shading = colorscheme_RGB.RCP45_shade_RGB; % RCP 4.5 uncertainty

% Marzeion et al. (2020) RCP 8.5
RCP85_line = colorscheme_RGB.RCP85_line_RGB; % RCP 2.6
RCP85_shading = colorscheme_RGB.RCP85_shade_RGB; % RCP 8.5 uncertainty

%delete variables created to upload colorscheme
clear colorscheme_RGB line_RGB shade_rgb

% Define the extent and position of  the figure and the different subplots
% Figure width [mm]
w_fig = 180; 

% Figure height [mm]
h_fig = 250; 

% Margins and separation of subplots 
bot_line =15; % bottom space [mm]
sep_v =9; % vertical separation between subplots [mm]
sep_h = 5; % horizontal separation between subplots [mm]
left_line =15; % left margin [mm]

% Width of the subplot [mm]
w = 36; 
% Height of the subplot [mm]
h = 36; 

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
     
width = w.*ones(20,1);
height = h.*ones(20,1); 

% Position vector [left, bottom,width,height]./normalized
position_plots = [left./w_fig,bottom./h_fig,width./w_fig,height./h_fig]; 

%delete variables created to generate the position vector
clear width height left bottom

%% Read volume/mass for each region for year 2000
% Data form Table 1 of Farinotti et al. (2019).

% load file (Region | km3 | accuracy | mm slr eq | accuracy)
load( Farinotti_2019_file)

%Regional volume in km3
region_vol_far_km = volume_by_region(:,2);  %
%Regional volume accuracy in km3
region_vol_far_km_uncer = volume_by_region(:,3);  %
 
 %% Read and process the 20th century regional glacier mass change of Marzeion et al. (2015) 

 % Since original time series ended in 2013, it is neccessary to extrapolate them until 2015 (t1).
% We use the mean of the  last 5 years mass change rates to fill the last three years ( from 2013 to 2015 (t1)). 
% Finally. the cumulative glacier mass change for each reagion is normalized to the glacier mass in 2015 (t1).
% Glacier mass in 2015 is obtained by extracting to the glacier mass in 2000 for each region (Farinotti et al (2019)
% the glacier mass change between 2000 and 2015.
% Uncertainty is 90 % CI.

%  We use the equivalences   362.5 Gt = 1 mm s.l.e  Cogley et al. (2011).

% Load Marzeion et al 2015 regional data
dataM_15 = load(Marzeion2015_file);
errorM_15  = load(Marzeion2015_file_error);

% Original time series extent of Marzeion et al. (2015)
datesM = dataM_15(:,1);

% Marzeion et al (2015) regions
% The order of regions is from Figure 2 of Marzeion et al. (2015). 
% Going line-by-line from top left to bottom right.
M_regions =1:1:18;

% Marzeion et al (2015)  years  from year one  to t1
datesM_full = datesM(1):1:t1;

% Select Marzeion et al (2015) years  between 2000 and t1 
datesM_end =  find(datesM_full>=2000);

%preallocation of relative glacier mass change to mass in t1  
twenty_century_gl_mass_t1 = nan(length(regions_short),length(datesM_full));
twenty_century_gl_uncert_t1 = twenty_century_gl_mass_t1;

% Loop to calculate the glacier mass change for each region relative to
% volume in 2000
for j =1:1:length(regions_short)-1;
      m = regions_short(j);      
      % Conditional to select the regions for the HMA (RGI regions 13,14
      % and 15).
      if m<13;
           vol_sle = region_vol_far_km(m,1)./362.5; % Regional glacier volume in 2000  [mm sle]
           e_vol_sle = region_vol_far_km_uncer(m,1)./362.5; % uncertainty in Regional glacier volume [mm sle]
           interp_data_marzeion15(:,1)= interp1(datesM,dataM_15(:,m+1),... % Regional glacier mass change extrapolate until t1
           datesM_full,'linear',mean(dataM_15(end-5:end,m+1)));  
            interp_uncert_marzeion15(:,1) = interp1(datesM,errorM_15(:,m+1),... % Uncertanty in glacier mass change extrapolate until t1
            datesM_full,'linear',mean(errorM_15(end-5:end,m+1)));         
     elseif m==13;      
            vol_sle = sum(region_vol_far_km(HMA,1))./362.5; % Regional glacier volume in 2000  [mm sle]
            e_vol_sle = sqrt(sum((region_vol_far_km_uncer(HMA,1)./362.5).^2)); % uncertainty in Regional glacier volume [mm sle]
           interp_data_marzeion15(:,1)= interp1(datesM,sum(dataM_15(:,HMA+1),2),...
           datesM_full,'linear',mean(sum(dataM_15(end-5:end,HMA+1),2)));  % Regional glacier mass change extrapolate until t1
            interp_uncert_marzeion15(:,1) = interp1(datesM,sum(errorM_15(:,HMA+1),2),...
            datesM_full,'linear',mean(sum(errorM_15(end-5:end,HMA+1),2))); % Uncertanty in glacier mass change extrapolate until t1
     elseif m>=16 && m<=18;
         vol_sle = region_vol_far_km(m,1)./362.5; % Regional glacier volume in 2000  [mm sle]
         e_vol_sle = region_vol_far_km_uncer(m,1)./362.5; % uncertainty in Regional glacier volume [mm sle]
           interp_data_marzeion15(:,1)= interp1(datesM,dataM_15(:,m+1),... % Regional glacier mass change extrapolate until t1
           datesM_full,'linear',mean(dataM_15(end-5:end,m+1)));  
            interp_uncert_marzeion15(:,1) = interp1(datesM,errorM_15(:,m+1),... % Uncertanty in glacier mass change extrapolate until t1
            datesM_full,'linear',mean(errorM_15(end-5:end,m+1))); 
      end
      
        % 20 th century glacier mass change relative to 2015 (t1).
        % We account to the glacier mass change between 2000 and 2015 (t1) 
         twenty_century_gl_mass_t1(j,:) =(-1.*flipud(cumsum(flipud(interp_data_marzeion15)))+(vol_sle-sum(interp_data_marzeion15(datesM_end))))./(vol_sle-sum(interp_data_marzeion15(datesM_end)));
         % Relative volume change uncertainty to t1 during the 20th century
         twenty_century_gl_uncert_t1(j,:)  = sqrt(flipud(cumsum(flipud((interp_uncert_marzeion15).^2)))+ e_vol_sle.^2) ./(vol_sle-sum(interp_data_marzeion15(datesM_end)));  
   
   % delete the variables created in the loop
   clear interp_data_marzeion15 vol_sle interp_uncert_marzeion15
end

% deleted the variables created to load the data
clear dataM_15 errorM_15

 %% Read and process the 20th century global (exp RGI 19) glacier mass change of Marzeion et al. (2015) 
% Since original time series ended in 2013, it is neccessary to extrapolate them until 2015 (t1).
% We linearly extrapolated the glacier mass  timeserie  to fill the last three years ( from 2013 to 2015 (t1)). 
% Finally. the glacier mass timeseriesis normalized to the glacier mass in 2015 (t1).
% Glacier mass in 2015 is obtained by accounting the glacier mass in 2000  (Farinotti et al (2019)
 % Uncertainty is 90% CI.
%  We use the equivalences   362.5 Gt = 1 mm s.l.e  Cogley et al. (2011).
 
 % Load Marzeion et al global file without peripheral
dataM_15_global = load(Marzeion2015_global_file);

%Global Glacier mass in 2000 [mm sle]
global_mass_sle_2000 = sum(region_vol_far_km(GLOBAL_2))./362.5; 

%Global Glacier mass uncertaintly  [mm sle]
global_uncert_sle_2000 = sqrt(sum((region_vol_far_km_uncer(GLOBAL_2,1)./362.5).^2)); 

% 20th century global glacier mass relative to 2000 extrapolate until t1
% [mm sle]
data_marzeion_global= interp1(dataM_15_global(:,1),dataM_15_global(:,2), datesM_full,'linear','extrap');  

% 20th century global glacier mass uncertainty relative to 2000 extrapolate until t1
% [mm sle]
uncert_marzeion_global= interp1(dataM_15_global(:,1),dataM_15_global(:,3),datesM_full,'linear','extrap'); 
 
% 20th century global glacier mass [mm sle] 
 vol_marzeion_global = data_marzeion_global+global_mass_sle_2000;
 
 % 20th century global glacier mass uncertainty [mm sle]
 err_marzeion_global= sqrt(uncert_marzeion_global.^2+global_uncert_sle_2000.^2);

 % 20th century global glacier mass relative to 2015 (t1)
 rel_vol_marzeion_global = vol_marzeion_global./vol_marzeion_global(datesM_full==t1);
 
 % 20th century global glacier mass uncertainty relative to 2015 (t1)
  rel_err_marzeion_global = err_marzeion_global./vol_marzeion_global(datesM_full==t1);
 
 % To simplify the plotting process we merge the regional and global 20th century glacier mass time series in one variable 
twenty_century_gl_mass_t1 = [nan(size(rel_vol_marzeion_global)); rel_vol_marzeion_global; twenty_century_gl_mass_t1];
 twenty_century_gl_uncert_t1 = [nan(size( rel_err_marzeion_global));  rel_err_marzeion_global; twenty_century_gl_uncert_t1];
 
% deleted the variables created to load the data
 clear dataM_15_global data_marzeion_global  vol_marzeion_global  rel_vol_marzeion_global  rel_err_marzeion_global

 %% Read and process the 20th century global (exp RGI 5 & 19) glacier mass change of Leclerq et al. (2011)
% Data updated by Marzeion et al. (2015) 
% Since original time series ended in 2013, it is neccessary to extrapolate them until 2015 (t1).
% We linearly extrapolated the glacier mass  timeserie  to fill the last three years ( from 2013 to 2015 (t1)). 
% Finally. the glacier mass time series is normalized to the glacier mass in 2015 (t1).
% Glacier mass in 2015 is obtained by accounting the glacier mass in 2000  (Farinotti et al (2019)
% Uncertainty is 90% CI.

% Load Leclerq et al global file without peripheral
dataL_15_global = load(Leclerq2015_global_file);

% Leclerq et al global time series relative to t1 but accounting that
% glacier volume is known for 2000 (Farinotti et al 2019).

% 20th century global glacier mass relative to 2000 extrapolate until t1
% [mm sle
data_leclerq_global= interp1(dataL_15_global(:,1),dataL_15_global(:,2), datesM_full,'linear','extrap');  

% 20th century global glacier mass uncertainty relative to 2000 extrapolate until t1
% [mm sle]
uncert_leclerq_global = interp1(dataL_15_global(:,1),dataL_15_global(:,3),datesM_full,'linear','extrap'); 
 
% 20th century global glacier mass [mm sle] 
 vol_leclerq_global = data_leclerq_global+global_mass_sle_2000;
 
  % 20th century global glacier mass uncertainty [mm sle]
 err_leclerq_global = sqrt(uncert_leclerq_global.^2+global_uncert_sle_2000.^2);

 % 20th century global glacier mass relative to 2015 (t1)
 rel_vol_leclerq_global = vol_leclerq_global./vol_leclerq_global(datesM_full==t1);
 
 % 20th century global glacier mass uncertainty relative to 2015 (t1)
 rel_err_leclerq_global = err_leclerq_global./vol_leclerq_global(datesM_full==t1);
 
 % deleted the variables created to load the data
 clear data_leclerq_global uncert_leclerq_global vol_leclerq_global err_leclerq_global
 
%% Read and process glacier mass change between 1992 to 2015 of  Bamber et al. (2018) 
  
% Glacier mass time series is normalized to the glacier mass in 2015 (t1).
% Glacier mass in 2015 is obtained by accounting the glacier mass in 2000 (Farinotti et al., 2019)
% and the mass change between 2000 and 2015 (Bamber et al., 2018)
% Uncertainty is 1 std.

% Read the file and extract data
fid_bamber = fopen(bamber_file);
bamber_time_series_raw = textscan(fid_bamber,'%f %f %f %f %f %f %f %f %f %f %f','Delimiter','\t','HeaderLines',21);
fclose(fid_bamber);

% Global glacier mass balance time series  (without RGI 5 and 19)
Bamber_time_series = cell2mat(bamber_time_series_raw);
clear bamber_time_series_raw 

% years of Bamber et al. (2018)
time_bamber = Bamber_time_series(:,1);

% years before 2000 
dates_bamber_end = find(time_bamber>=2000);

% Cumulative global glacier mass change [mm sle]
global_bamber = Bamber_time_series(:,8)./362.5;

% Uncertainty (90% CI) Cumulative global glacier mass change [mm sle]
global_bamber_uncert = 1.645.*Bamber_time_series(:,9)./362.5;

 % 1992 to 2015 Relative glacier mass relative to 2015 (t1)
 % Acounting the difference between glacier mass in 2000 and the glacier mass change between 2000 and 2015 
  bamber_gic_rel =(-1.*flipud(cumsum(flipud(global_bamber)))+(global_mass_sle_2000-sum(global_bamber(dates_bamber_end))))./(global_mass_sle_2000-sum(global_bamber(dates_bamber_end)));
 
  % 1992 and 2015 uncertainty in glacier mass relative to 2015 (t1) 
  bamber_gic_rel_errs = sqrt(flipud(cumsum(flipud((global_bamber_uncert).^2)))+ global_uncert_sle_2000.^2)./(global_mass_sle_2000-sum(global_bamber(dates_bamber_end)));  

 
%% Read  glacier mass change between 1962 to 2015 of Zemp et al., (2019) 
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
    sel_time =find(time>=1962 & time<=t1);
    
    % Time reference vector for all the Zemp et al., (2019) data
    Zemp_time = time(sel_time);
    
    % Glacier mass change for each region of Zemp et al., (2019) [mm SLE yr-1]
    mass_change_zemp19(j,:)=M(sel_time,11);
    
    % Uncertainty in glacier mass change for each region of Zemp et al.,
    % (2019) [90% CI] [mm SLE yr-1]
    mass_change_zemp19_uncert(j,:) = M(sel_time,19);
    
    % Delete variable to upload data for each region
    clear M
end

% Delete variable of file order
clear file_order

%% Read  global glacier mass change between 1962 to 2015 of Zemp et al., (2019) 
% Read Zemp et al. (2019) global supplementary file   with the
% annual glacier mass change time serie.
% Uncertainty is 90% CI

 % Read the csv file
    M = csvread(global_file_ZEMP_SM,28,0);
    
 % time vector   
    time =M(:,1);
 %Selection of time from 1962
   sel_time =find(time>=1962 & time<=t1);
   
 % Time reference vector for all the Zemp et al., (2019) data
    Zemp_time_global = time(sel_time);

% Global glacier mass  change of Zemp et al., (2019)   [mm SLE yr-1]
    global_mass_change_zemp19=M(sel_time,10);

% Uncertainty in global glacier mass change of Zemp et al.
% (2019) [90% CI] [mm SLE yr-1]
    global_mass_change_zemp19_uncert= M(sel_time,11);

 % Delete variable to upload data 
    clear M time

  %% Process Zemp et al., (2019) time series
 % Transform annual glacier mass change to glacier mass change relative to 2015 (t1) 
 % Uncertainty is 90% CI
 
 % Loop to calculate the glacier mass change for each region relative to
 % 2015 (t1) 
  for j =1:1:length(regions_short);
      m = regions_short(j);
      if m<13;
             % 1962-2015 glacier mass change change [mm sle]
              total_mass_change_zemp19(j,1) = sum(mass_change_zemp19(m,:)); 
              
              % Glacier mass change after 2000  
              mass_change_after_2000_zemp19(j,1) = sum(mass_change_zemp19(m,Zemp_time>=2000));
              
              % 1962-2015 Glacier mass [mm sle]
              glacier_mass_zemp19(j,:) = (cumsum(mass_change_zemp19(m,:))-total_mass_change_zemp19(m,1)+ (region_vol_far_km(m,1)-mass_change_after_2000_zemp19(j,1)));
              
              % 1962-2015 Uncertainty in Glacier mass  90% CI
              glacier_mass_zemp19_uncert(j,:) = sqrt(mass_change_zemp19_uncert(m,:).^2+ region_vol_far_km_uncer(m,1).^2);
              
              % 1962-2015 Glacier mass relative to 2015 (t1)
              glacier_mass_zemp19_rel(j,:) = glacier_mass_zemp19(j,:)./(region_vol_far_km(m,1)-mass_change_after_2000_zemp19(j,1));
                
              % 1962-2015 Uncertainty in Glacier mass relative to 2015 (t1)
              % 90% CI
              glacier_mass_zemp19_rel_uncert(j,:) =  glacier_mass_zemp19_uncert(j,:)./(region_vol_far_km(m,1)-mass_change_after_2000_zemp19(j,1));
        
      elseif m==13;
              % 1962-2015 glacier mass change change [mm sle]
              total_mass_change_zemp19(j,1) = sum(sum(mass_change_zemp19(HMA,:))); 
             
              % Glacier mass change after 2000  
              mass_change_after_2000_zemp19(j,1) = sum(sum(mass_change_zemp19(HMA,Zemp_time>=2000)));
               
              % 1962-2015 Glacier mass [mm sle]
              glacier_mass_zemp19(j,:) = (cumsum(sum(mass_change_zemp19(HMA,:)))-total_mass_change_zemp19(j,1)+ (sum(region_vol_far_km(HMA,1))-mass_change_after_2000_zemp19(j,1)));
             
              % 1962-2015 Uncertainty in Glacier mass  90% CI
              glacier_mass_zemp19_uncert(j,:)= sqrt(sum(mass_change_zemp19_uncert(HMA,:)).^2+ sum(region_vol_far_km_uncer(HMA,1)).^2);
          
              % 1962-2015 Glacier mass relative to 2015 (t1)
              glacier_mass_zemp19_rel(j,:) = glacier_mass_zemp19(j,:)./(sum(region_vol_far_km(HMA,1))-mass_change_after_2000_zemp19(j,1));
              
              % 1962-2015 Uncertainty in Glacier mass relative to 2015 (t1)
              % 90% CI
              glacier_mass_zemp19_rel_uncert(j,:) = glacier_mass_zemp19_uncert(j,:)./(sum(region_vol_far_km(HMA,1))-mass_change_after_2000_zemp19(j,1));
  
      elseif m>=16 && m<=19;
              % 1962-2015 glacier mass change change [mm sle]
              total_mass_change_zemp19(j,1) = sum(mass_change_zemp19(m,:)); 
              
               % Glacier mass change after 2000  
              mass_change_after_2000_zemp19(j,1) = sum(mass_change_zemp19(m,Zemp_time>=2000));
              
               % 1962-2015 Glacier mass [mm sle]
              glacier_mass_zemp19(j,:) = (cumsum(mass_change_zemp19(m,:))-total_mass_change_zemp19(j,1)+ (region_vol_far_km(m,1)-mass_change_after_2000_zemp19(j,1)));
             
              % 1962-2015 Uncertainty in Glacier mass  90% CI
              glacier_mass_zemp19_uncert(j,:) = sqrt(mass_change_zemp19_uncert(m,:).^2+ region_vol_far_km_uncer(m,1).^2); 
                                          
              % 1962-2015 Glacier mass relative to 2015 (t1)
              glacier_mass_zemp19_rel(j,:) = glacier_mass_zemp19(j,:)./(region_vol_far_km(m,1)-mass_change_after_2000_zemp19(j,1));
                            
             % 1962-2015 Uncertainty in Glacier mass relative to 2015 (t1)
              % 90% CI
              glacier_mass_zemp19_rel_uncert(j,:) = glacier_mass_zemp19_uncert(j,:)./(region_vol_far_km(m,1)-mass_change_after_2000_zemp19(j,1));
   end
 end
 


% 1962 -2015 Zemp et al., (2019) global (all regions) glacier mass time series relative
% to 2015 (t1), accounting that Farinotti et al., (2019) glacier volume is for 2000.
 total_mass_change_global_zemp19 =  sum(glacier_mass_zemp19,1)./sum(region_vol_far_km);

 % Uncertainty as 90% CI 
 total_mass_change_global_zemp19_uncert =sum(glacier_mass_zemp19_uncert,1)./sum(region_vol_far_km);

% 1962 -2015 Zemp et al., (2019) global without peripheral glacier mass time series relative
% to 2015 (t1), accounting that Farinotti et al., (2019) glacier volume is for 2000.
sel_z = regions_short;
sel_z = find(regions_short ~=5 ) ;
sel_z(end) = [];
total_mass_change_global_exp_zemp19 =  sum(glacier_mass_zemp19(sel_z,:),1)./sum(region_vol_far_km(GLOBAL_2,1));

% Uncertainty as 90% CI 
total_mass_change_global_exp_zemp19_uncert =sum(glacier_mass_zemp19_uncert(sel_z,:),1)./sum(region_vol_far_km(GLOBAL_2,1));

clear sel_z 


%To simplify the plotting process we add the global and global without peropheral glacier to the regional time series
glacier_mass_zemp19_rel = [total_mass_change_global_zemp19; total_mass_change_global_exp_zemp19; glacier_mass_zemp19_rel];
glacier_mass_zemp19_rel_uncert = [total_mass_change_global_zemp19_uncert ;total_mass_change_global_exp_zemp19_uncert; glacier_mass_zemp19_rel_uncert];
 
 % Delete variable that are not used any more
 clear total_mass_change_global_exp_zemp19 zemp_global_2_err total_mass_change_global_zemp19 zemp_global_1_err 
 
 %% Read and Process Supplementary material of  Marzeion et al., (2020)

% Read the info (just to know what it is inside, but not really used)
 info_nc_glaciermip2 = ncinfo(GlacierMIP_file);

% Glacier models
 glaciermodels_runs =ncread(GlacierMIP_file,'Glacier_Model');

 % GCM (global circulation models
forcingmodels_runs=ncread(GlacierMIP_file,'Climate_Model');

% RCPs
scenarios_runs =ncread(GlacierMIP_file,'Scenario');

% Glacier area km2
area = ncread(GlacierMIP_file,'Area');

%Glacier mass  [km3 w.e =Gt]
mass = ncread(GlacierMIP_file,'Mass');

% Time reference [years]
time = ncread(GlacierMIP_file,'Time');

% Create the variables of GLACIERMIP to be plotted
% Brief description of the area and volume output data
% Dimension 1 == Glacier region
% Dimension 2 == Time
% Dimension 3 == Climate model
% Dimension 4 == Glacier model
% Dimension 5 == Scenario
  
 % RCP2.6
 RCP26 = 1;
 % RCP 4.5 
 RCP45 = 2;
 % RCP8.5
 RCP85 = 4;
 
 % Select time between 2015 (t1) and 2100 
 sel_time = find(time>=t1 & time<=2100);
 
 time_used =time(sel_time);
 % find t1
 yt1 = find(time_used==t1);
 
 % Selected the  data for RCP 2.6
 RCP26_vol = double(mass(:,sel_time,:,:,RCP26));
 
 % Selected the data for RCP 4.5
 RCP45_vol = double(mass(:,sel_time,:,:,RCP45));
 
 % Selected the data for RCP 8.5
 RCP85_vol = double(mass(:,sel_time,:,:,RCP85));
 
 %IR por region y por modelo de glaciar

%mean_RCP26_by_model = nanmean(RCP26_vol,4);
%std_RCP26_by_model = nanstd(RCP26_vol,4);


% Reshape matrix to put all the models run in the same dimension

% All models runs median and std for each regions, we assume each model runs
% is and independent results
 RCP26_all = reshape(RCP26_vol,size(RCP26_vol,1),size(RCP26_vol,2),size(RCP26_vol,3)*size(RCP26_vol,4));
 
 RCP45_all = reshape(RCP45_vol,size(RCP45_vol,1),size(RCP45_vol,2),size(RCP45_vol,3)*size(RCP45_vol,4));

 RCP85_all = reshape(RCP85_vol,size(RCP85_vol,1),size(RCP85_vol,2),size(RCP85_vol,3)*size(RCP85_vol,4));

% RCP 2.6 glacier mass change relative to 2015 (t1)
 for j =1:1:length(regions_short);
         m = regions_short(j);
           for k =1:1:size(RCP26_all,3);
               if m<13;
                      vol_26_rel(j,:,k) = RCP26_all(j,:,k)./(RCP26_all(m,yt1,k));
                      vol_26_initial(j,k) =RCP26_all(m,yt1,k);
               elseif m==13; % HMA
                      vol_26_rel(j,:,k) = nansum(RCP26_all(HMA,:,k),1)./nansum(RCP26_all(HMA,yt1,k),1);
                     vol_26_initial(j,k) =nansum(RCP26_all(HMA,yt1,k),1);
               elseif m>=16 && m<=19;
                      vol_26_rel(j,:,k) = RCP26_all(m,:,k)./(RCP26_all(m,yt1,k));
                      vol_26_initial(j,k) =RCP26_all(m,yt1,k);
               end

   end
     end
     
% RCP 4.5 glacier mass change relative to 2015 (t1)
  for j =1:1:length(regions_short);
       m = regions_short(j);
           for k =1:1:size(RCP45_all,3);
               if m<13;
                      vol_45_rel(j,:,k) = RCP45_all(m,:,k)./(RCP45_all(m,yt1,k));
                      vol_45_initial(j,k) =RCP45_all(m,yt1,k);
               elseif m==13;
                      vol_45_rel(j,:,k) = nansum(RCP45_all(HMA,:,k),1)./nansum(RCP45_all(HMA,yt1,k),1);
                     vol_45_initial(j,k) =nansum(RCP45_all(HMA,yt1,k),1);
               elseif m>=16 && m<=19;
                      vol_45_rel(j,:,k) = RCP45_all(m,:,k)./(RCP45_all(m,yt1,k));
                      vol_45_initial(j,k) =RCP45_all(m,yt1,k);
               end

   end
 end

 % RCP 8.5 glacier mass change relative to 2015 (t1)
  for j =1:1:length(regions_short);
       m = regions_short(j);
           for k =1:1:size(RCP85_all,3);
               if m<13;
                      vol_85_rel(j,:,k) = RCP85_all(m,:,k)./(RCP85_all(m,yt1,k));
                      vol_85_initial(j,k) =RCP85_all(m,yt1,k);
               elseif m==13;
                      vol_85_rel(j,:,k) = nansum(RCP85_all(HMA,:,k),1)./nansum(RCP85_all(HMA,yt1,k),1);
                     vol_85_initial(j,k) =nansum(RCP85_all(HMA,yt1,k),1);
               elseif m>=16 && m<=19;
                      vol_85_rel(j,:,k) = RCP85_all(m,:,k)./(RCP85_all(m,yt1,k));
                      vol_85_initial(j,k) =RCP85_all(m,yt1,k);
               end

   end
  end
 
 % Median  and 90 % CI  values for RCP 2.6, 4.5 and 8.5
 %Loop to calculate median and 90% CI std for each region (all models)
 for j =1:1:length(regions_short);
     
     % Median mass change relative to 2015 (t1) (all models)
     % RCP 2.6 
         median_RCP26(j,:) =nanmedian(vol_26_rel(j,:,:),3);
         median_RCP26_initial_mass(j,1) =  nanmedian(vol_26_initial(j,:),2); 
     % RCP 4.5
          median_RCP45(j,:) =nanmedian(vol_45_rel(j,:,:),3);
          median_RCP45_initial_mass(j,1) =  nanmedian(vol_45_initial(j,:),2);
     % RCP 8.5
          median_RCP85(j,:) =nanmedian(vol_85_rel(j,:,:),3);
          median_RCP85_initial_mass(j,1) =  nanmedian(vol_85_initial(j,:),2);
     
    % Uncertainty in  mass change relative to 2015 (t1) (all models) 90% CI
    % RCP 2.6 
    CI_RCP26(j,:) = 1.645.*nanstd(vol_26_rel(j,:,:),1,3);
    % RCP 4.5
   CI_RCP45(j,:) = 1.645.*nanstd(vol_45_rel(j,:,:),1,3);
    % RCP 8.5
    CI_RCP85(j,:) = 1.645.*nanstd(vol_85_rel(j,:,:),1,3);
    
 end 
 
 % Create the global time series for each RCPs
 for j =1:1:length(regions_short);
 global_RCP26(j,:) = median_RCP26(j,:).*median_RCP26_initial_mass(j,1);
 global_RCP45(j,:) = median_RCP45(j,:).*median_RCP45_initial_mass(j,1);
 global_RCP85(j,:) = median_RCP85(j,:).*median_RCP85_initial_mass(j,1);
 global_RCP26_err(j,:) =  CI_RCP26(j,:).*median_RCP26_initial_mass(j,1);
 global_RCP45_err(j,:) = CI_RCP45(j,:).*median_RCP45_initial_mass(j,1);
 global_RCP85_err(j,:) =  CI_RCP85(j,:).*median_RCP85_initial_mass(j,1);
 end
 
 % All Regions relative to 2015 (t1)
 RCP26_global_1 = sum(global_RCP26,1)./sum(median_RCP26_initial_mass);
 RCP45_global_1 = sum(global_RCP45,1)./sum(median_RCP45_initial_mass);
 RCP85_global_1 = sum(global_RCP85,1)./sum(median_RCP45_initial_mass);
 
 RCP26_global_1_err = sqrt(sum(global_RCP26_err.^2,1))./sum(median_RCP26_initial_mass);
 RCP45_global_1_err = sqrt(sum(global_RCP45_err.^2,1))./sum(median_RCP45_initial_mass);
 RCP85_global_1_err = sqrt(sum(global_RCP85_err.^2,1))./sum(median_RCP45_initial_mass);
 
 
 % Global except RGI 5 and 19 regions relative to 2015 (t1)
 %first select the regions
 sel=regions_short;
sel = find(regions_short ~=5 ) ;
sel(end) = [];
 
 RCP26_global_2 = sum(global_RCP26(sel,:),1)./sum(median_RCP26_initial_mass(sel,:));
 RCP45_global_2 = sum(global_RCP45(sel,:),1)./sum(median_RCP45_initial_mass(sel,:));
 RCP85_global_2 = sum(global_RCP85(sel,:),1)./sum(median_RCP45_initial_mass(sel,:));
 
 RCP26_global_2_err = sqrt(sum(global_RCP26_err(sel,:).^2,1))./sum(median_RCP26_initial_mass(sel,:));
 RCP45_global_2_err = sqrt(sum(global_RCP45_err(sel,:).^2,1))./sum(median_RCP45_initial_mass(sel,:));
 RCP85_global_2_err = sqrt(sum(global_RCP85_err(sel,:).^2,1))./sum(median_RCP45_initial_mass(sel,:));
 
%To simplify the plotting process we add the global and global without peropheral glacier to the regional time series
 median_RCP26 = [RCP26_global_1; RCP26_global_1; median_RCP26];
 median_RCP45 = [RCP45_global_1; RCP45_global_2; median_RCP45];
 median_RCP85 = [RCP85_global_1; RCP85_global_2; median_RCP85];
 
CI_RCP26 = [ RCP26_global_1_err;  RCP26_global_2_err ; CI_RCP26];
CI_RCP45 = [ RCP45_global_1_err;  RCP45_global_2_err ;CI_RCP45];
CI_RCP85 = [ RCP85_global_1_err;  RCP85_global_2_err ; CI_RCP85];
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create the figure
     figure(1)
% size of figure defined by IPCC visual style guide [cm]
     figSize = [1 1 w_fig/10 h_fig/10]; 
 % set size and position
     set(gcf,'units','centimeters','position',figSize,'paperposition',figSize);

 % Start the loop of the figure
  for k = 1:1:length(regions_numbers);
        
      j =k; % to be used if the order of the plots and time series do not agree
     % subplot positions
     subplot('Position',position_plots(k,:) ) 
         
     ratio =1; % to arbitrarty increase or decrease the error (if =1 do not do anything)
     
     
     % Upper curve of uncertainty  of Marzeion et al., (2015) data as shaded area
     y_marzeion_1 =twenty_century_gl_mass_t1(j,:)+twenty_century_gl_uncert_t1(j,:);
     % Lower  curve of uncertainties  of Marzeion et al., (2015) as shaded area
     y_marzeion_2 =twenty_century_gl_mass_t1(j,:)-twenty_century_gl_uncert_t1(j,:);
     %Plot uncertainty of Marzeion et al., (2015) data as shaded area
     shadedplot(datesM_full, y_marzeion_1, y_marzeion_2,Marzeion15_shading);
     hold on 
         
     % Upper curve of uncertainties  of Zemp et al., (2019) data as shaded area
     y_zemp_1 =(glacier_mass_zemp19_rel(j,:)+glacier_mass_zemp19_rel_uncert(j,:)).*ratio;
     % Lower  curve of uncertainties  of  Zemp et al., (2019) data as shaded area
     y_zemp_2 =(glacier_mass_zemp19_rel(j,:)-glacier_mass_zemp19_rel_uncert(j,:)).*ratio;
     %Plot uncertainty of  Zemp et al., (2019) data as shaded area
     shadedplot(Zemp_time, y_zemp_1, y_zemp_2,Zemp_shading);
     hold on 
    
     if k ==2 % Plot Bamber et al., (2018) on plot 2 (Global without ice sheet peripheral glaciers)
     
         % Upper curve of uncertainties  of Bamber et al., (2018) data as shaded area
     y_bamber_1 =(bamber_gic_rel+bamber_gic_rel_errs).*ratio;
     % Lower  curve of uncertainties  of Bamber et al., (2018) data as shaded area
     y_bamber_2 =(bamber_gic_rel-bamber_gic_rel_errs).*ratio;
     %Plot uncertainty of Bamber et al., (2018) data as shaded area
   %  shadedplot(time_bamber, y_bamber_1', y_bamber_2',Bamber18_shading);
     hold on 
     %Plot Bamber et al., (2018) data as a line
   %  p_bamber = plot(time_bamber, bamber_gic_rel.*ratio,'LineStyle', '-','Color',Bamber18_line,'LineWidth',2);
     hold on
     
     end
    
     % Upper curve of uncertainty of RCP2.6 as shaded area (CI)
     y_RCP26_1 =(median_RCP26(j,:) + CI_RCP26(j,:)).*ratio;
     % Lower curve of uncertainty of RCP2.6 as shaded area (CI)
     y_RCP26_2 =(median_RCP26(j,:) - CI_RCP26(j,:)).*ratio;
     % Plot uncertainty of RCP2.6 as shaded area (CI) 
     shadedplot(time_used, y_RCP26_1, y_RCP26_2, RCP26_shading); 
     hold on
     
      % Upper curve of uncertainty of RCP4.5 as shaded area (CI)
     y_RCP45_1 =(median_RCP45(j,:) + CI_RCP45(j,:)).*ratio;
     % Lower curve of uncertainty of RCP2.6 as shaded area (CI)
     y_RCP45_2 =(median_RCP45(j,:) - CI_RCP45(j,:)).*ratio;
     % Plot uncertainty of RCP2.6 as shaded area (CI) 
     shadedplot(time_used, y_RCP45_1, y_RCP45_2, RCP45_shading); 
     hold on
     
     % Upper curve of uncertainty of RCP8.5 as shaded area (CI)
     y_RCP85_1 =(median_RCP85(j,:) + CI_RCP85(j,:)).*ratio;
     % Lower curve of uncertainty of RCP8.5 as shaded area (CI)
     y_RCP85_2 =(median_RCP85(j,:) - CI_RCP85(j,:)).*ratio;
     % Plot uncertainty of RCP8.5 as shaded area (CI)
     shadedplot(time_used, y_RCP85_1, y_RCP85_2, RCP85_shading); 
     hold on
       
     %  Plot Marzeion et al., (2015) data 
     p_marzeion = plot(datesM_full,twenty_century_gl_mass_t1(j,:),'LineStyle', '-','Color',Marzeion_line,'LineWidth',2);
     hold on
    
     % Plot Zemp et al., (2019) data
    p_zemp = plot(Zemp_time, (glacier_mass_zemp19_rel(j,:)).*ratio,'LineStyle', '--','Color',Zemp_line,'LineWidth',1);
    hold on
  
         
    %plot median RCP 2.6 projections
     p_26 =  plot(time_used,(median_RCP26(j,:)).*ratio,'Color',RCP26_line,'LineWidth',2);
     hold on
          
    %plot median RCP 4.5 projections
     p_45 =  plot(time_used,(median_RCP45(j,:)).*ratio,'Color',RCP45_line,'LineWidth',2);
     hold on
     
     % plot median RCP 8.5 projections
     p_85 = plot(time_used,(median_RCP85(j,:)).*ratio,'Color',RCP85_line,'LineWidth',2);
     hold on
     
     
      % Include y axis label just to left plots
     if k== 1 ||  k== 5 || k== 9 || k== 13 || k== 17;
          set(gca,'FontSize',9,'YTick',[ 0 0.5  1 1.5 2],'YTickLabel',...
          {'0';'50';'100' ;'150';'200'},'YLim', [0 2])
      
     else
          set(gca,'FontSize',9,'YTick',[ 0  0.5 1 1.5 2],'YTickLabel',...
           [],'YLim', [0 2]) 
     end
    % include Ylabel in the middle
   if k ==9
         ylabel(['Glacier mass relative to year ',num2str(t1),' [%]'],'FontSize',9,'FontWeight','Bold' );
   end
   
%%Uncommented to use xaxis from 1950   
%     % Include x axis label form 1950
%     if k== 16  || k==17  || k==18 || k ==19;   
%         set(gca,'FontSize',9,'XTick',[1950 2000  2050  2100],'XTickLabel',...
%           {'1950';'2000';'2050';'2100'},'XLim', [1950 2100])
%        xlabel('Years','FontSize',8,'FontWeight','Bold') 
%     else
%        set(gca,'FontSize',9,'XTick',[1950 2000 2050  2100],'XTickLabel',[],'XLim', [1950 2100])
%     end

    % Include x axis label from 1900
    if k== 16  || k==17  || k==18 || k ==19;   
        set(gca,'FontSize',9,'XTick',[1900 1950 2000  2050  2100],'XTickLabel',...
          {'';'1950';'2000';'2050';'2100'},'XLim', [1900 2100])
     %  xlabel('Years','FontSize',8,'FontWeight','Bold') 
    else
       set(gca,'FontSize',9,'XTick',[1900 1950 2000 2050  2100],'XTickLabel',[],'XLim', [1900 2100])
    end
   
    
     % Title of each subplot   (regionsname and number) 
      title([cell2mat(regionnames(j)),' (',cell2mat(regions_numbers(j)),')'],'FontSize',9,'FontWeight','Bold') 
     
      % Legend
      if k==19;
     %     legend1 =  legend( [p_marzeion p_zemp p_bamber p_26 p_45 p_85], {'Marzeion2015','Zemp2019','Bamber2018', 'RCP 2.6 mean','RCP 4.5 mean','RCP 8.5 mean'});
          
          legend1 =  legend( [p_marzeion p_zemp p_26 p_45 p_85], {'Reconstruction','Observation','RCP 2.6','RCP 4.5','RCP 8.5'});
           set(legend1,'FontName','Arial','FontWeight','Bold','FontSize',9,'Position',[position_plots(20,1)+0.01,position_plots(20,2)+0.05,1.01*position_plots(20,3),0.2*position_plots(20,4)]);


%          set(legend1,'FontSize',9,'FontWeight','Bold','Position',[position_plots(20,1),position_plots(20,2)-0.01,position_plots(20,3),0.8*position_plots(20,4)]);
      end
 end

 %%  Print figure files as eps ad pdf (uncommet to create files)
fig1=gcf;
% Figure as eps to be customized
set(fig1,'PaperUnits','centimeters');
set(fig1,'PaperSize',[18 25]);
set(fig1,'PaperPosition',[0. 0. 18 25]);

if User==Lucas
 print(fig1,'-depsc', [ folder_path,'Chapter9_Relative_glacier_mass_figure\OUTPUT_FIGURES\',figure_filename])
 %Figure as pdf
 print(fig1,'-dpdf', [ folder_path,'Chapter9_Relative_glacier_mass_figure\OUTPUT_FIGURES\',figure_filename])
 display('Figure printed as eps & pdf')
 close(fig1)
elseif User==Baylor
 print(fig1,'-dpng', [ folder_path,'Chapter9_Relative_glacier_mass_figure/OUTPUT_FIGURES/',figure_filename],'-r300', '-painters')
 close(fig1)    
end





