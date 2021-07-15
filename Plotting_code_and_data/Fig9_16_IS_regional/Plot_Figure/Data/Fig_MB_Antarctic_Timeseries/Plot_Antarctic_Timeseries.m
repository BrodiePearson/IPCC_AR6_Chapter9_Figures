clear all

SL2M=362.5*1000/1e4; % Convert SL rise (m) to Mass Loss (10^4 Gt)

addpath ../../Matlab_Functions/

fontsize=20;
width = 5;

%% Get Bamber Data

T = readtable('Bamber-etal_2018_readme.dat');
Bamber_data=table2array(T);
Bamber_time = Bamber_data(:,1);
Bamber_data_w = Bamber_data(:,4);
Bamber_data_w_std = Bamber_data(:,5);
Bamber_data_e = Bamber_data(:,6);
Bamber_data_e_std = Bamber_data(:,7);

% %% Read ISMIP6 / PROMICE data for SSP585 and SSP126 (Alternative version)
% 
% temp = readtable( ...
%     '../../Fig9_19_GIS_synth/Fig_MB_Greenland_Timeseries/Tamsin_Emulation/191208_annual_CMIP6/summary_SSP585.csv');
% temp = temp(:,1:11);
% ISMIP6_data = table2cell(temp);
% j_rcp585 = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'ALL')));
% j_rcp126 = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'ALL')));
% 
% for jj = 1:length(j_rcp585)
%     % Pull out MEAN of data set (median is 4th column)
%    temp_cell (:,jj) = ISMIP6_data(j_rcp585(jj),11)';
%    % Pull out 0.95 likelihood (v. likely) bound
%    upper_cell (:,jj) = ISMIP6_data(j_rcp585(jj),6)';
%    % Pull out 0.05 likelihood (v. likely) bound
%    lower_cell (:,jj) = ISMIP6_data(j_rcp585(jj),5)';
%    % Pull out 0.83 likelihood (likely) bound
%    upper_l_cell (:,jj) = ISMIP6_data(j_rcp585(jj),8)';
%    % Pull out 0.17 likelihood (likely) bound
%    lower_l_cell (:,jj) = ISMIP6_data(j_rcp585(jj),7)';
%    TIME_ISMIP(jj) = ISMIP6_data(j_rcp585(jj),3)';
% end
% % 
% % for k=1:size(temp_cell,2)
% % temp_cell{1,k} = str2double(temp_cell{1,k});
% % end
% 
% ISMIP_ssp585_AIS = cell2mat(temp_cell);
% ISMIP_ssp585_AIS_95 = cell2mat(upper_cell);
% ISMIP_ssp585_AIS_5 = cell2mat(lower_cell);
% ISMIP_ssp585_AIS_83 = cell2mat(upper_l_cell);
% ISMIP_ssp585_AIS_17 = cell2mat(lower_l_cell);
% TIME_ISMIP = cellfun(@str2num,TIME_ISMIP);
% 
% % Convert from SLE (cm) to Mass Change (Gt)
% ISMIP_ssp585_AIS = 10*ISMIP_ssp585_AIS*(-360);
% ISMIP_ssp585_AIS_5 = 10*ISMIP_ssp585_AIS_5*(-360);
% ISMIP_ssp585_AIS_95 = 10*ISMIP_ssp585_AIS_95*(-360);
% ISMIP_ssp585_AIS_17 = 10*ISMIP_ssp585_AIS_17*(-360);
% ISMIP_ssp585_AIS_83 = 10*ISMIP_ssp585_AIS_83*(-360);
% 
% 
% % ISMIP_ssp585_AIS = cellfun(@str2num,temp_cell);
% % ISMIP_ssp585_AIS_std = cellfun(@str2num,std_cell);
% % TIME_ISMIP = cellfun(@str2num,TIME_ISMIP);
% 
% % % Convert from SLE (cm) to Mass Change (Gt)
% % ISMIP_ssp585_AIS = 10*ISMIP_ssp585_AIS*(-360);
% % ISMIP_ssp585_AIS_std = 10*ISMIP_ssp585_AIS_std*(360);
% 
% temp = readtable( ...
%     '../../Fig9_19_GIS_synth/Fig_MB_Greenland_Timeseries/Tamsin_Emulation/191208_annual_CMIP6/summary_SSP126.csv');
% temp = temp(:,1:11);
% ISMIP6_data = table2cell(temp);
% j_rcp126 = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'ALL')));
% j_rcp126 = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'ALL')));
% 
% for jj = 1:length(j_rcp126)
%     % Pull out MEAN of data set (median is 4th column)
%    temp_cell (:,jj) = ISMIP6_data(j_rcp126(jj),11)';
%    % Pull out 0.95 likelihood (v. likely) bound
%    upper_cell (:,jj) = ISMIP6_data(j_rcp126(jj),6)';
%    % Pull out 0.05 likelihood (v. likely) bound
%    lower_cell (:,jj) = ISMIP6_data(j_rcp126(jj),5)';
%    % Pull out 0.83 likelihood (likely) bound
%    upper_l_cell (:,jj) = ISMIP6_data(j_rcp126(jj),8)';
%    % Pull out 0.17 likelihood (likely) bound
%    lower_l_cell (:,jj) = ISMIP6_data(j_rcp126(jj),7)';
% end
% 
% % for k=1:size(temp_cell,2)
% % temp_cell{1,k} = str2double(temp_cell{1,k});
% % end
% 
% ISMIP_ssp126_AIS = cell2mat(temp_cell);
% ISMIP_ssp126_AIS_95 = cell2mat(upper_cell);
% ISMIP_ssp126_AIS_5 = cell2mat(lower_cell);
% ISMIP_ssp126_AIS_83 = cell2mat(upper_l_cell);
% ISMIP_ssp126_AIS_17 = cell2mat(lower_l_cell);
% 
% % Convert from SLE (cm) to Mass Change (Gt)
% ISMIP_ssp126_AIS = 10*ISMIP_ssp126_AIS*(-360);
% ISMIP_ssp126_AIS_5 = 10*ISMIP_ssp126_AIS_5*(-360);
% ISMIP_ssp126_AIS_95 = 10*ISMIP_ssp126_AIS_95*(-360);
% ISMIP_ssp126_AIS_17 = 10*ISMIP_ssp126_AIS_17*(-360);
% ISMIP_ssp126_AIS_83 = 10*ISMIP_ssp126_AIS_83*(-360);
% % 
% % for jj = 1:length(j_rcp126)
% %    temp_cell (:,jj) = ISMIP6_data(j_rcp126(jj),4)';
% %    std_cell (:,jj) = ISMIP6_data(j_rcp126(jj),5)';
% % end
% % 
% % ISMIP_ssp126_AIS = cellfun(@str2num,temp_cell);
% % ISMIP_ssp126_AIS_std = cellfun(@str2num,std_cell);
% % 
% % % Convert from SLE (cm) to Mass Change (Gt)
% % ISMIP_ssp126_AIS = 10*ISMIP_ssp126_AIS*(-360);
% % ISMIP_ssp126_AIS_std = 10*ISMIP_ssp126_AIS_std*(360);

