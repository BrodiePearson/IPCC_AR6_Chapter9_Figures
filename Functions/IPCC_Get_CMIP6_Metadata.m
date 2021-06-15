function  IPCC_Write_CMIP6_Metadata(data_path, experiment, ...
    output_file, sub_panel, historical_grab)
% IPCC_Get_CMIP6_Metadata - Finds IPCC-required metadata for CMIP6 ensembles 
% designed to work on ESMValTool-processed datasets
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
%           output_file - name of file to be output
%           sub_panel  (optional) - subpanel letter if neccessary, i.e. 'b'
%           historical_grab (optional) - 'true' if the historical
%           experiments for the same set of models is required
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

% Remove any files which are not CMIP6 datasets
filenames(~contains(filenames, 'CMIP6'))=[];

if exist('sub_panel')~=1
    sub_panel = '';
end

for ii=1:size(filenames,2)
    if contains(char(experiment), 'extended')
        if contains(char(experiment), 'ssp585')
            file_name = char(data_path)+"/ssp585/extended/"+char(filenames(1,ii));
        elseif contains(char(experiment), 'ssp126')
            file_name = char(data_path)+"/ssp126/extended/"+char(filenames(1,ii));
        end
    else
        file_name = char(data_path)+""+char(experiment)+"/"+char(filenames(1,ii));
    end
    mip_era{ii} = 'CMIP6';
    subpanel{ii}=sub_panel;
    try
        source_id{ii}=ncreadatt(file_name,'/','source_id');
    catch
        warning('No source_id values found'+file_name)
        source_id{ii} = 'Empty';
    end
    try
        activity_id{ii}=ncreadatt(file_name,'/','activity_id');
    catch
        warning('No activity_id values found'+file_name)
        activity_id{ii} = 'Empty';
    end
    try
        institution_id{ii}=ncreadatt(file_name,'/','institution_id');
    catch
        warning('No institution_id values found'+file_name)
        institution_id{ii} = 'Empty';
    end
    try
        experiment_id{ii}=ncreadatt(file_name,'/','experiment_id');
    catch
        warning('No experiment_id values found'+file_name)
        experiment_id{ii} = 'Empty';
    end
    try
        experiment_id{ii}=ncreadatt(file_name,'/','experiment_id');
    catch
        warning('No experiment_id values found'+file_name)
        experiment_id{ii} = 'Empty';
    end
    try
        sub_experiment_id{ii}=ncreadatt(file_name,'/','sub_experiment_id');
    catch
        warning('No sub_experiment_id values found'+file_name)
        sub_experiment_id{ii} = 'Empty';
    end
    try
        variant_label{ii}=ncreadatt(file_name,'/','variant_label');
    catch
        warning('No variant_label values found'+file_name)
        variant_label{ii} = 'Empty';
    end
    try
        table_id{ii}=ncreadatt(file_name,'/','table_id');
    catch
        warning('No table_id values found'+file_name)
        table_id{ii} = 'Empty';
    end
    try
        variable_id{ii}=ncreadatt(file_name,'/','variable_id');
    catch
        warning('No variable_id values found'+file_name)
        variable_id{ii} = 'Empty';
    end
    try
        grid_label{ii}=ncreadatt(file_name,'/','grid_label');
    catch
        warning('No grid_label values found'+file_name)
        grid_label{ii} = 'Empty';
    end
    try
        version{ii}=ncreadatt(file_name,'/','version');
    catch
        warning('No version values found'+file_name)
        version{ii} = 'Empty';
    end
    data_reference{ii} = string(mip_era{ii})+"."+ ...
        string(activity_id{ii})+"."+string(institution_id{ii})+"."+ ...
        string(source_id{ii})+"."+string(experiment_id{ii});
end

