function  [Atlantic, Pacific, Indian] =  IPCC_Basin_Mask(LAT, LON);
%IPCC_CMIP6_Map Calculate global maps of IPCC variables for ref. period
%
%   [Atlantic, Pacific, Indian] =  IPCC_Basin_Mask(LAT, LON); 
%
%    returns masks for different ocean basins based on NOAA/WOCE bounds
%
% Input variables:
%           LAT - M x N Latitude grid
%           LON - M x N Longitude grid
%                       
%
% Output variables:
%           Atlantic - M x N mask [1's] of Atlantic basin (elsewhere is NaN) 
%           Pacific - M x N mask [1's] of Pacific basin (elsewhere is NaN) 
%           Indian - M x N mask [1's] of Indian basin (elsewhere is NaN) 
%
% Function written by Brodie Pearson

LON(LON>180)=LON(LON>180) - 360;

%% Get Atlantic Ocean mask
Atlantic = NaN(size(LAT));
Atlantic(LAT>=-80 & LAT<=9 & LON<=20 & LON>=-70) = 1;
Atlantic(LAT>=9 & LAT<=14 & LON<=20 & LON>=-84) = 1;
Atlantic(LAT>=14 & LAT<=18 & LON<=20 & LON>=-90) = 1;
Atlantic(LAT>=18 & LAT<=31 & LON<=20 & LON>=-100) = 1;
Atlantic(LAT>=31 & LAT<=66 & LON<=100 & LON>=-100) = 1;
Atlantic(LAT>=66 & LAT<=90) = 1;

%% Get Pacific Ocean mask
Pacific = NaN(size(LAT));
Pacific(LAT>=-80 & LAT<=0 & LON<=-70) = 1;
Pacific(LAT>=-80 & LAT<=0 & LON>=145) = 1;
Pacific(LAT>=0 & LAT<=9 & LON<=-70) = 1;
Pacific(LAT>=0 & LAT<=9 & LON>=100) = 1;
Pacific(LAT>=9 & LAT<=14 & LON<=-84) = 1;
Pacific(LAT>=9 & LAT<=14 & LON>=100) = 1;
Pacific(LAT>=14 & LAT<=18 & LON<=-90) = 1;
Pacific(LAT>=14 & LAT<=18 & LON>=100) = 1;
Pacific(LAT>=18 & LAT<=66 & LON<=-100) = 1;
Pacific(LAT>=18 & LAT<=66 & LON>=100) = 1;

%% Get Indian Ocean mask
Indian = NaN(size(LAT));
Indian(LAT>=-80 & LAT<=0 & LON<=145 & LON>=20) = 1;
Indian(LAT>=0 & LAT<=31 & LON<=100 & LON>=20) = 1;

end