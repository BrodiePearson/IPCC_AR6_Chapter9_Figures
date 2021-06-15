function  levs = IPCC_CMIP6_Load_Levels(experiment, variable, ...
    model_names,datapath, start_year, end_year)
%IPCC_CMIP6_Load Function to load IPCC CMIP6 datasets
%
%   levs = IPCC_CMIP6_Load_Levels(experiment, variable, ...
%                                        model_names,datapath, start_year, end_year)
%
%    returns the requested dataset containing the variable from the
%    specific model run for a given experiment, along with the latitude and
%    longitude values for that grid
%
% Input variables:
%           experiment - in form {'historical'} or {'ssp585'}
%           variable - in form {'tos'}
%           model_names -  in form {'CAMS-CSM1-0', 'CanESM5', ...} 
%           start_year - OPTIONAL: start year on file (this is useful if
%              analyzing a temporal average over a period, which ESMValTool
%              names using the time period of the average
%           end_year - as with start year, but end of averaging period
%
% Output variables:
%           levs - the vertical levels in a specific model
%           longitude - array of grid longitudes
%           latitude - array of grid latitudes
%
% Function written by Brodie Pearson

for i=1:length(model_names)
    if contains(char(model_names(i)), 'CNRM-CM6-1') || ...
            contains(char(model_names(i)), 'MIROC-ES2L') || ...
           contains(char(model_names(i)), 'UKESM1-0-LL') 
        ens_name(i) = {'r1i1p1f2'};
    elseif contains(char(model_names(i)), 'HadGEM3-GC31-LL')
       ens_name(i) = {'r1i1p1f3'};
    elseif contains(char(model_names(i)), 'HadGEM3-GC31-LL') || ...
           contains(char(model_names(i)), 'HadGEM3-GC31-MM') 
       ens_name(i) = {'r1i1p1f3'};
    elseif contains(char(model_names(i)), 'HadGEM3-GC31-HM')
        ens_name(i) = {'r1i1p1f1'};
    elseif contains(char(model_names(i)), 'GISS-E2-1-G')
        ens_name(i) = {'r1i1p1f1'};
    elseif contains(char(model_names(i)), 'EC-Earth3P-HR')
        ens_name(i) = {'r1i1p2f1'};
    elseif contains(char(model_names(i)), 'HadGEM3-GC31-HM')
        ens_name(i) = {'r1i3p1f1'};
    elseif contains(char(model_names(i)), 'CNRM-ESM2-1')
        if contains('wfo', variable) || contains('hfds', variable)
            ens_name(i) = {'r1i1p1f2'};
        else
            ens_name(i) = {'r2i1p1f2'};
        end
    else
        ens_name(i) = {'r1i1p1f1'};
    end
end

if ~exist('end_year')
    if contains(char(experiment), 'historical')
        start_year = {'1850'};
        end_year = {'2014'};
    elseif contains(char(experiment), 'ssp')
        if contains(char(experiment), 'extended')
            start_year = {'2100'};
            end_year = {'2300'};
        else
            start_year = {'2015'};
            end_year = {'2100'};
        end
        %    if contains(char(model_names(1)), 'CAMS-CSM1-0')
        %        end_year={'2099'};
        %    end
    elseif contains(char(experiment), 'hist-1950')
        start_year = {'1950'};
        end_year = {'2014'};
    elseif contains(char(experiment), 'highres-future')
        start_year = {'2015'};
        end_year = {'2050'};
        % elseif contains(char(experiment), 'extended')
        %     start_year = {'2100'};
        %     end_year = {'2300'};
    end
end

%% Load CMIP and ScenarioMIP gridded data

if contains(char(model_names(i)), 'CAMS-CSM1-0') && ...
        contains(char(experiment), 'ssp')
    data_dir = [datapath+""+char(experiment)+"/CMIP6_"+ ...
        char(model_names(1))+"_Omon_"+char(experiment)+'_'+...
        char(ens_name(1))+"_"+char(variable)+"_"+char(start_year)+"-2099.nc"];
else
    data_dir = [datapath+""+char(experiment)+"/CMIP6_"+ ...
        char(model_names(1))+"_Omon_"+char(experiment)+'_'+...
        char(ens_name(1))+"_"+char(variable)+"_"+char(start_year)+"-"+...
        char(end_year(1))+".nc"];
end

if contains(char(experiment), 'extended_ssp585')
    data_dir = [datapath+"ssp585/extended/CMIP6_"+ ...
        char(model_names(1))+"_Omon_ssp585_"+...
        char(ens_name(1))+"_"+char(variable)+"_"+char(start_year)+"-"+...
        char(end_year(1))+".nc"];
elseif contains(char(experiment), 'extended_ssp126')
    data_dir = [datapath+"ssp126/extended/CMIP6_"+ ...
        char(model_names(1))+"_Omon_ssp126_"+...
        char(ens_name(1))+"_"+char(variable)+"_"+char(start_year)+"-"+...
        char(end_year(1))+".nc"];
end

var_shape = size(ncread(data_dir, char(variable)));

if contains(char(model_names(1)), 'CAMS-CSM1-0') && ...
            contains(char(experiment), 'ssp') && ...
            ~contains('thetao', variable)
    var_shape(3)=var_shape(3)+12;
end

% Extract lat and lon values
latitude = ncread(data_dir,'lat');
longitude = ncread(data_dir,'lon');

% Create a multi-model array with additional dimensions to accomodate
% different models and experiment groups
if size(var_shape,2)<3
    vars = nan(var_shape(1), var_shape(2), ...
        length(model_names), length(experiment));
else
    vars = nan(var_shape(3), length(model_names));
end

% Begin loop over all models in that experiment group
for i=1:length(model_names)
    if contains(char(model_names(i)), 'CAMS-CSM1-0') && ...
            contains(char(experiment), 'ssp')
        end_year={'2099'};
        data_dir = [char(datapath) '' char(experiment) '/CMIP6_'  ...
            char(model_names(i)) '_Omon_' char(experiment) '_' ...
            char(ens_name(i)) '_' char(variable) '_' ...
            char(start_year) '-' ...
            char(end_year) '.nc'];
        temp = ncread(data_dir,char(variable));
        temp2 = NaN(size(temp,1),size(temp,2), size(temp,3)+12);
        temp2(:,:,1:end-12)=temp;
        levs{i} = ncread(data_dir,'lev');
    else
        if contains(char(experiment), 'ssp')
            if contains(char(experiment), 'extended')
                end_year={'2300'};
                if contains(char(experiment), 'ssp585')
                    data_dir = [char(datapath) 'ssp585/extended/CMIP6_'  ...
                        char(model_names(i)) '_Omon_ssp585_' ...
                        char(ens_name(i)) '_' char(variable) '_' char(start_year) '-' ...
                        char(end_year) '.nc'];
                elseif contains(char(experiment), 'ssp126')
                    data_dir = [char(datapath) 'ssp126/extended/CMIP6_'  ...
                        char(model_names(i)) '_Omon_ssp126_' ...
                        char(ens_name(i)) '_' char(variable) '_' char(start_year) '-' ...
                        char(end_year) '.nc'];
                end
            else
                end_year={'2100'};
                data_dir = [char(datapath) '' char(experiment) '/CMIP6_'  ...
                    char(model_names(i)) '_Omon_' char(experiment) '_' ...
                    char(ens_name(i)) '_' char(variable) '_' char(start_year) '-' ...
                    char(end_year) '.nc'];
            end
        end
        % Define the directory of data for this model
        data_dir = [char(datapath) '' char(experiment) '/CMIP6_'  ...
            char(model_names(i)) '_Omon_' char(experiment) '_' ...
            char(ens_name(i)) '_' char(variable) '_' char(start_year) '-' ...
            char(end_year) '.nc'];
    end
    data_dir
    if contains(data_dir,'IPSL-CM6A-LR')
        levs{i} = ncread(data_dir,'olevel');
    else
        levs{i} = ncread(data_dir,'lev');
    end
end

end

