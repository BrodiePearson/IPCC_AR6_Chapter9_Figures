#!/usr/bin/env python3
# -* coding: utf-8 -*

import glob
import sys
import numpy as np
import netCDF4
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import math
from scipy.optimize import least_squares

# present-day text files (like pf15m_land-hist_NH_1979-1998.txt) for CMIP6: pf-eval-pres.bash

######
def format_fn(tick_val, tick_pos):
    labels = [ 'Obs.', 'CMIP5\nhistorical', 'CMIP6\nhistorical', 'CMIP6\nAMIP', 'CMIP6\nland-hist', 'XXX' ]
    return labels[int(round(tick_val))]

#######
def linfunc(p, x, y=0):
    return 100 * ( p[0] * x ) - y

def expfunc(p, x, y=0):
    return 100. * ( np.exp( p[0] * x ) - 1. ) - y

#######
#  main
#######

regression = "linear"

# average temperature over nyrave years
nyrave = 5
mpy = 12
Year0 = 1850
years = [ 2050, 2090 ]
nyears = len(years)
npol = 10
tlimreg = 3.

scenarios = [ "ssp585", "ssp370", "ssp245", "ssp126" ]
nscen = len(scenarios)

# Assessed temperature ranges
tmin_assessed = np.empty((nyears,nscen),np.float)
tmax_assessed = np.empty((nyears,nscen),np.float)
tcen_assessed = np.empty((nyears,nscen),np.float)
# AR6 WG1 SPM: Box SPM.2, Table 1:
# 2050
tmin_assessed[0,:] = [1.1, 0.9, 0.8, 0.6]
tmax_assessed[0,:] = [2.0, 1.8, 1.5, 1.2]
tcen_assessed[0,:] = [1.6, 1.3, 1.1, 0.9]
# 2090
tmin_assessed[1,:] = [2.6, 2.0, 1.3, 0.6]
tmax_assessed[1,:] = [4.7, 3.8, 2.5, 1.4]
tcen_assessed[1,:] = [3.6, 2.9, 1.9, 1.0]

fig = plt.figure(figsize=(11, 4))

# left
######

depth = "15"
year1 = "1979"
year2 = "1998"

experiments = [ "CMIP5historical", "historical", "amip", "land-hist" ]

colors = [ "royalblue", "darkgoldenrod", "green", "blueviolet" ]

ax0 = plt.subplot2grid((1, 7), (0, 0), colspan=3)
for iexp, experiment in enumerate(experiments):
    
    data = []
    f = open("data/pf"+depth+"m_"+experiment+"_NH_"+year1+"-"+year2+".txt", "r")
    lines = f.readlines()
    data = np.zeros((len(lines)),np.float)
    for i, line in enumerate(lines):
        data[i] = float(line.split()[1]) / 1e6
    f.close()
    
    color = colors[iexp]
    lineoffsets = np.array([iexp+1.])
    linelengths = [.6]
    
    # create a vertical plot
    ax0.eventplot(data, colors=[color], lineoffsets=lineoffsets,
                  linelengths=linelengths, orientation='vertical')

obscolor = 'black'
markersize = 6
ax0.errorbar(-.1, 15.3, yerr=2.4, linewidth= 2, markersize=markersize, fmt='-o', color=obscolor)
ax0.plot(.0, 14.57, marker='*', markersize=markersize, color=obscolor)
ax0.plot(.1, 13.95, marker='>', markersize=markersize, color=obscolor)

ax0.set_xlim(-.5,4.5)
ax0.set_title('a) '+year1+'-'+year2+' NH Area with Permafrost\n in top '+depth+'m')
ax0.set_ylabel('Permafrost Extent (10$^6$ km$^2$)')

ax0.xaxis.set_major_locator(ticker.IndexLocator(base=1, offset=0))
ax0.xaxis.set_major_formatter(ticker.FuncFormatter(format_fn))

ax0.spines['right'].set_visible(False)
ax0.spines['top'].set_visible(False)

# right
#######

ibin = -1
depth = "3"

ax1 = plt.subplot2grid((1, 7), (0, 4), colspan=4)

repertoire="pfvolbin-"+depth+"m"

# outliers = "BCC-CSM2-MR CanESM5 CanESM5-CanOE KACE-1-0-G IPSL-CM6A-LR CAMS-CSM1-0"
# BCC-CSM2-MR - present-day permafrost extent too low
# CanESM5 CanESM5-CanOE - present-day permafrost extent too low
# CAMS-CSM1-0 - present-day permafrost extent too low
# could add KACE-1-0-G - exaggerated 0 curtain
# could add IPSL-CM6A-LR - no explicit soil freezing
outliers = "BCC-CSM2-MR CanESM5 CanESM5-CanOE CAMS-CSM1-0"

