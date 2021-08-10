%% IPCC AR6 Chapter 9: Figure 9.12 (Sea Level Rise)
%
% Code used to plot processed ocean sea-level rise data. 
%
% Plotting code written by Brodie Pearson

clear all

addpath ../../../Functions/

fontsize = 20;


color_bar = IPCC_Get_Colorbar('temperature_nd', 21, true);

color_bar1 = IPCC_Get_Colorbar('temperature_nd', 21, false);
color_bar2 = IPCC_Get_Colorbar('temperature_d', 21, false);
change_color_bar = [color_bar2(3:11,:); color_bar1];


color_bar1 = [2 71 104
    19 93 129
    36 116 154
    54 138 179
    71 161 204
    89 183 228
    121 197 233
    153 210 237
    185 223 241
    217 235 245
    248 248 248
    246 231 207
    243 212 166
    241 195 124
    238 176 83
    235 158 42
    204 138 40
    173 117 38
    142 97 36
    111 76 34
    80 56 33]/255;

change_color_bar = color_bar1;
lims = [-0.6 0.601];




%% Plot Dynamic SSH change map for SSP585

ncfilename = '../Plotted_Data/Fig9-12a_data.nc';
plot_data = ncread(ncfilename, 'StericSeaLevel');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_data ...
    ,lat,lon,lims, ...
    change_color_bar,"SSP5-8.5 Steric SSH change 1984-2100",...
    1,fontsize, true, '(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_data') & plot_data'~=0))


%% Plot Steric SSH change map for SSP126

ncfilename = '../Plotted_Data/Fig9-12d_data.nc';
plot_data = ncread(ncfilename, 'StericSeaLevel');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_data ...
    ,lat,lon,lims, ...
    change_color_bar,"SSP1-2.6 Dynamic SSH change 1984-2100",...
    2,fontsize, false, '')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_data') & plot_data'~=0))

%%  Plot Thermosteric SSH change map for SSP585

ncfilename = '../Plotted_Data/Fig9-12b_data.nc';
plot_data = ncread(ncfilename, 'ThermostericSeaLevel');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_data ...
    ,lat,lon,lims, ...
    change_color_bar,"SSP5-8.5 Thermosteric SSH change 1984-2100",...
    3,fontsize, true, '(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_data') & plot_data'~=0))

%%  Plot Thermosteric SSH change map for SSP126

ncfilename = '../Plotted_Data/Fig9-12e_data.nc';
plot_data = ncread(ncfilename, 'ThermostericSeaLevel');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_data ...
    ,lat,lon,lims, ...
    change_color_bar,"SSP1-2.6 Steric SSH change 1984-2100",...
    4,fontsize, true, '(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_data') & plot_data'~=0))

%% Plot Halosteric SSH change map for SSP585

ncfilename = '../Plotted_Data/Fig9-12c_data.nc';
plot_data = ncread(ncfilename, 'HalostericSeaLevel');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_data ...
    ,lat,lon,lims, ...
    change_color_bar,"SSP5-8.5 Halosteric SSH change 1984-2100",...
    5,fontsize, true, '(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_data') & plot_data'~=0))

%% Plot Halosteric SSH change map for SSP126

ncfilename = '../Plotted_Data/Fig9-12f_data.nc';
plot_data = ncread(ncfilename, 'HalostericSeaLevel');
lat = ncread(ncfilename, 'Latitude');
lon = ncread(ncfilename, 'Longitude');
hatch = ncread(ncfilename, 'Mask');

IPCC_Plot_Map(plot_data ...
    ,lat,lon,lims, ...
    change_color_bar,"SSP1-2.6 Halosteric SSH change 1984-2100",...
    6,fontsize, true, '(m)')

[latitude, longitude] = meshgrid(lat,lon);

stipplem(latitude,longitude,(~logical(hatch') & ...
    ~isnan(plot_data') & plot_data'~=0))
