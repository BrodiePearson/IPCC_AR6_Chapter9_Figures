#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 15 14:19:27 2017

@author: gkrinner
"""

import netCDF4
import numpy as np
import sys
import glob
import matplotlib.pyplot as plt
from scipy import stats

def sspcolor(scenario):
    if ( scenario == "ssp585" ):
        color = "#840b22"
    elif ( scenario == "ssp370" ):
        color = "#f21111"
    elif ( scenario == "ssp245" ):
        color = "#eadd3d"
    elif ( scenario == "ssp126" ):
        color = "#1d3354"
    else:
        print("Definir scenario")
        quit()
    return(color)

"""

Programme principal

"""

nm = 12

reg = ""
# reg = "-N60"

# months
# March-May
m1 = 2; m2 = 4; monthtext = "spring (MAM)"; mons = "MAM"; letter = "b)"
# April-May
# m1 = 3; m2 = 4; monthtext = "spring (April-May)"; mons = "AM"; letter = ""
# May-June
# m1 = 4; m2 = 5; monthtext = "spring (May-June)"; mons = "MJ"; letter = ""
# m1 = 3; m2 = 4; monthtext = "spring (April-May)"; mons = "AM"; letter = ""
# April-June
# m1 = 3; m2 = 5; monthtext = "spring (AMJ)"; mons = "AMJ"; letter = ""
# September-November
# m1 = 8; m2 = 10; monthtext = "autumn (SON)"; mons = "SON"; letter = ""
# October-December
# m1 = 9; m2 = 11; monthtext = "autumn (OND)"; mons = "OND"; letter = ""
# October-November
# m1 = 9; m2 = 10; monthtext = "autumn (October-November)"; mons = "ON"; letter = "b)"

scenarios = [ 'ssp585', 'ssp370', 'ssp245', 'ssp126' ]

highECSmodels = [ 'CanESM5', 'CESM2', 'CESM2-WACCM', 'CNRM-CM6-1', 'CNRM-ESM2-1',
                  'HadGEM3-GC31-LL', 'IPSL-CM6A-LR', 'NESM3', 'UKESM1-0-LL' ]

nscen = len(scenarios)
slope = np.empty((nscen),np.float)
intercept = np.empty((nscen),np.float)
xmin = np.empty((nscen),np.float)
xmax = np.empty((nscen),np.float)

fig, ax = plt.subplots()

for iscen, scenario in enumerate(scenarios):

    print('Scenario :{}'.format(scenario))

    xp = []
    yp = []
    npol = 10
    color = sspcolor(scenario)

    filelist = glob.glob('sncbin'+reg+'/sncbin'+reg+'_*_historical+'+scenario+'.nc')

    for ific, fichier in enumerate(filelist):

        model = fichier.rsplit("/",1)[1].split("_")[1]

        print('  {}'.format(model))

        # if (model not in highECSmodels):
        #     print("pas pris en compte")
        #     continue

        f = netCDF4.Dataset(fichier)
        spval = f.variables['sncbin'].missing_value
        sncbin = f.variables['sncbin'][:,:]
        tbin = f.variables['Tbin'][:]
        f.close()

        idx = np.argmin(np.abs(tbin))
        for im in range(nm):
            sncbin[:,im] /= sncbin[idx,im]
        x = tbin
        y = np.average(sncbin[:,m1:m2+1],axis=1)
        y -= 1.
        y *= 100.

        if (ific == 0):
            ax.plot(x, y, 'o', markersize=7, color=color, alpha=.75, label="historical+"+scenario)
        else:
            ax.plot(x, y, 'o', markersize=7, color=color, alpha=.75)

        for i in range(y.size):
            if (np.isfinite(y[i])) and (np.abs(y[i]) < 1.e10 ):
              xp = np.append(xp,x[i])
              yp = np.append(yp,y[i])

    slope[iscen], intercept[iscen], r_value, p_value, std_err = stats.linregress(xp,yp)
    xmin[iscen] = np.amin(xp)
    xmax[iscen] = np.amax(xp)
    print(scenario,slope[iscen], intercept[iscen], r_value, p_value, std_err)

for iscen in range(nscen):
    xr = np.arange(xmin[iscen], xmax[iscen],(xmax[iscen]-xmin[iscen])/npol)
    yr = slope[iscen] * xr[:] + intercept[iscen]
    color = sspcolor(scenarios[iscen])
    ax.plot(xr, yr, color="white", linewidth=6)
    ax.plot(xr, yr, color=color, linewidth=4)

ax.set_ylabel('Snow cover extent change (%)')
ax.set_xlabel('GSAT change wrt. 1995-2014 average (K)')
# ax.set_xlabel('GSAT change wrt. preindustrial (1850-1900) (°C)')
if (letter != ""):
    if (reg == ""):
        ax.set_ylim(ymin=-87., ymax=23.)
    else:
        ax.set_ylim(ymin=-100., ymax=50.)
ax.set_title(letter+' Sensitivity of NH '+monthtext+' snow cover')
# ax.set_title(letter+' Sensitivity of Arctic (>60°N) '+monthtext+' snow cover')
ax.legend()

# plt.show()
fig.savefig("snow_scenariodependence"+reg+"_"+mons+".png")
fig.savefig("snow_scenariodependence"+reg+"_"+mons+".pdf")