% %% Read ISMIP6 / PROMICE data for SSP585 and SSP126
% 
% temp = readtable('../../Fig9_19_GIS_synth/Fig_MB_Greenland_Timeseries/Tamsin_Emulation/20191216_SLE_SIMULATIONS.csv');
% ISMIP6_data = table2array(temp);
% i_start = find(~cellfun('isempty',strfind(ISMIP6_data(1,:),'2015')));
% i_end = find(~cellfun('isempty',strfind(ISMIP6_data(1,:),'2100')));
% TIME_ISMIP = [2015:1:2100]';
% 
% j_rcp585_e = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'EAIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')));
% j_rcp126_e = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'EAIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')));
% j_rcp585_w = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'WAIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')));
% j_rcp126_w = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'WAIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')));
% j_rcp585_p = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'PEN')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')));
% j_rcp126_p = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'PEN')) ...
%     & ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')));
% 
% for jj = 1:length(j_rcp585_e)
%    temp_cell (:,jj) = ISMIP6_data(j_rcp585_e(jj),i_start:i_end)';
% end
% ISMIP_ssp585_EAIS = cellfun(@str2num,temp_cell);
% clear temp_cell
% for jj = 1:length(j_rcp126_e)
%    temp_cell (:,jj) = ISMIP6_data(j_rcp126_e(jj),i_start:i_end)';
% end
% ISMIP_ssp126_EAIS = cellfun(@str2num,temp_cell);
% clear temp_cell
% for jj = 1:length(j_rcp585_w)
%    temp_cell (:,jj) = ISMIP6_data(j_rcp585_w(jj),i_start:i_end)';
% end
% ISMIP_ssp585_WAIS = cellfun(@str2num,temp_cell);
% clear temp_cell
% for jj = 1:length(j_rcp126_w)
%    temp_cell (:,jj) = ISMIP6_data(j_rcp126_w(jj),i_start:i_end)';
% end
% ISMIP_ssp126_WAIS = cellfun(@str2num,temp_cell);
% clear temp_cell
% for jj = 1:length(j_rcp585_p)
%    temp_cell (:,jj) = ISMIP6_data(j_rcp585_p(jj),i_start:i_end)';
% end
% ISMIP_ssp585_PEN = cellfun(@str2num,temp_cell);
% clear temp_cell
% for jj = 1:length(j_rcp126_p)
%    temp_cell (:,jj) = ISMIP6_data(j_rcp126_p(jj),i_start:i_end)';
% end
% ISMIP_ssp126_PEN = cellfun(@str2num,temp_cell);
% clear temp_cell
% 
% ISMIP_ssp585_AIS = ISMIP_ssp585_EAIS + ISMIP_ssp585_WAIS + ISMIP_ssp585_PEN;
% ISMIP_ssp126_AIS = ISMIP_ssp126_EAIS + ISMIP_ssp126_WAIS + ISMIP_ssp126_PEN;
% 
% % Convert from SLE (cm) to Mass Change (Gt)
% ISMIP_ssp585_AIS_full = 10*ISMIP_ssp585_AIS*(-360);
% ISMIP_ssp126_AIS_full = 10*ISMIP_ssp126_AIS*(-360);

%% Load LARMIP data (Anders and Greg)

cd ../LARMIP_SMB

baselinestart=2015;
baselineend=2015;

filels=dir('*.nc');
for ff=1:length(filels)
    fname=filels(ff).name;
    readncfile
   % offset=mean(globalSL_quantiles(find(years(:)>=baselinestart&years(:)<=baselineend),3));
    rd(:,1)=years;
    rd(:,2:6)=globalSL_quantiles;
    eval(['larmip',filels(ff).name(34:39),'=rd;']);
end

cd ../Fig_MB_Antarctic_Timeseries/

%% Load emulator data (Tamsin)

