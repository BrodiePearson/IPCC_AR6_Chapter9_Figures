Land ice emulator projections forced by two layer model:

Annual files from 2016-2100: summary_FAIR_SSPXXX.csv 

Header: ice_source,region,year,q0.5,q0.05,q0.95,q0.17,q0.83,q0.25,q0.75,sample_mean,sample_sd,sample_min, sample_max

ice_source = "GrIS" for Greenland (done as one region, "ALL").
ice_source = "AIS" for Antarctica (for sum use region = "ALL"; for regions: WAIS, EAIS and PEN)
ice_source = "Glaciers" for Glaciers (for sum use region = "ALL"; for regions: region_1:19).
ice_source = "LAND_ICE" for all land ice.

where q are quantiles calculated from the emulator (Greenland) or Monte Carlo sample (Antarctic, glacier and land ice totals), 
and the sample mean, s.d. min and max are from the Monte Carlo samples and sums of these.

Emulator code: https://github.com/tamsinedwards/emulandice
Projections generated 13th-14th November 2020.

========================================================================
Two layer model forcing used for these projections:

2015-2100 GSAT anomalies: date_CLIMATE_FORCING_IPCC.csv 

Header: ensemble,GCM,scenario,y2015,y2016,y2017,...,y2100

Use ensemble = "FAIR" rows (N = 2000 for each of 5 SSPs).
GCM = FAIR_1:2000
scenario = SSP119, SSP126, SSP245, SSP370, SSP585

No baseline correction applied, so temperatures are with respect to 1750.

========================================================================
Ice sheet and glacier model projections used to calibrate emulator:

2015-2100 ISMIP6 and GlacierMIP sea level contributions: date_SLE_SIMULATIONS_SI.csv 

Header: ice_source,region,group,model,resolution,exp_id,GCM,scenario,melt,collapse,y2015,y2016,y2017,...,y2100,publication

ice_source and region are as above, but there is no "ALL" for Antarctica, Glaciers or LAND_ICE.
WAIS, EAIS and PEN are in same order so can add these by row for Antarctic total.

GCM and scenario pair correspond to a unique CMIP5 or CMIP6 row in climate forcing file above.

Baseline applied - all contributions are relative to 2015.

Note last column of SLE csv gives publication name - exclude "New" if you want to exclude unpublished simulations not in the main ISMIP6 and GlacierMIP papers. These were used for the emulator but are not yet published (as of 14th Nov 2020).