for iscenario,scenario in enumerate(scenarios):

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
     
    liste = glob.glob(repertoire+"/*"+scenario+"*")
    liste.sort()
    nmod = len(liste)
    GSATave = np.zeros((nyears,nmod),dtype=float)

    models = []
    
    for imod,fichier in enumerate(liste):
    
        modele = fichier.split("/")[1].split("_")[1]
        models.append(modele)
      
        f = netCDF4.Dataset(fichier)
        tbin = f.variables['bin'][:]
        dGSAT = f.variables['dGMAT'][:]
        nt = dGSAT.size
      
        if (ibin == -1):
            ntbin = tbin.size
            for i in range(ntbin-1):
                if ( tbin[i] <= 0 ) & ( tbin[i+1] >= 0 ):
                    ibin=i
                    p1 = tbin[ibin+1]/(tbin[ibin+1]-tbin[ibin])
                    p2 = 1 - p1
      
        pfbin = f.variables['pfbin'][:]/1000
        pfref = p1 * pfbin[ibin] + p2 * pfbin[ibin+1]
        pfbin -= pfref
        pfbin /= pfref
        pfbin *= 100.
      
        if ( imod < 10 ):
            linestyle="-"
        else:
            linestyle="--"
    
        if ( imod == 0 ):
          pfbinarr = np.zeros((nmod,ntbin),dtype=float)
        pfbinarr[imod,:] = pfbin[:]
      
        for iyear,year in enumerate(years):
            mon1 = np.int((year-Year0)*12)
            mon2 = np.int((year-Year0)*12)
            nmext = np.int((nyrave-1)*mpy/2)
            mon1ext = mon1-nmext
            mon2ext = mon2+nmext
            if ( mon2ext > nt-1 ):
                mon2ext = nt-1
            nmon = mon2ext - mon1ext + 1
            GSATave[iyear,imod] = np.sum(dGSAT[mon1ext:mon2ext])/nmon
      
        f.close
    
    # temperature bin size is 0.2 deg C, therefore we have a tolerance of +-0.1 around 0
    # historic part:
    nmodeff = 0
    for imod in range(nmod):
        if (models[imod] not in outliers):
           nmodeff += 1
           xr = []; yr = []
           for i in range(ntbin):
               if ( np.abs(pfbinarr[imod,i]) < 100. ) and ( tbin[i] <= 0.1 ):
                   xr.append( tbin[i] ); yr.append( pfbinarr[imod,i] )
           ax1.scatter(xr, yr, c='gray', edgecolor='face', marker='o', s=9, alpha=1)
    print("Scenario, number of models taken into account: {}, {}".format(scenario,nmodeff))

    # projection part (tbin >= 0):
    xrt = []
    yrt = []
    for imod in range(nmod):
        if (models[imod] not in outliers):
           xr = []; yr = []
           for i in range(ntbin):
               if ( np.abs(pfbinarr[imod,i]) < 100. ) and ( tbin[i] >= -0.1 ):
                   xr.append( tbin[i] ); yr.append( pfbinarr[imod,i] )
                   if ( tbin[i] <= tlimreg ):
                       xrt.append( tbin[i] ); yrt.append( pfbinarr[imod,i] )
           ax1.scatter(xr, yr, c=color, edgecolor='face', marker='o', s=9, alpha=1)

    # calculate slopes
    xrt = np.array(list(xrt))
    yrt = np.array(list(yrt))
    if (regression == "linear"):
      res_lsq = least_squares(linfunc, [0.], method='lm', args=(xrt, yrt))
    elif (regression == "exponential"):
      res_lsq = least_squares(expfunc, [0.], method='lm', args=(xrt, yrt))
    a0 = res_lsq.x
    print(regression+" regression between 0 and {} for {}: slope={}".format(tlimreg,scenario,a0))

    # plot regressions
    xmin = np.amin(xrt)
    xmax = np.amax(xrt)
    if (scenario == "ssp585"):
        xmax += .25 # for visibility purposes
    xr = np.arange(xmin, xmax,(xmax-xmin)/10)
    yr = a0*100. * xr[:]
    ax1.plot(xr, yr, color="white", linewidth=6, alpha=1)
    ax1.plot(xr, yr, color=color, linewidth=4, alpha=1) 

    if ( False ):

        # GSAT change ranges for the various scenarios:
        #
        
        tmin = np.zeros((nyears),dtype=float)
        tmax = np.zeros((nyears),dtype=float)
        dt = np.zeros((nyears),dtype=float)
        tcen = np.zeros((nyears),dtype=float)
    
        if ( True ):
            for iyear,year in enumerate(years):
                tmax[iyear] = tmax_assessed[iyear,iscenario]
                tmin[iyear] = tmin_assessed[iyear,iscenario]
                dt[iyear] = tmax[iyear] - tmin[iyear]
                tcen[iyear] = tcen_assessed[iyear,iscenario]
        else:
            for iyear,year in enumerate(years):
                tmin[iyear] = min(GSATave[iyear,:])
                dt[iyear] = max(GSATave[iyear,:]) - min(GSATave[iyear,:])
                tcen[iyear] = ( max(GSATave[iyear,:]) + min(GSATave[iyear,:]) ) / 2.
        
        ax1.legend()
        
        ytemp = 55.-iscenario*13.
        dy1 = 6.
        dy2 = 1.
        
        plt.plot((.5, 8.2), (ytemp, ytemp), 'k-', linewidth=1, zorder=0 )
        ax1.annotate(scenario,xy=(6.5,ytemp+dy2), fontsize=8, horizontalalignment='left')
        for iyear,year in enumerate(years):
            deltay = 0
            if ( iyear == 1 ):
              deltay = -6.3
            ax1.barh( ytemp+deltay, dt[iyear], height=dy1, left=tmin[iyear], align='edge', color=color, alpha=1, zorder=1)
            tcolor = 'white'
            if ( scenario == "ssp245" ):
                tcolor = 'black'
            fontsize = 8
            if ( scenario == "ssp126" ):
                fontsize = 6
            ax1.annotate(str(year),xy=(tcen[iyear],ytemp+dy2+deltay), color=tcolor, fontsize=fontsize, horizontalalignment='center')
    
ax1.set_xlabel('GSAT wrt. 1995-2014 mean (K)')
ax1.set_ylabel('Permafrost Volume Change (%)')
ax1.set_title('b) Global Permafrost Volume Change\n(top '+depth+'m)')

# sauvegarder
#############
plt.savefig('../PNGs/AR6_WGI_Fig9-24.png',format='png')
plt.savefig('../PNGs/AR6_WGI_Fig9-24.pdf',format='pdf')
plt.show()
