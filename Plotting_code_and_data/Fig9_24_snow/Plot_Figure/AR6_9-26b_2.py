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

"""

Programme principal

"""

mpy = 12
ZeroCelsius = 273.15
nyrave=5 # in years
dTbin=.2
Tbinmin=-3.
Tbinmax=8.

variable = 'snc'

scenario = 'ssp585'

Ybegref = 1995
Yendref = 2014

membermask = 'r?i1p1f?'
filelist_Thist = glob.glob('Series_historical_Amon_tas_1850-2014/*_'+membermask+'_*.nc')

Tbinpost = np.arange(Tbinmin-dTbin/2.,Tbinmax+dTbin/2.,dTbin,np.float)
Tbin = np.arange(Tbinmin,Tbinmax,dTbin,np.float)
nbin = Tbin.size

models = []
for ific, fichier in enumerate(filelist_Thist):
    model = fichier.rsplit("/",1)[1].split("_")[0]
    if ( model not in models ):
        models.append(model)

selection = []

for imod, model in enumerate(models):

    membermask = 'r?i1p1f?'
    if (model == 'NorESM2-LM'):
        membermask = 'r2i1p1f?'
    filelist_Thist = glob.glob('Series_historical_Amon_tas_1850-2014/'+model+'*_'+membermask+'_*.nc')
    filelist_Thist.sort()
    if (filelist_Thist != []):
        memberhist = filelist_Thist[0].rsplit("/",1)[1].split("_")[4]
    membermask = 'r?i1p1f?'
    filelist_Tscen = glob.glob('Series_'+scenario+'_Amon_tas_2015-2100/'+model+'*_'+membermask+'_*.nc')
    filelist_Tscen.sort()
    if (filelist_Tscen != []):
        memberscen = filelist_Tscen[0].rsplit("/",1)[1].split("_")[4]

    filelist_Shist = glob.glob('Series_historical_LImon_'+variable+'_1850-2014/'+model+'*_'+memberhist+'_*.nc')
    filelist_Sscen = glob.glob('Series_'+scenario+'_LImon_'+variable+'_2015-2100/'+model+'*_'+memberscen+'_*.nc')

    if ( filelist_Tscen != [] ) and ( filelist_Shist != [] ) and ( filelist_Sscen != [] ): 

        print("---------",imod,model)
        selection.append({"model":model,"memberhist":memberhist,"memberscen":memberscen})

        ficThist = filelist_Thist[0]
        ficTscen = filelist_Tscen[0]
        ficShist = filelist_Shist[0]
        ficSscen = filelist_Sscen[0]

        varname = 'tas'
        f = netCDF4.Dataset(ficThist)
        spval = f.variables[varname].missing_value
        Thist = f.variables[varname][:]
        tname = f.variables[varname].dimensions[0]
        time = f.variables[tname][:]
        nthist = time.shape[0]
        t_unit = f.variables[tname].units
        t_cal = f.variables[tname].calendar
        tvalue = netCDF4.num2date(time,units = t_unit,calendar = t_cal)
        yearshist = np.empty((nthist),np.float)
        monthshist = np.empty((nthist),np.float)
        for it in range(nthist):
            yearshist[it] = tvalue[it].year
            monthshist[it] = tvalue[it].month
        itrefbeg = np.argmax(yearshist >= Ybegref)
        itrefend = nthist - np.argmax(yearshist[::-1] <= Yendref)
        f.close()

        f = netCDF4.Dataset(ficTscen)
        Tscen = f.variables[varname][:]
        tname = f.variables[varname].dimensions[0]
        time = f.variables[tname][:]
        ntscen = time.shape[0]
        t_unit = f.variables[tname].units
        t_cal = f.variables[tname].calendar
        tvalue = netCDF4.num2date(time,units = t_unit,calendar = t_cal)
        monthsscen = np.empty((ntscen),np.float)
        yearsscen = np.empty((ntscen),np.float)
        for it in range(ntscen):
            yearsscen[it] = tvalue[it].year
            monthsscen[it] = tvalue[it].month
        f.close()

        f = netCDF4.Dataset(ficShist)
        Shist = f.variables[variable][:]
        f.close()

        f = netCDF4.Dataset(ficSscen)
        Sscen = f.variables[variable][:]
        f.close()

        nt = nthist + ntscen
        T = np.empty((nt),np.float)
        T[0:nthist] = Thist[0:nthist]
        T[nthist:nt] = Tscen[0:ntscen]
        S = np.empty((nt),np.float)
        S[0:nthist] = Shist[0:nthist]
        # cas special scenario NorESM2-LM qui commence en fevrier 2015...
        if (len(Sscen) == ntscen-1):
           vartmp = np.zeros((len(Sscen)),np.float)
           vartmp[:] = Sscen[:]
           Sscen = np.zeros((ntscen),np.float)
           Sscen[0] = vartmp[11]
           Sscen[1:] = vartmp[0:]
        S[nthist:nt] = Sscen[0:ntscen]
        month = np.empty((nt),np.int)
        month[0:nthist] = monthshist[0:nthist]
        month[nthist:nt] = monthsscen[0:ntscen]
        year = np.empty((nt),np.int)
        year[0:nthist] = yearshist[0:nthist]
        year[nthist:nt] = yearsscen[0:ntscen]

        Tref = np.average(T[itrefbeg:itrefend])
        dT = np.empty((nt),np.float)
        dT[:] = T[:] - Tref
        dTave = np.empty((nt),np.float)
        for it in range(int(nyrave/2.*mpy),nt-int(nyrave/2.*mpy)):
            dTave[it] = np.average(dT[it-int(nyrave/2.*mpy):it+int(nyrave/2.*mpy)])
        dTave[0:int(nyrave/2.*mpy)] = dTave[int(nyrave/2.*mpy)]
        dTave[nt-int(nyrave/2.*mpy):nt] = dTave[nt-int(nyrave/2.*mpy)-1]

        Sbin = np.zeros((nbin,mpy),np.float32)
        nSbin = np.zeros((nbin,mpy),np.int)

        ny = int(nt/mpy)
        S2d = np.reshape(S, (ny,mpy))

        for it in range(nt):
            im = month[it]-1; iy = year[it]-year[0]
            ibin = -1
            for ib in range(nbin):
                if ( dTave[it] > Tbinpost[ib] and dTave[it] <= Tbinpost[ib+1] ):
                    ibin = ib
            if ( ibin != -1 ):
                Sbin[ibin,im] += S2d[iy,im]
                nSbin[ibin,im] += 1
 
        for ibin in range(nbin):
            for im in range(mpy):
               if ( nSbin[ibin,im] > 0 ):
                   Sbin[ibin,im] /= nSbin[ibin,im]
               else:
                   Sbin[ibin,im] = spval

        themonths = np.arange(1,mpy+1,1)
        
        f = netCDF4.Dataset(variable+'bin/'+variable+'bin_'+model+'_historical+'+scenario+'.nc',mode='w',format='NETCDF4_CLASSIC')
        month_dim = f.createDimension('month', mpy)
        months = f.createVariable('month', np.float32, ('month',))
        months.units = 'months'
        months.long_name = 'month'
        Tbin_dim = f.createDimension('Tbin', nbin)
        Tbins = f.createVariable('Tbin', np.float32, ('Tbin',))
        Tbins.units = 'K'
        Tbins.long_name = 'temperature bin'
        Sbins = f.createVariable(variable+'bin',np.float32,('Tbin','month'))
        Sbins.units = 'km^2'
        Sbins.missing_value = spval
        months[:] = themonths[:]
        Tbins[:] = Tbin[:]
        Sbins[:,:] = Sbin[:,:]
        f.close()

print(selection)
