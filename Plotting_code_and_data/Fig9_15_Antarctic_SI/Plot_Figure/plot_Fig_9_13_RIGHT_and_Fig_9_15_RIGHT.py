# This script plots the observed sea-ice concentration for two time periods, as well as their difference,
# for three different sources (OSISAF, NSIDC Nasa Team, NSIDC Bootstrap), as well as the number of CMIP6
# models with more than 15% sea-ice concentration for a future time period. It reads the data from a 
# compressed npz file.
import numpy as np
import glob
import os
from mpl_toolkits.basemap import Basemap
from netCDF4 import Dataset
import matplotlib.pyplot as plt
import matplotlib
from matplotlib.colors import LinearSegmentedColormap

plt.rcParams.update({'hatch.color': 'lightgrey'})

# -------------------------------------------------------------------------------------------------
# construct the colormaps used for the IPCC
# divergent colormap
rgbarray1 = np.genfromtxt('../Plotted_Data/cryo_div.txt')
cmap_div = matplotlib.colors.LinearSegmentedColormap.from_list("", np.flip(rgbarray1,0))
#cmap_div = matplotlib.colors.LinearSegmentedColormap.from_list("", rgbarray1)
# sequential colormap
rgbarray2 = np.genfromtxt('../Plotted_Data/cryo_seq.txt')
cmap_seq = matplotlib.colors.LinearSegmentedColormap.from_list("", rgbarray2)
# model colormap
c1 = [0/255,51/255,0/255] 
c2 = [1,1,1]
N = 20
r = list(np.linspace(c1[0],c2[0],N))
g = list(np.linspace(c1[1],c2[1],N))
b = list(np.linspace(c1[2],c2[2],N))
cmap_model = LinearSegmentedColormap.from_list(
        'model', np.array([r,g,b]).transpose(), N=N)
# -------------------------------------------------------------------------------------------------------
m = {}
m['NH'] = Basemap(resolution='l',projection='npstere',lon_0=0,boundinglat=55., round=True) 
m['SH'] = Basemap(resolution='l',projection='spstere',lon_0=180,boundinglat=-55., round=True) 

# load data
conc,lat,lon,conc_future,lat_future,lon_future,n_models = np.load('../Plotted_Data/mapplot_data.npz',allow_pickle=True)['a']

lateyear1 = '2010'
lateyear2 = '2019'
scenario = 'ssp245'

futureyear1 = '2045'
futureyear2 = '2054'

# Read in the NSIDC data to cover the pole hole with ice
file = Dataset('../Plotted_Data/NSIDC_polehole_big.nc')
poleholeearly = file.variables['goddard_nt_seaice_conc_monthly'][0,:,:].copy().astype(float)
file = Dataset('../Plotted_Data/NSIDC_polehole_small.nc')
poleholelate = file.variables['goddard_nt_seaice_conc_monthly'][0,:,:].copy().astype(float)

lons,lats = np.meshgrid(lon['NH'],lat['NH'])
poleholelate[lats<84] = np.nan
poleholeearly[lats<84] = np.nan

file.close()
fig = plt.figure(figsize=(20,20))
im = {}
vmin = {'ensmean_1979-1988':0, 'ensmean_'+lateyear1+'-'+lateyear2:0, 'ensmean_diff':-1, 'ensstd_diff':0}
vmax = {'ensmean_1979-1988':1, 'ensmean_'+lateyear1+'-'+lateyear2:1, 'ensmean_diff':1, 'ensstd_diff':0.25}
cmap = {'ensmean_1979-1988':cmap_seq, 'ensmean_'+lateyear1+'-'+lateyear2:cmap_seq, 'ensmean_diff':cmap_div, 'ensstd_diff':'Greens'}
titles = {1:'Arctic\nMarch', 2:'Arctic\nSeptember', 3:'Antarctic\nSeptember', 4:'Antarctic\nFebruary'}
sidetitles = {1:'1979-1988', 2:'Observations\n\n'+lateyear1+'-'+lateyear2, 3:' ('+lateyear1+'-'+lateyear2+') \n- (1979-1988)', 4:scenario.upper()+'\n\n2045-2054'}