% Old data %temp = readtable('../../Fig9_18_GIS_synth/Tamsinfiles/summary_FAIR_SSP585.csv');
temp = readtable('../Tamsinfiles/v010/summary_FAIR_SSP585.csv');
temp = temp(2:end,1:11);
Emu_data = table2cell(temp);
j_rcp585 = find(~cellfun('isempty',strfind(Emu_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(Emu_data(:,2),'ALL')));

for jj = 1:length(j_rcp585)
    % Pull out MEAN of data set (median is 4th column)
   temp_cell(:,jj) = Emu_data(j_rcp585(jj),4)';
   % Pull out 0.95 likelihood (v. likely) bound
   upper_cell(:,jj) = Emu_data(j_rcp585(jj),6)';
   % Pull out 0.05 likelihood (v. likely) bound
   lower_cell(:,jj) = Emu_data(j_rcp585(jj),5)';
   % Pull out 0.83 likelihood (likely) bound
   upper_l_cell(:,jj) = Emu_data(j_rcp585(jj),8)';
   % Pull out 0.17 likelihood (likely) bound
   lower_l_cell(:,jj) = Emu_data(j_rcp585(jj),7)';
   TIME_Emu(jj) = Emu_data(j_rcp585(jj),3)';
end

% for k=1:size(temp_cell,2)
% temp_cell{1,k} = str2double(temp_cell{1,k});
% end

Emu_ssp585_AIS = cell2mat(temp_cell);
Emu_ssp585_AIS_95 = cell2mat(upper_cell);
Emu_ssp585_AIS_5 = cell2mat(lower_cell);
Emu_ssp585_AIS_83 = cell2mat(upper_l_cell);
Emu_ssp585_AIS_17 = cell2mat(lower_l_cell);
TIME_Emu = cell2mat(TIME_Emu);
Emu_Time=TIME_Emu;

% Convert from SLE (cm) to Mass Change (Gt)
Emu_ssp585_AIS = movmean(10*Emu_ssp585_AIS*(-362.5),5);
Emu_ssp585_AIS_5 = movmean(10*Emu_ssp585_AIS_5*(-362.5),5);
Emu_ssp585_AIS_95 = movmean(10*Emu_ssp585_AIS_95*(-362.5),5);
Emu_ssp585_AIS_17 = movmean(10*Emu_ssp585_AIS_17*(-362.5),5);
Emu_ssp585_AIS_83 = movmean(10*Emu_ssp585_AIS_83*(-362.5),5);

%Old data %temp = readtable('../../Fig9_18_GIS_synth/Tamsinfiles/summary_FAIR_SSP126.csv');
temp = readtable('../Tamsinfiles/v010/summary_FAIR_SSP126.csv');
temp = temp(2:end,1:11);
Emu_data = table2cell(temp);
j_rcp126 = find(~cellfun('isempty',strfind(Emu_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(Emu_data(:,2),'ALL')));

for jj = 1:length(j_rcp126)
    % Pull out MEAN of data set (median is 4th column)
   temp_cell1(:,jj) = Emu_data(j_rcp126(jj),4)';
   % Pull out 0.95 likelihood (v. likely) bound
   upper_cell1(:,jj) = Emu_data(j_rcp126(jj),6)';
   % Pull out 0.05 likelihood (v. likely) bound
   lower_cell1(:,jj) = Emu_data(j_rcp126(jj),5)';
   % Pull out 0.83 likelihood (likely) bound
   upper_l_cell1(:,jj) = Emu_data(j_rcp126(jj),8)';
   % Pull out 0.17 likelihood (likely) bound
   lower_l_cell1(:,jj) = Emu_data(j_rcp126(jj),7)';
end

% for k=1:size(temp_cell1,2)
% temp_cell1{1,k} = str2double(temp_cell1{1,k});
% end

Emu_ssp126_AIS = cell2mat(temp_cell1);
Emu_ssp126_AIS_95 = cell2mat(upper_cell1);
Emu_ssp126_AIS_5 = cell2mat(lower_cell1);
Emu_ssp126_AIS_83 = cell2mat(upper_l_cell1);
Emu_ssp126_AIS_17 = cell2mat(lower_l_cell1);

% Convert from SLE (cm) to Mass Change (Gt)
Emu_ssp126_AIS = movmean(10*Emu_ssp126_AIS*(-362.5),5);
Emu_ssp126_AIS_5 = movmean(10*Emu_ssp126_AIS_5*(-362.5),5);
Emu_ssp126_AIS_95 = movmean(10*Emu_ssp126_AIS_95*(-362.5),5);
Emu_ssp126_AIS_17 = movmean(10*Emu_ssp126_AIS_17*(-362.5),5);
Emu_ssp126_AIS_83 = movmean(10*Emu_ssp126_AIS_83*(-362.5),5);

%Old data %temp = readtable('../../Fig9_18_GIS_synth/Tamsinfiles/summary_FAIR_SSP126.csv');
temp = readtable('../Tamsinfiles/v010/summary_FAIR_SSP126.csv');
temp = temp(2:end,1:11);
Emu_data = table2cell(temp);
j_rcp126 = find(~cellfun('isempty',strfind(Emu_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(Emu_data(:,2),'ALL')));

for jj = 1:length(j_rcp126)
    % Pull out MEAN of data set (median is 4th column)
   temp_cell1(:,jj) = Emu_data(j_rcp126(jj),4)';
   % Pull out 0.95 likelihood (v. likely) bound
   upper_cell1(:,jj) = Emu_data(j_rcp126(jj),6)';
   % Pull out 0.05 likelihood (v. likely) bound
   lower_cell1(:,jj) = Emu_data(j_rcp126(jj),5)';
   % Pull out 0.83 likelihood (likely) bound
   upper_l_cell1(:,jj) = Emu_data(j_rcp126(jj),8)';
   % Pull out 0.17 likelihood (likely) bound
   lower_l_cell1(:,jj) = Emu_data(j_rcp126(jj),7)';
end

% for k=1:size(temp_cell1,2)
% temp_cell1{1,k} = str2double(temp_cell1{1,k});
% end

Emu_ssp126_AIS = cell2mat(temp_cell1);
Emu_ssp126_AIS_95 = cell2mat(upper_cell1);
Emu_ssp126_AIS_5 = cell2mat(lower_cell1);
Emu_ssp126_AIS_83 = cell2mat(upper_l_cell1);
Emu_ssp126_AIS_17 = cell2mat(lower_l_cell1);

% Convert from SLE (cm) to Mass Change (Gt)
Emu_ssp126_AIS = movmean(10*Emu_ssp126_AIS*(-362.5),5);
Emu_ssp126_AIS_5 = movmean(10*Emu_ssp126_AIS_5*(-362.5),5);
Emu_ssp126_AIS_95 = movmean(10*Emu_ssp126_AIS_95*(-362.5),5);
Emu_ssp126_AIS_17 = movmean(10*Emu_ssp126_AIS_17*(-362.5),5);
Emu_ssp126_AIS_83 = movmean(10*Emu_ssp126_AIS_83*(-362.5),5);



%% Load ISMIP6 data (Helene)
% % Convert from SLE (mm) to Mass Change (Gt)
% load('../../Fig9_19_GIS_synth/HeleneData/limnsw_rcp85.mat')
% load('../../Fig9_19_GIS_synth/HeleneData/limnsw_rcp26.mat')
% ISMIP_ssp585_AIS_full = limnsw_rcp85*(-362.5);
% ISMIP_ssp126_AIS_full = limnsw_rcp26*(-362.5);
% TIME_ISMIP = [2015:1:2100]';

temp = readtable('../Tamsinfiles/20201106_SLE_SIMULATIONS_SI.csv');
ISMIP6_data = table2cell(temp);
i_start = find(contains(temp.Properties.VariableNames,'y2015'));
i_end = find(contains(temp.Properties.VariableNames,'y2100'));
% i_end = find(~cellfun('isempty',strfind(ISMIP6_data(1,:),'2100')));
TIME_ISMIP = [2015:1:2100]';
j_rcp585_w = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'WAIS')) ...
    & cellfun('isempty',strfind(ISMIP6_data(:,i_end+1),'New')) ...
    & (~cellfun('isempty',strfind(ISMIP6_data(:,8),'SSP585')) | ...
    ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')) ));
j_rcp126_w = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'WAIS')) ...
    & cellfun('isempty',strfind(ISMIP6_data(:,i_end+1),'New')) ...
    & (~cellfun('isempty',strfind(ISMIP6_data(:,8),'SSP126')) | ...
    ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')) ));
j_rcp585_e = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'EAIS')) ...
    & cellfun('isempty',strfind(ISMIP6_data(:,i_end+1),'New')) ...
    & (~cellfun('isempty',strfind(ISMIP6_data(:,8),'SSP585')) | ...
    ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')) ));
j_rcp126_e = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'EAIS')) ...
    & cellfun('isempty',strfind(ISMIP6_data(:,i_end+1),'New')) ...
    & (~cellfun('isempty',strfind(ISMIP6_data(:,8),'SSP126')) | ...
    ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')) ));
j_rcp585_p = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'PEN')) ...
    & cellfun('isempty',strfind(ISMIP6_data(:,i_end+1),'New')) ...
    & (~cellfun('isempty',strfind(ISMIP6_data(:,8),'SSP585')) | ...
    ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP85')) ));
j_rcp126_p = find(~cellfun('isempty',strfind(ISMIP6_data(:,1),'AIS')) ...
    & ~cellfun('isempty',strfind(ISMIP6_data(:,2),'PEN')) ...
    & cellfun('isempty',strfind(ISMIP6_data(:,i_end+1),'New')) ...
    & (~cellfun('isempty',strfind(ISMIP6_data(:,8),'SSP126')) | ...
    ~cellfun('isempty',strfind(ISMIP6_data(:,8),'RCP26')) ));
clear temp_cell
for jj = 1:length(j_rcp585_w)
   temp_cell (:,jj) = cell2mat(ISMIP6_data(j_rcp585_w(jj),i_start:i_end)') + ...
       cell2mat(ISMIP6_data(j_rcp585_e(jj),i_start:i_end)') + ...
       cell2mat(ISMIP6_data(j_rcp585_p(jj),i_start:i_end)');
end
ISMIP_ssp585_AIS = temp_cell;
clear temp_cell
for jj = 1:length(j_rcp126_w)
   temp_cell (:,jj) = cell2mat(ISMIP6_data(j_rcp126_w(jj),i_start:i_end)') + ...
       cell2mat(ISMIP6_data(j_rcp126_e(jj),i_start:i_end)') + ...
       cell2mat(ISMIP6_data(j_rcp126_p(jj),i_start:i_end)');
end
ISMIP_ssp126_AIS = temp_cell;

% Convert from SLE (cm) to Mass Change (Gt) Add ISMIP AIS trend
ISMIP_ssp585_AIS_full = 10*ISMIP_ssp585_AIS*(-362.5) + (TIME_ISMIP-TIME_ISMIP(1))*0.033*10*(-362.5);
ISMIP_ssp126_AIS_full = 10*ISMIP_ssp126_AIS*(-362.5) + (TIME_ISMIP-TIME_ISMIP(1))*0.033*10*(-362.5);

ISMIP_ssp585_AIS_5= movmean(quantile(ISMIP_ssp585_AIS_full,0.05,2),5);
ISMIP_ssp585_AIS_17= movmean(quantile(ISMIP_ssp585_AIS_full,0.17,2),5);
ISMIP_ssp585_AIS_50 = movmean(quantile(ISMIP_ssp585_AIS_full,0.50,2),5);
ISMIP_ssp585_AIS_83 = movmean(quantile(ISMIP_ssp585_AIS_full,0.83,2),5);
ISMIP_ssp585_AIS_95 = movmean(quantile(ISMIP_ssp585_AIS_full,0.95,2),5);
ISMIP_ssp126_AIS_5 = movmean(quantile(ISMIP_ssp126_AIS_full,0.05,2),5);
ISMIP_ssp126_AIS_17= movmean(quantile(ISMIP_ssp126_AIS_full,0.17,2),5);
ISMIP_ssp126_AIS_50 = movmean(quantile(ISMIP_ssp126_AIS_full,0.50,2),5);
ISMIP_ssp126_AIS_83 = movmean(quantile(ISMIP_ssp126_AIS_full,0.83,2),5);
ISMIP_ssp126_AIS_95 = movmean(quantile(ISMIP_ssp126_AIS_full,0.95,2),5);
%This must be last to avoid affecting quantile diagnoses
ISMIP_ssp585_AIS = movmean(nanmean(ISMIP_ssp585_AIS_full,2),5);
ISMIP_ssp126_AIS = movmean(nanmean(ISMIP_ssp126_AIS_full,2),5);

% Add ISMIP AIS trend
ISMIP_ssp585_AIS = ISMIP_ssp585_AIS + (TIME_ISMIP-TIME_ISMIP(1))*0.033*10*(-362.5);
ISMIP_ssp126_AIS = ISMIP_ssp126_AIS + (TIME_ISMIP-TIME_ISMIP(1))*0.033*10*(-362.5);

%% Make Plots

color_OBS = [196 121 0]/255;
color_HR = [0 79 0]/255;
color_CMIP = [0 0 0]/255;
color_SSP126 = IPCC_Get_SSPColors('ssp126');
color_SSP245 = IPCC_Get_SSPColors('ssp245');
color_SSP370 = IPCC_Get_SSPColors('ssp370');
color_SSP585 = IPCC_Get_SSPColors('ssp585');

% running_mean = 10; % Running mean length in years
% 
% ISMIP_ssp585_AIS = movmean(ISMIP_ssp585_AIS,running_mean);
% ISMIP_ssp585_AIS_std = movmean(ISMIP_ssp585_AIS_std,running_mean);
% ISMIP_ssp126_AIS = movmean(ISMIP_ssp126_AIS,running_mean);
% ISMIP_ssp126_AIS_std = movmean(ISMIP_ssp126_AIS_std,running_mean);

%% Get IMBIE Data

IMBIE_data=xlsread('../IMBIE_latest/IMBIE_AR6.xlsx');

%% Define IMBIE Data

AA_Imbie = IMBIE_data(:,9);    % No longer reverting Back to IMBIE-2 IMBIE_data(:,9) for latest
AA_Imbie = AA_Imbie - AA_Imbie(277);  % Baseline 2015
AA_Imbie_unc = IMBIE_data(:,10); % No longer reverting Back to IMBIE-2 IMBIE_data(:,10) for latest
TIME_OBS = IMBIE_data(:,1);
%AA_Imbie_sl = IMBIE_data(:,4);
%AA_Imbie_unc_sl = IMBIE_data(:,5);
% OHC_OBS_anom = OHC_OBS - nanmean(OHC_OBS(TIME_OBS<=2015 & TIME_OBS>=2004));
OBS_ubound=AA_Imbie+AA_Imbie_unc;
OBS_lbound=AA_Imbie-AA_Imbie_unc;
OBS_Conf_Bounds = [OBS_ubound; flipud(OBS_lbound); OBS_ubound(1)];
OBS_Time_Conf_Bounds = [TIME_OBS; flipud(TIME_OBS); TIME_OBS(1)];

%% Define IMBIE regional data (as dummy datasets for now)

IMBIE_data_p=csvread('../IMBIE_latest/apis_dm.csv');

AA_Imbie_p = IMBIE_data_p(:,2);
AA_Imbie_p = AA_Imbie_p - AA_Imbie_p(277); % Baseline 2015
AA_Imbie_p_unc = IMBIE_data_p(:,3);
TIME_OBS_p = IMBIE_data_p(:,1);

OBS_ubound_p=AA_Imbie_p+AA_Imbie_p_unc;
OBS_lbound_p=AA_Imbie_p-AA_Imbie_p_unc;
OBS_Conf_Bounds_p = [OBS_ubound_p; flipud(OBS_lbound_p); OBS_ubound_p(1)];
OBS_Time_Conf_Bounds_p = [TIME_OBS_p; flipud(TIME_OBS_p); TIME_OBS_p(1)];

IMBIE_data_e=csvread('../IMBIE_latest/eais_dm.csv');

AA_Imbie_e = IMBIE_data_e(:,2);
AA_Imbie_e = AA_Imbie_e - AA_Imbie_e(277);
AA_Imbie_e_unc = IMBIE_data_e(:,3);
TIME_OBS_e = IMBIE_data_e(:,1);

OBS_ubound_e=AA_Imbie_e+AA_Imbie_e_unc;
OBS_lbound_e=AA_Imbie_e-AA_Imbie_e_unc;
OBS_Conf_Bounds_e = [OBS_ubound_e; flipud(OBS_lbound_e); OBS_ubound_e(1)];
OBS_Time_Conf_Bounds_e = [TIME_OBS_e; flipud(TIME_OBS_e); TIME_OBS_e(1)];

IMBIE_data_w=csvread('../IMBIE_latest/wais_dm.csv');

AA_Imbie_w = IMBIE_data_w(:,2);
AA_Imbie_w = AA_Imbie_w - AA_Imbie_w(277);
AA_Imbie_w_unc = IMBIE_data_w(:,3);
TIME_OBS_w = IMBIE_data_w(:,1);

OBS_ubound_w=AA_Imbie_w+AA_Imbie_w_unc;
OBS_lbound_w=AA_Imbie_w-AA_Imbie_w_unc;
OBS_Conf_Bounds_w = [OBS_ubound_w; flipud(OBS_lbound_w); OBS_ubound_w(1)];
OBS_Time_Conf_Bounds_w = [TIME_OBS_w; flipud(TIME_OBS_w); TIME_OBS_w(1)];

%% Define Bamber regional data (as dummy datasets for now)
% Must sum (as currently in annual mass balance ith units of Gt per annum)
for ii=1:length(Bamber_data_w)
    AA_Bamber_w(ii) = sum(Bamber_data_w(1:ii)); 
    AA_Bamber_e(ii) = sum(Bamber_data_e(1:ii)); 
end

AA_Bamber_w = AA_Bamber_w - AA_Bamber_w(24);
AA_Bamber_e = AA_Bamber_e - AA_Bamber_e(24);

%% Create ISMIP Error bounds

% ISMIP_585_Conf_Bounds = [ISMIP_ssp585_AIS'+ISMIP_ssp585_AIS_std'; ...
%     flipud(ISMIP_ssp585_AIS'-ISMIP_ssp585_AIS_std'); ...
%     ISMIP_ssp585_AIS(1)'+ISMIP_ssp585_AIS_std(1)'];
% ISMIP_126_Conf_Bounds = [ISMIP_ssp126_AIS'+ISMIP_ssp126_AIS_std'; ...
%     flipud(ISMIP_ssp126_AIS'-ISMIP_ssp126_AIS_std'); ...
%     ISMIP_ssp126_AIS(1)'+ISMIP_ssp126_AIS_std(1)'];
ISMIP_585_Conf_Bounds = [ISMIP_ssp585_AIS_83; ...
    flipud(ISMIP_ssp585_AIS_17); ...
    ISMIP_ssp585_AIS_83(1)];
ISMIP_126_Conf_Bounds = [ISMIP_ssp126_AIS_83; ...
    flipud(ISMIP_ssp126_AIS_17); ...
    ISMIP_ssp126_AIS_83(1)];
ISMIP_Time_Conf_Bounds = [TIME_ISMIP; flipud(TIME_ISMIP); TIME_ISMIP(1)];
Emu_Time_LikelyRange = [TIME_Emu'; flipud(TIME_Emu'); TIME_Emu(1)'];
Emu_585_LikelyRange = [Emu_ssp585_AIS_83'; ...
    flipud(Emu_ssp585_AIS_17'); ...
    Emu_ssp585_AIS_83(:,1)];
Emu_126_LikelyRange = [Emu_ssp126_AIS_83'; ...
    flipud(Emu_ssp126_AIS_17'); ...
    Emu_ssp126_AIS_83(:,1)];
Emu_585_VeryLikelyRange = [Emu_ssp585_AIS_95'; ...
    flipud(Emu_ssp585_AIS_5'); ...
    Emu_ssp585_AIS_95(:,1)];
Emu_126_VeryLikelyRange = [Emu_ssp126_AIS_95'; ...
    flipud(Emu_ssp126_AIS_5'); ...
    Emu_ssp126_AIS_95(:,1)];

%% Load Rignot data from Fig9.16


%% New emulator data (corrected; Greg Garner Mar 2021)

EMU_New_585= double(ncread('../AIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp585_AIS_globalsl_figuredata.nc','globalSL_quantiles'));
EMU_New_370= double(ncread('../AIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp370_AIS_globalsl_figuredata.nc','globalSL_quantiles'));
EMU_New_245= double(ncread('../AIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp245_AIS_globalsl_figuredata.nc','globalSL_quantiles'));
EMU_New_126= double(ncread('../AIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp126_AIS_globalsl_figuredata.nc','globalSL_quantiles'));
Emu_New_Time = ncread('../AIS_emulated_projections/icesheets-ipccar6-ismipemuicesheet-ssp126_AIS_globalsl_figuredata.nc','years');
Emu_New_Time = [2015; Emu_New_Time];
Emu_New_Time_LikelyRange = [Emu_New_Time; flipud(Emu_New_Time); Emu_New_Time(1)];
Emu_New_585 = [0; EMU_New_585(:,3)];  % 0 added for baseline and 2015 start date
Emu_New_126 = [0; EMU_New_126(:,3)];  % 0 added for baseline and 2015 start date
Emu_New_585_LikelyRange = [0; EMU_New_585(:,4); ...
    flipud(EMU_New_585(:,2)); ...
    0; 0]; %EMU_New_585(1,4); 0];
Emu_New_585_VeryLikelyRange = [0; EMU_New_585(:,5); ...
    flipud(EMU_New_585(:,1)); ...
    0; 0]; %EMU_New_585(1,5); 0];
Emu_New_126_LikelyRange = [0; EMU_New_126(:,4); ...
    flipud(EMU_New_126(:,2)); ...
    0; 0]; %EMU_New_585(1,5); 0];
Emu_New_126_VeryLikelyRange = [0; EMU_New_126(:,5); ...
    flipud(EMU_New_126(:,1)); ...
    0; 0]; %EMU_New_585(1,5); 0];

%% Rignot Data

Rignot_data=textread('Rignot_AA_CMB.txt');
Rignot_time=Rignot_data(:,1);
AA_Rignot=(Rignot_data(:,2)-Rignot_data(433,2))/1e4; % Baseline and scale
Range_Rignot=[AA_Rignot+Rignot_data(:,3); ...
    flipud(AA_Rignot-Rignot_data(:,3)); ...
    AA_Rignot(1)+Rignot_data(1,3)]/1e4;
Range_Rignot_time=[Rignot_time(:); ...
    flipud(Rignot_time(:)); ...
    Rignot_time(1)];

%% Now the data from 9.16 Rignot Update
file_RIGNOT='Rignot_Update_Antarctica.xlsx'

time=xlsread(file_RIGNOT,'Rignot','A2:A489');

year=floor(time);
month=(time-year)*12;
RIGNOT_time0=x2mdate(time);

RIGNOT_time = datetime(RIGNOT_time0,'ConvertFrom','datenum');

RIGNOT_year=datevec(RIGNOT_time);
RIGNOT_year=RIGNOT_year(:,1)+(RIGNOT_year(:,2)-1)/12;

%RIGNOT_time=(RIGNOT_time0(19:12:end));

% Loading in the monthly data
% clear RIGNOT_MB RIGNOT_SMB RIGNOT_D

%RIGNOT_MB(:,1)=xlsread(file_RIGNOT,'Rignot','B2:B489');
%RIGNOT_MB(:,2)=xlsread(file_RIGNOT,'Rignot','C2:C489');
RIGNOT_MB(:,1)=xlsread(file_RIGNOT,'Rignot','F2:F489'); %These are incorrectly labeled in the xls file.
RIGNOT_MB(:,2)=xlsread(file_RIGNOT,'Rignot','G2:G489');

RIGNOT_MB(:,1)=(RIGNOT_MB(:,1)-RIGNOT_MB(433,1))/1e4; % Baseline and scale
RIGNOT_MB(:,2)=(RIGNOT_MB(:,2))/1e4;

%%Checked that these are consistent, so now overwrite the old with the
%%updated for plotting.
Rignot_time=RIGNOT_year;
AA_Rignot=RIGNOT_MB(:,1);
Range_Rignot=[AA_Rignot+RIGNOT_MB(:,2); ...
    flipud(AA_Rignot-RIGNOT_MB(:,2)); ...
    AA_Rignot(1)+RIGNOT_MB(1,2)];
Range_Rignot_time=[Rignot_time(:); ...
    flipud(Rignot_time(:)); ...
    Rignot_time(1)];


%% Make plots


%figure('Position', [10 10 1200 400])
figure('Position', [10 10 1600 400])
subplot(1,100,1:75)
yyaxis left
plot(TIME_ISMIP,ISMIP_ssp585_AIS_full/1e4, 'Color', [color_SSP585 0.2], 'LineWidth', width/20,'LineStyle','-','Marker','none')
hold on
plot(Rignot_time,AA_Rignot,'Color',color_HR, 'LineWidth', width/2,'LineStyle','-','Marker','none');
patch(Range_Rignot_time,Range_Rignot,color_HR, 'EdgeColor', 'none', 'FaceAlpha', 0.2)

h4=plot(TIME_ISMIP,ISMIP_ssp585_AIS_full(:,1)/1e4, 'Color', [color_SSP585 0.2], 'LineWidth', width/20,'LineStyle','-','Marker','none')
plot(TIME_ISMIP,ISMIP_ssp126_AIS_full/1e4, 'Color', [color_SSP126 0.2], 'LineWidth', width/20,'LineStyle','-','Marker','none')
patch(OBS_Time_Conf_Bounds,OBS_Conf_Bounds/1e4,color_OBS, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
hold on
plot(TIME_OBS,AA_Imbie/1e4, 'Color', color_OBS, 'LineWidth', width/2,'LineStyle','-','Marker','none')
plot(Bamber_time,(AA_Bamber_w+AA_Bamber_e)/1e4, 'Color', color_SSP370, 'LineWidth', width/2,'LineStyle','-','Marker','none')

h1=patch(Emu_New_Time_LikelyRange,Emu_New_585_LikelyRange*(-362.5)/1e4,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.4)
patch(Emu_New_Time_LikelyRange,Emu_New_126_LikelyRange*(-362.5)/1e4,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.4)
h2=patch(Emu_New_Time_LikelyRange,Emu_New_585_VeryLikelyRange*(-362.5)/1e4,color_SSP585, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
patch(Emu_New_Time_LikelyRange,Emu_New_126_VeryLikelyRange*(-362.5)/1e4,color_SSP126, 'EdgeColor', 'none', 'FaceAlpha', 0.2)
h3=plot(Emu_New_Time,Emu_New_585*(-362.5)/1e4, 'Color', color_SSP585, 'LineWidth', width/1.5,'LineStyle','-','Marker','none')
plot(Emu_New_Time,Emu_New_126*(-362.5)/1e4, 'Color', color_SSP126, 'LineWidth', width/1.5,'LineStyle','-','Marker','none')


xlim([1979 2100])
ylims=[-18 5];
ylim(ylims)
ylength = ylims(2)-ylims(1);
%ylabel('Mass Change (10^4 Gt)','FontSize',20)
ylabel('10^4 Gt    ')
set(get(gca,'YLabel'),'Rotation',0)
set(gca,'FontSize',20)
set(gca,'Ytick',[-16 -14 -12 -10 -8 -6 -4 -2 0 2 4], ...
    'Yticklabel',{'-16','','-12','','-8','','-4','', '0','','4'})
set(gca,'FontSize',20)
yyaxis right
ylim(-10*fliplr(ylims)/362.5)
set ( gca, 'ydir', 'reverse' )
set(gca,'Ytick',[-0.1 -0.05 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5], ...
    'Yticklabel',{'-0.1', '','0','','0.1', '','0.2','','0.3','','0.4','','0.5'})
%ylabel('Equivalent Sea Level Contribution (m)','FontSize',20)
yyaxis left


txt = 'Rignot';
text(1985,1.5, ...
    txt,'FontSize',20, ...
    'Color', color_HR, 'FontWeight', 'bold')
txt = 'IMBIE';
text(2000,-1.0, ...
    txt,'FontSize',20, ...
    'Color', color_OBS, 'FontWeight', 'bold')
txt = 'Bamber';
text(2000,1.0, ...
    txt,'FontSize',20, ...
    'Color', color_SSP370, 'FontWeight', 'bold')
txt = 'SSP1-2.6';
text(2080,-6, ...
    txt,'FontSize',20, ...
    'Color', color_SSP126, 'FontWeight', 'bold')
txt = 'SSP5-8.5';
text(2060,-3, ...
    txt,'FontSize',20, ...
    'Color', color_SSP585, 'FontWeight', 'bold')
txt = 'Modern & Projected Changes';
text(1980,4.3,txt,'FontSize',20, ...
    'Color', 'k', 'FontWeight', 'bold')
txt = 'm';
text(2102,-2,txt,'FontSize',20, ...
    'Color', 'k')
set(gca,'Box', 'on','Clipping','off')
set(gca,'TickDir','in');
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';

plot([1979 2100],0*[1992 2100], 'k:', 'LineWidth', 2)
%plot([2016 2016],ylims-[0 1], 'k:', 'LineWidth', 2)

% Plot Emulator 2100 ranges in 1e4 Gt
offset = 2;

plot(offset+[2109,2109], [EMU_New_126(end,3), EMU_New_126(end,3)]*(-362.5)/1e4 ...
    , '.', 'Color',color_SSP126, 'MarkerSize', 20)
plot(offset+[2109,2109], [EMU_New_126(end,4), EMU_New_126(end,2)]*(-362.5)/1e4 ...
    , '-', 'Color',color_SSP126, 'LineWidth', width)
plot(offset+[2109,2109], [EMU_New_126(end,5), EMU_New_126(end,1)]*(-362.5)/1e4 ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)

plot(offset+[2110,2110], [EMU_New_245(end,3), EMU_New_245(end,3)]*(-362.5)/1e4 ...
    , '.', 'Color',color_SSP245, 'MarkerSize', 20)
plot(offset+[2110,2110], [EMU_New_245(end,4), EMU_New_245(end,2)]*(-362.5)/1e4 ...
    , '-', 'Color',color_SSP245, 'LineWidth', width)
plot(offset+[2110,2110], [EMU_New_245(end,5), EMU_New_245(end,1)]*(-362.5)/1e4 ...
    , '-', 'Color',color_SSP245, 'LineWidth', width/2)

plot(offset+[2111,2111], [EMU_New_370(end,3), EMU_New_370(end,3)]*(-362.5)/1e4 ...
    , '.', 'Color',color_SSP370, 'MarkerSize', 20)
plot(offset+[2111,2111], [EMU_New_370(end,4), EMU_New_370(end,2)]*(-362.5)/1e4 ...
    , '-', 'Color',color_SSP370, 'LineWidth', width)
plot(offset+[2111,2111], [EMU_New_370(end,5), EMU_New_370(end,1)]*(-362.5)/1e4 ...
    , '-', 'Color',color_SSP370, 'LineWidth', width/2)

plot(offset+[2112,2112], [EMU_New_585(end,3), EMU_New_585(end,3)]*(-362.5)/1e4 ...
    , '.', 'Color',color_SSP585, 'MarkerSize', 20)
plot(offset+[2112,2112], [EMU_New_585(end,4), EMU_New_585(end,2)]*(-362.5)/1e4 ...
    , '-', 'Color',color_SSP585, 'LineWidth', width)
plot(offset+[2112,2112], [EMU_New_585(end,5), EMU_New_585(end,1)]*(-362.5)/1e4 ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)

% Plot ISMIP 2100 ranges
% From table 9.2
% Median (66% range) [90% range] contribution from ISMIP6 CMIP5- and CMIP6-forced multi-model ensembles, including historical dynamic response.
% SSP1-2.6
% 0.05 (0.04 to 0.08)[0.03 to 0.11] m
% SSP5-8.5
% 0.04 (0.00 to 0.12)[-0.02 to 0.23] m

Tab_ISMIP_ssp126_AIS_5=-0.03*SL2M;
Tab_ISMIP_ssp126_AIS_17=-0.04*SL2M;
Tab_ISMIP_ssp126_AIS_50=-0.05*SL2M;
Tab_ISMIP_ssp126_AIS_83=-0.08*SL2M;
Tab_ISMIP_ssp126_AIS_95=-0.11*SL2M;

Tab_ISMIP_ssp585_AIS_5=0.02*SL2M;
Tab_ISMIP_ssp585_AIS_17=-0.00*SL2M;
Tab_ISMIP_ssp585_AIS_50=-0.04*SL2M;
Tab_ISMIP_ssp585_AIS_83=-0.12*SL2M;
Tab_ISMIP_ssp585_AIS_95=-0.23*SL2M;

plot(offset+[2107.5,2107.5], [-9 2.5] ...
    , '-', 'Color','k', 'LineWidth', width/4)

plot(offset+[2107.5,2107.5]+7, [-9 2.5] ...
    , '-', 'Color','k', 'LineWidth', width/4)

plot(offset+[2105,2105], [Tab_ISMIP_ssp126_AIS_50(end), Tab_ISMIP_ssp126_AIS_50(end)] ...
    , '.', 'Color',color_SSP126, 'MarkerSize', 20)
plot(offset+[2105,2105], [Tab_ISMIP_ssp126_AIS_83(end), Tab_ISMIP_ssp126_AIS_17(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width)
plot(offset+[2105,2105], [Tab_ISMIP_ssp126_AIS_95(end), Tab_ISMIP_ssp126_AIS_5(end)] ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)

plot(offset+[2106,2106], [Tab_ISMIP_ssp585_AIS_50(end), Tab_ISMIP_ssp585_AIS_50(end)] ...
    , '.', 'Color',color_SSP585, 'MarkerSize', 20)
plot(offset+[2106,2106], [Tab_ISMIP_ssp585_AIS_83(end), Tab_ISMIP_ssp585_AIS_17(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width)
plot(offset+[2106,2106], [Tab_ISMIP_ssp585_AIS_95(end), Tab_ISMIP_ssp585_AIS_5(end)] ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)


% Plot LARMIP 2100 ranges (in mm to begin with) in 1e4 Gt
offset = 2;

lst=who('lar*');

ndx=find(larmipssp119(:,1)==2100);

plot(offset+[2109,2109]+7, double([larmipssp126(ndx,4), larmipssp126(ndx,4)])*(-362.5)/1e4 ...
    , '.', 'Color',color_SSP126, 'MarkerSize', 20)
plot(offset+[2109,2109]+7, double([larmipssp126(ndx,5), larmipssp126(ndx,3)])*(-362.5)/1e4  ...
    , '-', 'Color',color_SSP126, 'LineWidth', width)
plot(offset+[2109,2109]+7, double([larmipssp126(ndx,6), larmipssp126(ndx,2)])*(-362.5)/1e4  ...
    , '-', 'Color',color_SSP126, 'LineWidth', width/2)

plot(offset+[2110,2110]+7, double([larmipssp245(ndx,4), larmipssp245(ndx,4)])*(-362.5)/1e4  ...
    , '.', 'Color',color_SSP245, 'MarkerSize', 20)
plot(offset+[2110,2110]+7, double([larmipssp245(ndx,5), larmipssp245(ndx,3)])*(-362.5)/1e4  ...
    , '-', 'Color',color_SSP245, 'LineWidth', width)
plot(offset+[2110,2110]+7, double([larmipssp245(ndx,6), larmipssp245(ndx,2)])*(-362.5)/1e4  ...
    , '-', 'Color',color_SSP245, 'LineWidth', width/2)

plot(offset+[2111,2111]+7, double([larmipssp370(ndx,4), larmipssp370(ndx,4)])*(-362.5)/1e4  ...
    , '.', 'Color',color_SSP370, 'MarkerSize', 20)
plot(offset+[2111,2111]+7, double([larmipssp370(ndx,5), larmipssp370(ndx,3)])*(-362.5)/1e4  ...
    , '-', 'Color',color_SSP370, 'LineWidth', width)
plot(offset+[2111,2111]+7, double([larmipssp370(ndx,6), larmipssp370(ndx,2)])*(-362.5)/1e4  ...
    , '-', 'Color',color_SSP370, 'LineWidth', width/2)

plot(offset+[2112,2112]+7, double([larmipssp585(ndx,4), larmipssp585(ndx,4)])*(-362.5)/1e4  ...
    , '.', 'Color',color_SSP585, 'MarkerSize', 20)
plot(offset+[2112,2112]+7, double([larmipssp585(ndx,5), larmipssp585(ndx,3)])*(-362.5)/1e4  ...
    , '-', 'Color',color_SSP585, 'LineWidth', width)
plot(offset+[2112,2112]+7, double([larmipssp585(ndx,6), larmipssp585(ndx,2)])*(-362.5)/1e4  ...
    , '-', 'Color',color_SSP585, 'LineWidth', width/2)



txt = {'2100 medians,', '66% and 90% ranges'};
text(offset+2100+12,ylims(1)+0.95*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

txt = {'ISMIP6'};
text(offset+2100+4.5,ylims(1)+0.87*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

txt = {'Emulator'};
text(offset+2100+11,ylims(1)+0.87*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')

txt = {'LARMIP-2'};
text(offset+2100+11+6.9,ylims(1)+0.87*ylength,txt,'FontSize',10, ...
    'Color', 'k','HorizontalAlignment','center')


legend([h3 h2 h1 h4], 'Emulator median (SSPs)', ...
    'Emulator{\it 90%} range', ...
    'Emulator{\it 66%} range', ...
    'ISMIP6 models (RCPs/SSPs)', ...
    'Box','off' ...
    ,'Position',[0.4 0.2 0.1 0.1])

%saveas(gcf, 'AISTimeseries', 'png')
print(gcf,'../PNGs/AIS_Timeseries.png','-dpng','-r1000', '-painters');
print(gcf,'../PNGs/AIS_Timeseries.eps','-depsc','-r1000', '-painters');

%% Plot AIS paleo data

figure('Position', [10 10 240 400])
% Plot 
plot([.5,.5], -SL2M*[8.68, 8.68], '.', 'MarkerSize',35, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % Paleo-data ranges taken from Bopp et al., 2018 datasets
hold on
plot([.5,.5], -SL2M*[-1, 17.8], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 5.5Myr-400kyr BP
plot([2,2], -SL2M*[4.058333, 4.058333], '.', 'MarkerSize',35, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([2,2], -SL2M*[-1.7, 7.6], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 400-22kyr BP
plot([3.5,3.5], -SL2M*[-10.67, -10.67], '.', 'MarkerSize',35, 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) 
plot([3.5,3.5], -SL2M*[-14.35, -5.65], '-', 'LineWidth', width/2,'MarkerEdgeColor', color_OBS,'Color', color_OBS) % 22kyr BP- Present - New data from Alan (Slack Nov 2020)
xlim([0 4])
plot([0 5], [0 5]*0, 'k', 'LineWidth', width/10)

yyaxis left
y_limits=[-SL2M*20 SL2M*20];
ylim(y_limits)
ylabel('Mass Change (10^4 Gt)','FontSize',20)
set(gca,'FontSize',20)
yyaxis right
ylim(-fliplr(y_limits)/SL2M)
set ( gca, 'ydir', 'reverse','YColor','k')
set(gca,'Ytick',[-20 -10 0 10 20],'Yticklabel',{'-20','-10','0','10','20'})
ylabel('Equivalent Sea Level Contribution (m)','FontSize',20,'Color','k')
yyaxis left
set(gca,'Xtick',[0.5 2 3.5],'Xticklabel',[])
set(gca,'FontSize',15,'Box', 'on')

txt = {'Observed', 'mean & p-box'};
text(2.0,200,txt,'FontSize',14, ...
    'Color', color_OBS, 'FontWeight', 'bold','HorizontalAlignment','center')
text(0.5,-800,{'MPWP'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(2,-800,{'LIG'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
text(3.5,-800,{'LGM'},'FontSize',14, ...
    'HorizontalAlignment','center', 'Interpreter','latex')
txt = 'Paleo';
text(0.2,640,txt,'FontSize',18, ...
    'Color', 'k', 'FontWeight', 'bold')

print(gcf,'../PNGs/AISPaleoPbox.png','-dpng','-r1000', '-painters');

