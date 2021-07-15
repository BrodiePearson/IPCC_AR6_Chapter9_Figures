============================================================
LAND ICE SIMULATIONS: ISMIP6 and GlacierMIP

SLE_SIMULATIONS. CSV
============================================================

Sources:
ISMIP6 Greenland: Heiko Goelzer's 'v1' tidied dataset
ISMIP6 Antarctica: Helene Seroussi's ISMIP6_VAF.zip tidied dataset, emailed to me 2/12/19
GlacierMIP glaciers: Lucas' netcdf file from GlacierMIP Phase2 matlab file, emailed by Ben Marzeion 26/11/19 "final" for paper submission

HEADER: ice_source, region, group, model, exp_id, GCM, scenario, melt, collapse, 1990, ... , 2100
 
ROWS

- One per simulation.  
- Annual sea level contributions in cm SLE, with 2015 value subtracted from all as the baseline.
- All rows have data from 2015-2100, and some start earlier.

COLUMNS

- ice_source: {GrIS, AIS, Glaciers}

- region: 
--- GrIS: ALL
--- AIS: {WAIS, EAIS, PEN}
--- Glaciers: {region_1, ..., region_19} N.B. Exclude region 19 (Antarctic peripherals) for total land ice, as it is not subtracted from ISMIP6

- group: 
--- GrIS and AIS: ISMIP6 group name
--- Glaciers: NA 

- model: model name
N.B. if you open this in Excel it displays the glacier model 'MAR2012' as 'Mar-12'...

- exp_id: 
--- GrIS and AIS: ISMIP6 experiment name (exp01, exp02 etc)
--- Glaciers:‘'ensemble number' (run_1, run_2, ... run_279)

- scenario: 
--- GrIS and AIS: RCP26, RCP86
--- Glaciers: RCP26, RCP45, RCP60, RCP86

- melt:
--- GrIS and AIS: ocean melt forcing parameter values (GrIS: K, units? AIS: heat exchange velocity parameter "gamma0", m/yr; note 'open' parameterisation is given gamma0 for now to distinguish from NA)
--- Glaciers: NA

- collapse:
--- GrIS: NA
--- AIS: ice shelf collapses, TRUE/FALSE
--- Glaciers: NA


============================================================
GSAT SIMULATIONS: CMIP5, CMIP6 and FAIR

CLIMATE_FORCINGS.CSV
============================================================


CMIP5, CMIP6 and FAIR (500 member) ensembles. 

Sources:
- 2.6 and 8.5 Wm-2 scenarios from Forster et al. (2019) Nature Climate Change - github link in paper. CMIP6 snapshot 7/11/19. 
- Additional SSPs processed in the same by Christine McKenna (co-author of Forster et al.).

HEADER: ensemble, GCM, scenario, 2015, ..., 2100
 
ROWS

- One per simulation.  
- Global mean annual surface air temperature (GSAT) with respect to 1850-1900.
- Each is the mean of the initial condition ensemble.

COLUMNS:

- ensemble: {CMIP5, CMIP6, FAIR}

- GCM: 
--- CMIP5 and CMIP6: GCM name
--- FAIR: {FAIR_1, ... FAIR_500}

- scenario:
--- CMIP5: {RCP26, ..., RCP85}
--- CMIP6, FAIR: {SSP126, ..., SSP585}


