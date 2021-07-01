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

addpreindustrial = 0.85

perc = [ 5., 17., 50., 83., 95. ]
nperc = len(perc)

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

years = [ 2050, 2090 ]
nyears = len(years)
# Assessed temperature ranges
tmin_assessed = np.empty((nyears,nscen),np.float)
tmax_assessed = np.empty((nyears,nscen),np.float)
tcen_assessed = np.empty((nyears,nscen),np.float)
# AR6 WG1 TS: CSB TS.1, Table 1:
# 2050
tmin_assessed[0,:] = [1.9, 1.7, 1.6, 1.3]
tmax_assessed[0,:] = [3.0, 2.6, 2.5, 2.2]
tcen_assessed[0,:] = [2.4, 2.1, 2.0, 1.7]
# 2090
tmin_assessed[1,:] = [3.3, 2.8, 2.1, 1.3]
tmax_assessed[1,:] = [5.7, 4.6, 3.5, 2.4]
tcen_assessed[1,:] = [4.4, 3.6, 2.7, 1.8]

# Transform 1850-1900 reference into 1995-2014, S. Connors e-mail 22/2/2021
tdiff = .85
tmin_assessed[:,:] -= tdiff
tmax_assessed[:,:] -= tdiff
tcen_assessed[:,:] -= tdiff

rightlimit = tmax_assessed[1,:] + .25

nsimmax = 200 # ajustable

fig, ax = plt.subplots()

for iscen, scenario in enumerate(scenarios):

    print('Scenario :{}'.format(scenario))

    xp = []
    yp = []
    npol = 10
    color = sspcolor(scenario)

    filelist = glob.glob('sncbin'+reg+'/sncbin'+reg+'_*_historical+'+scenario+'.nc')

    print(len(filelist))
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

        if (ific == 0) and (iscen == 0):
             nbin = tbin.shape[0]
             alldata = np.empty((nbin,nsimmax),np.float)
             ndatabin = np.zeros((nbin),np.int)
             percentiles = np.empty((nbin,nperc),np.float)
             tbinpre = tbin + addpreindustrial

        if (ific == 0):
            ax.plot(x, y, 'o', markersize=7, color=color, alpha=.75, label="historical+"+scenario)
        else:
            ax.plot(x, y, 'o', markersize=7, color=color, alpha=.75)

        for i in range(y.size):
            if (np.isfinite(y[i])) and (np.abs(y[i]) < 1.e10 ):
              xp = np.append(xp,x[i])
              yp = np.append(yp,y[i])
              alldata[i,ndatabin[i]] = y[i]
              ndatabin[i] += 1

    slope[iscen], intercept[iscen], r_value, p_value, std_err = stats.linregress(xp,yp)
    xmin[iscen] = np.amin(xp)
    xmax[iscen] = np.amax(xp)
    print(scenario,slope[iscen], intercept[iscen], r_value, p_value, std_err)

# percentiles
print()
print("Percentiles: GWL,", perc[:])
print()
for i in range(nbin):
    if (ndatabin[i] > 10):
        for j in range(nperc):
            percentiles[i,j] = np.percentile(alldata[i,0:ndatabin[i]],perc[j])
    else:
        percentiles[i,:] = 999.9

for i in range(nbin):
    print(tbinpre[i],percentiles[i,:])

for iscen, scenario in enumerate(scenarios):
    xr = np.arange(xmin[iscen], xmax[iscen],(xmax[iscen]-xmin[iscen])/npol)
    yr = slope[iscen] * xr[:] + intercept[iscen]
    color = sspcolor(scenarios[iscen])
    ax.plot(xr, yr, color="white", linewidth=6)
    ax.plot(xr, yr, color=color, linewidth=4)


    if ( True ):

        # GSAT change ranges for the various scenarios:
        #

        tmin = np.zeros((nyears),dtype=float)
        tmax = np.zeros((nyears),dtype=float)
        dt = np.zeros((nyears),dtype=float)
        tcen = np.zeros((nyears),dtype=float)

        if ( True ):
            for iyear,year in enumerate(years):
                tmax[iyear] = tmax_assessed[iyear,iscen]
                tmin[iyear] = tmin_assessed[iyear,iscen]
                dt[iyear] = tmax[iyear] - tmin[iyear]
                tcen[iyear] = tcen_assessed[iyear,iscen]
        else:
            for iyear,year in enumerate(years):
                tmin[iyear] = min(GSATave[iyear,:])
                dt[iyear] = max(GSATave[iyear,:]) - min(GSATave[iyear,:])
                tcen[iyear] = ( max(GSATave[iyear,:]) + min(GSATave[iyear,:]) ) / 2.

        ax.legend()

        # ytemp = 60.-iscen*13.
        ytemp = -75.+iscen*11.
        dy1 = 5.
        dy2 = 1.

        # plt.plot((.5, 8.2), (ytemp, ytemp), 'k-', linewidth=1, zorder=0 )
        plt.plot((-1.5, rightlimit[iscen]), (ytemp, ytemp), 'k-', linewidth=1, zorder=0 )
        ax.annotate(scenario,xy=(-1,ytemp+dy2), fontsize=8, horizontalalignment='left')
        for iyear,year in enumerate(years):
            deltay = 0
            if ( iyear == 1 ):
              deltay = -5.
            ax.barh( ytemp+deltay, dt[iyear], height=dy1, left=tmin[iyear], align='edge', color=color, alpha=1, zorder=1)
            tcolor = 'white'
            if ( scenario == "ssp245" ):
                tcolor = 'black'
            fontsize = 8
            ax.annotate(str(year),xy=(tcen[iyear],ytemp+dy2+deltay), color=tcolor, fontsize=fontsize, horizontalalignment='center')

ax.set_ylabel('Snow cover extent change (%)')
ax.set_xlabel('GSAT change wrt. 1995-2014 average (K)')
# ax.set_xlabel('GSAT change wrt. preindustrial (1850-1900) (°C)')
if (letter != ""):
    if (reg == ""):
        # ax.set_ylim(ymin=-84., ymax=68.)
        ax.set_ylim(ymin=-81, ymax=27.)
    else:
        ax.set_ylim(ymin=-100., ymax=50.)
ax.set_title(letter+' Sensitivity of NH '+monthtext+' snow cover')
# ax.set_title(letter+' Sensitivity of Arctic (>60°N) '+monthtext+' snow cover')
ax.legend()

# plt.show()
fig.savefig("../PNGs/snow_scenariodependence"+reg+"_"+mons+".png")
fig.savefig("../PNGs/snow_scenariodependence"+reg+"_"+mons+".pdf")