if historical_grab
    if contains(char(experiment),'highres-future') % get HighResMIP historical
        data_path = strrep(data_path,'highres-future','hist-1950');
    elseif contains(char(experiment),'ssp585')
        data_path = strrep(data_path,'ssp585','historical');
    elseif contains(char(experiment),'ssp126')
        data_path = strrep(data_path,'ssp126','historical');
    elseif contains(char(experiment),'ssp245')
        data_path = strrep(data_path,'ssp245','historical');
    elseif contains(char(experiment),'ssp370')
        data_path = strrep(data_path,'ssp370','historical');
    end
    %        data_path = strrep(data_path,'ssp585','historical');
    for ii=1:size(filenames,2)
        filenames(1,ii) = strrep(filenames(1,ii),'2081','1995');
        filenames(1,ii) = strrep(filenames(1,ii),'2100','2014');
        filenames(1,ii) = strrep(filenames(1,ii),'2099','2014');
        filenames(1,ii) = strrep(filenames(1,ii),'2050','2014');
        if contains(char(experiment),'highres-future') % get HighResMIP historical
            filenames(1,ii) = strrep(filenames(1,ii),'2015','1950');
        else
            filenames(1,ii) = strrep(filenames(1,ii),'2015','1850');
        end
        %filenames(1,ii) = strrep(filenames(1,ii),'ssp585','historical');
        if contains(char(experiment),'highres-future') % get HighResMIP historical
            filenames(1,ii) = strrep(filenames(1,ii),'highres-future','hist-1950');
        elseif contains(char(experiment),'ssp585')
            filenames(1,ii) = strrep(filenames(1,ii),'ssp585','historical');
        elseif contains(char(experiment),'ssp126')
            filenames(1,ii) = strrep(filenames(1,ii),'ssp126','historical');
        elseif contains(char(experiment),'ssp245')
            filenames(1,ii) = strrep(filenames(1,ii),'ssp245','historical');
        elseif contains(char(experiment),'ssp370')
            filenames(1,ii) = strrep(filenames(1,ii),'ssp370','historical');
        end
        if contains(char(experiment),'highres-future') % get HighResMIP historical
            file_name = char(data_path)+"hist-1950/"+char(filenames(1,ii));
        else
            file_name = char(data_path)+"historical/"+char(filenames(1,ii));
        end
        mip_era{ii+size(filenames,2)} = 'CMIP6';
        subpanel{ii+size(filenames,2)}=sub_panel;
        try
            source_id{ii+size(filenames,2)}=ncreadatt(file_name,'/','source_id');
        catch
            warning('No source_id values found'+file_name)
            source_id{ii+size(filenames,2)} = 'Empty';
        end
        try
            activity_id{ii+size(filenames,2)}=ncreadatt(file_name,'/','activity_id');
        catch
            warning('No activity_id values found'+file_name)
            activity_id{ii+size(filenames,2)} = 'Empty';
        end
        try
            institution_id{ii+size(filenames,2)}=ncreadatt(file_name,'/','institution_id');
        catch
            warning('No institution_id values found'+file_name)
            institution_id{ii+size(filenames,2)} = 'Empty';
        end
        try
            experiment_id{ii+size(filenames,2)}=ncreadatt(file_name,'/','experiment_id');
        catch
            warning('No experiment_id values found'+file_name)
            experiment_id{ii+size(filenames,2)} = 'Empty';
        end
        try
            experiment_id{ii+size(filenames,2)}=ncreadatt(file_name,'/','experiment_id');
        catch
            warning('No experiment_id values found'+file_name)
            experiment_id{ii+size(filenames,2)} = 'Empty';
        end
        try
            sub_experiment_id{ii+size(filenames,2)}=ncreadatt(file_name,'/','sub_experiment_id');
        catch
            warning('No sub_experiment_id values found'+file_name)
            sub_experiment_id{ii+size(filenames,2)} = 'Empty';
        end
        try
            variant_label{ii+size(filenames,2)}=ncreadatt(file_name,'/','variant_label');
        catch
            warning('No variant_label values found'+file_name)
            variant_label{ii+size(filenames,2)} = 'Empty';
        end
        try
            table_id{ii+size(filenames,2)}=ncreadatt(file_name,'/','table_id');
        catch
            warning('No table_id values found'+file_name)
            table_id{ii+size(filenames,2)} = 'Empty';
        end
        try
            variable_id{ii+size(filenames,2)}=ncreadatt(file_name,'/','variable_id');
        catch
            warning('No variable_id values found'+file_name)
            variable_id{ii+size(filenames,2)} = 'Empty';
        end
        try
            grid_label{ii+size(filenames,2)}=ncreadatt(file_name,'/','grid_label');
        catch
            warning('No grid_label values found'+file_name)
            grid_label{ii+size(filenames,2)} = 'Empty';
        end
        try
            version{ii+size(filenames,2)}=ncreadatt(file_name,'/','version');
        catch
            warning('No version values found'+file_name)
            version{ii+size(filenames,2)} = 'Empty';
        end
        data_reference{ii+size(filenames,2)} = string(mip_era{ii+size(filenames,2)})+"."+ ...
            string(activity_id{ii+size(filenames,2)})+"."+string(institution_id{ii+size(filenames,2)})+"."+ ...
            string(source_id{ii+size(filenames,2)})+"."+string(experiment_id{ii+size(filenames,2)});
    end
    
end


tmp = [data_reference; sub_experiment_id; variant_label; table_id; ...
    variable_id; grid_label; version; subpanel]';

writecell(tmp,output_file)



