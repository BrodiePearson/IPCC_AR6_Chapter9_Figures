function  [global_mean] = IPCC_Global_Mean(variable, areas, smooth_length)
%IPCC_Global_Mean Calculate are-weighted global mean
%
%    [global_mean] = IPCC_Global_Mean(variable, areas, smooth_length)
%
%    returns global mean of a variable, weighted by the area of grid cells
%
% Input variables:
%           variable - field in form KxLxMxN where K is longitude, L is
%                       latitude, M is time axis and N is the model axis
%           area -  KxL array of grid area for mean calculation
%           smooth_time - Time period (in years) of smoothing via a
%                           symmetric running mean
%
% Output variables:
%           global_mean - global mean of size M x N where M is the time
%                       axis (same length as input timeseries but with a 
%                       running mean applied) and N is the different models
%
% Function written by Brodie Pearson

global_mean=NaN(size(variable,3),size(variable,4));

for i=1:size(variable,3)
    for j=1:size(variable,4)
       temp2 = variable(:,:,i,j);
       temp = temp2(:).*areas(:);
       %oceanarea = nansum(temp./temp2(:));
       oceanarea = sum(temp./temp2(:), 'omitnan');
       %global_mean_unsmoothed(i,j)=nansum(temp)./oceanarea;
       global_mean_unsmoothed(i,j)=sum(temp, 'omitnan')./oceanarea;
    end
end

global_mean = movmean(global_mean_unsmoothed,smooth_length*12);

end

