#!/usr/bin/env python3
# -*- coding: utf-8 -*-
""" postprocess_esl.py
This script converts FACTS ESL results in CSV format to NetCDF

Created on Tue July 27 2021
@author: Tim Hermans
"""
import os
import pandas as pd
import xarray as xr

input_path ='/Users/thermans/Documents/GitHub/IPCC_AR6_Chapter9_Figures/Plotting_code_and_data/Fig9_32_ESL_proj/Plot_Figure/data'
output_path = '/Users/thermans/Documents/GitHub/IPCC_AR6_Chapter9_Figures/Plotting_code_and_data/Fig9_32_ESL_proj/Plotted_Data'

input_files = ['facts_esl_af_allow_ssp585_2050.txt','facts_esl_af_allow_ssp585_2100.txt',
               'facts_esl_af_allow_ssp245_2050.txt','facts_esl_af_allow_ssp245_2100.txt',
               'facts_esl_af_allow_ssp126_2050.txt','facts_esl_af_allow_ssp126_2100.txt']

for f,file in enumerate(input_files):
    
    df = pd.read_csv(os.path.join(input_path,file),sep='\t')
    df.columns = ['station','lon','lat','slc50','alwnce5','alwnce17','alwnce50','alwnce83','alwnce95','af5','af17','af50','af83','af95']
    
    ds = df[['station','lon','lat','af50']].to_xarray()
    
    #add attributes
    ds.attrs['Title'] = 'Extreme sea-level projections for SSP'+file[22:25]+', '+file[26:30]
    ds.attrs['comments'] = 'Data is for panel ('+'abcdef'[f]+') of Figure 9.32 in the IPCC Working Group I contribution to the Sixth Assesment Report'
    
    ds.station.attrs['var_name'] = 'station name'
    ds.station.attrs['var_units'] = '-'
    
    ds.lon.attrs['var_name'] = 'Longitude'
    ds.lon.attrs['var_units'] = 'degrees'
    
    ds.lat.attrs['var_name'] = 'Latitude'
    ds.lat.attrs['var_units'] = 'degrees'
    
    ds.af50.attrs['var_name'] = 'Median amplification factor'
    ds.af50.attrs['var_units'] = '-'
    
    #save dataset to netcdf
    ds.to_netcdf(os.path.join(output_path,'Fig9-32'+'abcdef'[f]+'_'+file[:-4]+'.nc'),mode='w')