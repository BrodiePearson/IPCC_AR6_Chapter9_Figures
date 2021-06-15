function  map = IPCC_CMIP6_Map( ...
    experiments, var_name, data_path, start_year, end_year)
%IPCC_CMIP6_Map Calculate global maps of IPCC variables for ref. period
%
%   map = IPCC_CMIP6_Map( ...
%            experiments, var_name, data_path, start_indices, end_indices) 
%
%    returns global maps of a variable for a specific time period (mean) for
%    one or more experiments, and all models available for that experiment
%
% Input variables:
%           experiments - 1 x N cell with N the number of experiments
%                   e.g. experiments = {'historical','ssp126', ...}
%                   first experiment should be the historical and later
%                   experiments future. 
%           data_path - path to data
%           var_name - name of variable
%           start_indices - time index for start of mean [1xN array]
%           end_indices - time index for reference period end [1xN array]
%                       e.g. start_indices = [i_1, i_2,..., i_N];
%                       
%
% Output variables:
%           map - Anomaly of global mean as 1 x N structure. Each
%           element contains a timeseries for each model available for that
%           experiment
%
% Function written by Brodie Pearson

no_exps = size(experiments,2);

for ii=1:no_exps
    models{ii} = IPCC_Which_Models(data_path,experiments(ii),'CMIP6_','_');
    % Define start and end years for average (SSPs start in 2015)
    if start_year>=2015
        start_indices{ii} = (start_year - 2015)*12+1;
        end_indices{ii} = (end_year - 2015)*12+12;
    elseif start_year<2015 && contains(char(experiments(ii)),'historical')
        % Else use historical historical simulation which starts in 1850
        start_indices{ii} = (start_year - 1850)*12+1;
        end_indices{ii} = (end_year - 1850)*12+12;
    elseif contains(char(experiments(ii)),'hist-1950')
        % Else use historical high-res simulation which starts in 1950
        start_indices{ii} = (start_year - 1950)*12+1;
        end_indices{ii} = (end_year - 1950)*12+12;
    end
end

for kk=1:size(models,2)
    for jj=1:size(models{kk},2)
        % Load historical simulation
        [timeseries, lat, lon] = IPCC_CMIP6_Load(experiments(kk), ...
            var_name, models{kk}(1,jj), data_path);
        
        map{kk}(:,:,jj) =  ...
            nanmean(timeseries(:,:,start_indices{kk}:end_indices{kk}),3);
    end
end