function  [rate_of_change_map lat lon] = IPCC_CMIP6_ChangeMap(experiment, var_name, data_path, ...
    early_average_start_year, late_average_end_year, averaging_window_width)
%IPCC_CMIP6_Map Calculate global maps of IPCC variables for ref. period
%
%   map = IPCC_CMIP6_MapChange(experiments, var_name, data_path, ...
%                               start_indices, end_indices, ave_window) 
%
%    returns global maps of change in a variable for between two
%    times with specified averaging over multiple years at the begining 
%    and end of the time period over which change is diagnosed
%
% Input variables:
%           experiment - A cell with the name of the experiment
%                   e.g. experiment = {'ssp126'}
%           data_path - path to data
%           var_name - name of variable
%           start_indices - time index for start of intial period [1xN array]
%           end_indices - time index for end of final period [1xN array]
%                       e.g. start_indices = [i_1, i_2,..., i_N];
%           ave_window - length of time (in years) of averaging
%                        window at each end of change window. Note, this 
%                        average is across the dates following the initial 
%                        period, and prior to the final period
%                       
%
% Output variables:
%           map - Global maps as 1 x N structure. Each
%           element contains a timeseries for each model available for that
%           experiment
%
% Function written by Brodie Pearson

% % Define start and end years for each type of experiment
% if contains(char(experiment),'historical')
%     experiment_start_year = 1850;
% elseif contains(char(experiment),'ssp')
%     experiment_start_year = 2015;
% elseif contains(char(experiment),'hist-1950')
%     experiment_start_year = 1950;
% elseif contains(char(experiment),'highres-future')
%     experiment_start_year = 2015;
% end

if early_average_start_year>2015
    early_period_start_index = (early_average_start_year - 2015)*12+1;
    experiment_start_year = 2015;
elseif early_average_start_year<2015 && contains(char(experiment),'ssp')
    % Else use historical high-res simulation which starts in 1850
    early_period_start_index = (early_average_start_year - 1850)*12+1;
    experiment_start_year = 2015;
elseif early_average_start_year<2015 && contains(char(experiment),'historical')
    % Else use historical high-res simulation which starts in 1850
    early_period_start_index = (early_average_start_year - 1850)*12+1;
    experiment_start_year = 1850;
elseif early_average_start_year<2015 && contains(char(experiment),'highres-future')
    % Else use historical high-res simulation which starts in 1950
    early_period_start_index = (early_average_start_year - 1950)*12+1;
    experiment_start_year = 2015;
elseif contains(char(experiment),'hist-1950')
    % Else use historical high-res simulation which starts in 1950
    early_period_start_index = (early_average_start_year - 1950)*12+1;
    experiment_start_year = 1950;
end

early_period_end_index = early_period_start_index + 12*averaging_window_width-1;
late_period_end_index = (late_average_end_year - experiment_start_year+1)*12;
late_period_start_index = late_period_end_index - 12*averaging_window_width+1;

model_names = IPCC_Which_Models(data_path,{experiment},'CMIP6_','_');

if contains(experiment, 'ssp') % Find overlapping historical/ssp models
    model_names_hist = IPCC_Which_Models(data_path,{'historical'},'CMIP6_','_');
    model_names = intersect(model_names,model_names_hist,'stable');
elseif contains(experiment, 'highres-future')
    model_names_hist = IPCC_Which_Models(data_path,{'hist-1950'},'CMIP6_','_');
    model_names = intersect(model_names,model_names_hist,'stable');
end
    

if early_average_start_year<2015
    if contains(char(experiment),'ssp') || contains(char(experiment),'historical')
        [timeseries, lat, lon] = IPCC_CMIP6_Load({'historical'}, ...
            var_name, model_names, data_path);
    elseif contains(char(experiment),'highres-future') || ...
            contains(char(experiment),'hist-1950')
        [timeseries, lat, lon] = IPCC_CMIP6_Load({'hist-1950'}, ...
            var_name, model_names, data_path);
    end
    early_map = nanmean(timeseries(:,:, ...
        early_period_start_index:early_period_end_index,:,1),3);
end
[timeseries, lat, lon] = IPCC_CMIP6_Load({experiment}, ...
    var_name, model_names, data_path);
if early_average_start_year>2014 % Get early period from experiment
    early_map = nanmean(timeseries(:,:, ...
        early_period_start_index:early_period_end_index,:,1),3);
end
late_map = nanmean(timeseries(:,:, ...
    late_period_start_index:late_period_end_index,:,1),3);

change_map = late_map - early_map;
% Calulate the decadal rate of change
% noting that the early end year = early start year + averaging window - 1
rate_of_change_map = 10*change_map/(late_average_end_year - ...
    early_average_start_year - averaging_window_width + 1);