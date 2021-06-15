function  line_color = IPCC_Get_SSPColors(exp)
%IPCC_Get_LineColors Get IPCC style colorbars for experiments
%
%    line_color = IPCC_Get_SSPColors(exp)
%
%    returns line colors from IPCC style guide (Dec 2018). Some experiments
%    are included even if they do not have an official IPCC style guide
%    color (e.g. HighResMIP, OMIP)
%
% Input variables:
%           exp - name of experiment available options include: 
%                 'ssp126', 'ssp245', 'ssp370', 'ssp585', 'rcp85', 'rcp26', 
%                 'HighResMIP','CMIP','Observations'
%
% Output variables:
%           line_color - Line color for plotting
%
% Function written by Brodie Pearson

if contains(exp, "ssp585")
    line_color = [132 11 34]/255;
elseif contains(exp, "ssp370")
    line_color = [242 17 17]/255;
elseif contains(exp, "ssp245")
    line_color = [234 221 61]/255;
elseif contains(exp, "ssp126")
    line_color = [29 51 84]/255;
elseif contains(exp, "ssp119")
    line_color = [30 150 132]/255;
elseif contains(exp, "rcp85")
    line_color = [153 0 2]/255;
elseif contains(exp, "rcp60")
    line_color = [196 121 0]/255;
elseif contains(exp, "rcp45")
    line_color = [112 160 205]/255;
elseif contains(exp, "rcp26")
    line_color = [0 52 102]/255;
elseif contains(exp, "HighResMIP")
    line_color = [0 79 0]/255;
elseif contains(exp, "CMIP")
    line_color = [0 0 0]/255;
elseif contains(exp, "Observations")
    line_color = [196 121 0]/255;    
end

end

