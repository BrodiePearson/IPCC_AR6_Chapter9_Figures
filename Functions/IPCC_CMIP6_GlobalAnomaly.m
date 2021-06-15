function  [GM_anom, models] = IPCC_CMIP6_GlobalAnomaly(experiments, var_name, ...
    data_path, ref_start_index, ref_end_index, smooth_length)
%IPCC_CMIP6_GlobalAnomaly Calculate Global Anomaly for CMIP6 data
%
%   GM_anom = IPCC_CMIP6_GlobalAnomaly(experiments, var_name, ...
%               data_path, ref_start_index, ref_end_index, smooth_length) 
%
%    returns the global mean anomalies of historical simulations
%    from each model (with data gridded onto 1 degree grid)
%    relative to a reference period, to find which SSPs exist for each model,
%    and to calculate the anomalies of these future simulations relative to
%    their respective model's reference period
%
% Input variables:
%           experiments - 1 x N cell with N the number of experiments
%                   e.g. experiments = {'historical','ssp126', ...}
%                   first experiment should be the historical experiment
%                   for diagnosing anomaly reference period
%           data_path - path to data [e.g. data_path = '/path/']
%           var_name - name of variable [e.g. var_name = {'tos'}]
%           ref_start_index - time index for reference period start [e.g.
%                               ref_start_index=1572]
%           ref_end_index - time index for reference period end
%
% Output variables:
%           GM_anom - Anomaly of global mean as 1 x N structure. Each
%           element contains a timeseries for each model available for that
%           experiment
%
% Function written by Brodie Pearson

no_exps = size(experiments,2);

for ii=1:no_exps
    models{ii} = IPCC_Which_Models(data_path,experiments(ii),'CMIP6_','_');
end

% Check that experiments(1) is a historical experiment for anomaly
if ~contains(experiments(1), 'hist')
    warning('Warning. \nFirst experiment is not historical, it is %s.' ...
        ,experiments(1))
end

for jj=1:size(models{1},2)
    % Load historical simulation
    [timeseries, lat, lon] = IPCC_CMIP6_Load(experiments(1), ...
        var_name, models{1}(1,jj), data_path);
    % If first iteration calculate grid cell areas for global mean weights
    if jj==1
        areas=NaN(size(lon.*lat'));
        for i = 1:size(areas,1)
            for j=1:size(areas,2)
                areas(i,j) = areaquad(lat(j)-0.5, lon(i)-0.5, ...
                    lat(j)+0.5, lon(i)+0.5);
            end
        end
    end
    % Find Global mean SST
    GM{1}(:,jj) = IPCC_Global_Mean(timeseries,areas,smooth_length);
    % Find anomaly of global mean relative to the reference period
    GM_anom{1}(:,jj) = GM{1}(:,jj) - ...
        mean(GM{1}(ref_start_index:ref_end_index,jj));
    
    for kk=2:size(models,2)
        % Find out if analogous model exists for each ssp (and its index)
        ind = find(strcmp(models{kk},models{1}(1,jj)));
        if(~isempty(ind))
            % Extract timeseries of global maps from experiment
            [timeseries, lat, lon] = IPCC_CMIP6_Load(experiments(kk), ...
                var_name, models{kk}(1,ind), data_path);
            % De-anomalize the data
            GM{kk}(:,ind) = IPCC_Global_Mean(timeseries,areas,smooth_length);
            GM_anom{kk}(:,ind) = GM{kk}(:,ind) - ...
                mean(GM{1}(ref_start_index:ref_end_index,jj));
        end
    end
end