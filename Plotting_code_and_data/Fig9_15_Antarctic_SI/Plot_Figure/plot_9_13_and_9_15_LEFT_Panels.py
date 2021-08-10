# Plotting routine to create the left panels of Figures 9.13 and 9.15 of IPCC AR6
#
# Written by Dirk Notz (dirk.notz@uni-hamburg.de)
#
# 12 March 2021
#
# The two necessary input data files of sea-ice area can be obtained from  http://doi.org/10.25592/uhhfdm.8559

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import calendar
from netCDF4 import Dataset,num2date


# Read sea-ice area data into panda DataFrame
def read_sia(hemisphere, algorithms):
    # Read input data
    data_file = Dataset('../Plotted_Data/SeaIceArea__'+hemisphere+'__monthly__UHH__v2019_fv0.01.nc','r',format='NETCDF4')
    # Convert time information from NetCDF to Panda DataFrame index
    time_var = data_file.variables['time']
    times = num2date(time_var[:].squeeze(), time_var.units,
                             only_use_cftime_datetimes=False,
                             only_use_python_datetimes=True)
    # Read sea-ice area data for the given algorithms
    sia = pd.DataFrame(index=pd.DatetimeIndex(pd.Series(times)) )
    for algorithm in algorithms:
        sia[algorithm] = data_file.variables[algorithm][:]
    return sia

# Create array of monthly sea-ice area averaged across the algorithms for a given period
# start_year and end_year define the period to be plotted
# start_ref and end_ref define the beginning and end of the reference period for the anomalies
def create_array(sia, start_year, end_year, start_ref, end_ref):
    sia = sia[(sia.index.year>=start_year) & (sia.index.year<=end_year)]
    sia = sia.mean(axis=1)    
    sia_array = pd.DataFrame(index=range(start_year,end_year+1))
    for i in range(1,13):
        sia_array[i] = sia[(sia.index.month==i)].values
    # calculate anomalies relative to given period
    sia_array = sia_array - sia_array.loc[start_ref:end_ref].mean(axis=0)
    return sia_array

# plot the array as a pcolormesh
def plot_array(sia_array, hemisphere)   :
    titlestr={'SouthernHemisphere':'Antarctic','NorthernHemisphere':'Arctic'  }
    fig=plt.figure()
    ax= plt.pcolormesh(np.flipud((sia_array.transpose())),vmin=-2.5, vmax=2.5, cmap='RdBu')
    plt.yticks(np.arange(12)+0.5, calendar.month_name[13:0:-1])
    plt.xticks(np.arange(1,42,5)+0.5, np.arange(1980,2025,5))
    plt.axis((0,42,0,12))
    ax.axes.set_aspect(3.5)
    cbar = plt.colorbar(ax)
    cbar.ax.set_ylabel('million km$^2$')
    plt.title('Absolute anomaly of '+titlestr[hemisphere]+' sea-ice area')
    
 
for hemisphere in ['SouthernHemisphere', 'NorthernHemisphere']:
    # Extract sea-ice area for NASA Team, Bootstrap and OSISAF algorithm
    sia = read_sia(hemisphere, ['nsidc_nt','nsidc_bt','osisaf'])
    sia_array = create_array(sia, 1979, 2019, 1979, 2008)
    plot_array(sia_array, hemisphere)
    plt.savefig('../PNGs/'+hemisphere+'LEFT_PANEL.pdf')