#### Plot
#### There are two separate plots for Antarctic and Arctic

#######################################################################################
## Fig 9.13 right panel (Arctic):
fig = plt.figure(figsize=(16,8))
hemisphere = 'NH'
j= 1
for season in ['nhwinter', 'nhsummer']:
    for i,var in enumerate(['ensmean_1979-1988', 'ensmean_'+lateyear1+'-'+lateyear2, 'ensmean_diff', 'future']):
        plt.subplot(2,4,j)
        llon,llat = np.meshgrid(lon[hemisphere],lat[hemisphere])
        # Set data in the polehole to NaN
        if var == 'ensmean_'+lateyear1+'-'+lateyear2:
            conc[hemisphere][var][season][poleholelate>0] = 100
            #m[hemisphere].pcolormesh(llon,llat,poleholelate,latlon=True,vmin=1,vmax =2,cmap='gray')
        elif var in ['ensmean_1979-1988','ensmean_diff']:
            conc[hemisphere][var][season][poleholeearly>0] = 100
            #m[hemisphere].pcolormesh(llon,llat,poleholeearly,latlon=True,vmin=1,vmax =2,cmap='gray')
        
        if var == 'future':
            llon,llat = lon_future[hemisphere],lat_future[hemisphere]
            im[j-1] = m[hemisphere].contourf(llon,llat,conc_future[hemisphere][season],latlon=True,levels=np.arange(0,n_models[hemisphere][season]+1,3),cmap=cmap_model)
        elif var == 'ensmean_diff':
            conc[hemisphere][var][season][poleholeearly>0] = 0
            conc_curr = np.abs(conc[hemisphere][var][season]) - 2*conc[hemisphere]['ensstd_diff'][season]
            conc_sign = np.ma.masked_greater(conc_curr,0.001)
            levels = np.array([-100,-90,-80,-70,-60,-50,-40,-30,-20,-10,-2,2,10,20,30,40,50,60,70,80,90,100])
            im[j-1] = m[hemisphere].contourf(llon,llat,conc[hemisphere][var][season],latlon=True,levels=levels,cmap=cmap[var])
            m[hemisphere].contourf(llon,llat,conc_sign,hatches=['xxx'],latlon=True,alpha=0.)
        else:
            im[j-1] = m[hemisphere].contourf(llon,llat,conc[hemisphere][var][season],latlon=True,levels=np.arange(0,110,10),cmap=cmap[var])
        m[hemisphere].drawcoastlines(linewidth=0.5,color='k')
        m[hemisphere].fillcontinents(color='silver',lake_color='silver')
        m[hemisphere].drawmapboundary()
        if j < 5:
            plt.title(sidetitles[j],fontsize=18)
        if j == 1 or j == 5:
            plt.ylabel(titles[int(j/4)+1],fontsize=18)
        j += 1

# add line between observations and models
fig.patches.extend([plt.Rectangle((0.707,0.01),0.002,0.97,
                                  fill=True, color='k', alpha=1, zorder=1000,
                                  transform=fig.transFigure, figure=fig)])
# Add colorbars
cbar_ax1 = fig.add_axes([0.248, 0.07, 0.14, 0.03])
c = fig.colorbar(im[4], cax=cbar_ax1,orientation='horizontal')
c.set_label(label='Sea-ice concentration (%)',size=18)
c.ax.tick_params(labelsize=12) 
cbar_ax2 = fig.add_axes([0.539, 0.07, 0.14, 0.03])
c = fig.colorbar(im[6], cax=cbar_ax2,ticks=[-100,-50,0,50,100],spacing="proportional",orientation='horizontal')
c.ax.tick_params(labelsize=12) 
c.set_label(label='Sea-ice concentration\nchange (%)',size=18)
cbar_ax4 = fig.add_axes([0.737, 0.07, 0.14, 0.03])
c = fig.colorbar(im[7],cax=cbar_ax4,ticks=np.arange(0,31,6),orientation='horizontal')
c.ax.tick_params(labelsize=12) 
c.set_label(label='Number of models\nabove 15% sea-ice\nconcentration',size=18)
plt.subplots_adjust(hspace=0.05,wspace=0.05)
fig.savefig('../PNGs/Fig_9_13_RIGHT.png',dpi=500,bbox_inches='tight')
#fig.savefig('/work/mh0033/m300681/IPCC/ice_obs_nh.pdf',bbox_inches='tight')

