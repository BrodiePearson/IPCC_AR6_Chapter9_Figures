function  model_names = IPCC_Which_Models(data_path, experiment, ...
    prefix, suffix)
%IPCC_Which_Models Find available CMIP6 models for an experiment
%
%   model_names = IPCC_Which_Models(data_path, experiment, prefix, suffix)
%
%    returns the names of models with data available for a given
%    experiment. Function looks in specified data path using specified file
%    naming conventions
%
% Input variables:
%           data_path - in form 'data_path_name'
%           experiment - in form {'historical'} or {'ssp585'}
%           prefix - irrelevant start of file names e.g. 'CMIP6_'
%           suffix - symbol after which ignore rest of name. Typically '_'
%
% Output variables:
%           model_names - An array of model names that are available for a
%                         given experiment
%
% Function written by Brodie Pearson

datadir=dir(data_path+"/"+char(experiment)+"/");

% If using an extended model, experiment is not the same as file name
if contains(char(experiment), 'extended')
    if contains(char(experiment), 'ssp585')
        datadir = dir(data_path+"/ssp585/extended/");
    elseif contains(char(experiment), 'ssp126')
        datadir = dir(data_path+"/ssp126/extended/");
    end
elseif data_path
end


filenames = {datadir.name}; % Load filenames in path
%filenames(~contains(filenames, 'CMIP'))=[];
filenames(contains(filenames, 'meta'))=[];
for ii=1:size(filenames,2)
   model_names(ii)={strtok(erase(filenames{1,ii},prefix),suffix)};
end

% Remove non-cmip data files
model_names(strcmp(model_names,'.'))=[];
model_names(strcmp(model_names,'..'))=[];
model_names(strcmp(model_names,'.DS'))=[];
model_names(strcmp(model_names,'low-res-partners'))=[];
model_names(strcmp(model_names,'high-res-partners'))=[];
model_names(strcmp(model_names,'No'))=[];
model_names(strcmp(model_names,'No_historical'))=[];
model_names(strcmp(model_names,'No_tauvo_data'))=[];