## Fig 9.15 right panel (Antarctic):
fig = plt.figure(figsize=(16,8))
hemisphere = 'SH'
j= 1
for season in ['nhsummer','nhwinter']:
    for i,var in enumerate(['ensmean_1979-1988', 'ensmean_'+lateyear1+'-'+lateyear2, 'ensmean_diff', 'future']):
        plt.subplot(2,4,j)
        llon,llat = np.meshgrid(lon[hemisphere],lat[hemisphere])
        
        if var == 'future':
            llon,llat = lon_future[hemisphere],lat_future[hemisphere]
            im[j-1] = m[hemisphere].contourf(llon,llat,conc_future[hemisphere][season],latlon=True,levels=np.arange(0,n_models[hemisphere][season]+1,3),cmap=cmap_model)
        elif var == 'ensmean_diff':
            conc_curr = np.abs(conc[hemisphere][var][season]) - 2*conc[hemisphere]['ensstd_diff'][season]
            conc_sign = np.ma.masked_greater(conc_curr,0.001)
            levels = np.array([-100,-90,-80,-70,-60,-50,-40,-30,-20,-10,-2,2,10,20,30,40,50,60,70,80,90,100])
            im[j-1] = m[hemisphere].contourf(llon,llat,conc[hemisphere][var][season],latlon=True,levels=levels,cmap=cmap[var], origin='lower')
            m[hemisphere].contourf(llon,llat,conc_sign,hatches=['xxx'],latlon=True,alpha=0.)
        else:
            im[j-1] = m[hemisphere].contourf(llon,llat,conc[hemisphere][var][season],latlon=True,levels=np.arange(0,110,10),cmap=cmap[var])
        m[hemisphere].drawcoastlines(linewidth=0.5,color='k')
        m[hemisphere].fillcontinents(color='silver',lake_color='silver')
        m[hemisphere].drawmapboundary()
        if j < 5:
            plt.title(sidetitles[j],fontsize=18)
        if j == 1 or j == 5:
            plt.ylabel(titles[int(j/4)+3],fontsize=18)
        j += 1

# add line between observations and models
fig.patches.extend([plt.Rectangle((0.707,0.01),0.002,0.97,
                                  fill=True, color='k', alpha=1, zorder=1000,
                                  transform=fig.transFigure, figure=fig)])
# Add colorbars
cbar_ax1 = fig.add_axes([0.248, 0.07, 0.14, 0.03])
c = fig.colorbar(im[4], cax=cbar_ax1,orientation='horizontal')
c.set_label(label='Sea-ice concentration (%)',size=18)
c.ax.tick_params(labelsize=12) 
cbar_ax2 = fig.add_axes([0.539, 0.07, 0.14, 0.03])
c = fig.colorbar(im[6], cax=cbar_ax2,ticks=[-100,-50,0,50,100],spacing="proportional",orientation='horizontal')
c.ax.tick_params(labelsize=12) 
c.set_label(label='Sea-ice concentration\nchange (%)',size=18)
cbar_ax4 = fig.add_axes([0.737, 0.07, 0.14, 0.03])
c = fig.colorbar(im[7],cax=cbar_ax4,ticks=np.arange(0,31,6),orientation='horizontal')
c.ax.tick_params(labelsize=12) 
c.set_label(label='Number of models\nabove 15% sea-ice\nconcentration',size=18)
plt.subplots_adjust(hspace=0.05,wspace=0.05)
fig.savefig('../PNGs/Fig_9_15_RIGHT.png',dpi=500,bbox_inches='tight')
#fig.savefig('/work/mh0033/m300681/IPCC/ice_obs_sh.pdf',bbox_inches='tight')
