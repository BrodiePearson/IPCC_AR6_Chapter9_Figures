#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import glob
import os
import sys
import shutil
import netCDF4
import numpy as np
from scipy import stats
import re

Ybeg = 1981; Yend = 2014
snwmax = 500.
variable = "snc"

sncfois100 = "BCC-CSM2-MR BCC-ESM1 FGOALS-f3-L FGOALS-g3 CAS-ESM2-0"
# taboo = 'MPI-ESM1-2-LR' # not all files there for any scenario (on Nov 28, 2019)
# taboo = 'IPSL-CM5A2-INCA CanESM5-CanOE GISS-E2-1-G-CC NorESM2-MM MPI-ESM-1-2-HAM EC-Earth3-Veg EC-Earth3-Veg-LR' # incomplete historicals
taboo = 'IPSL-CM5A2-INCA'

# modelrestrict = ['BCC-CSM2-MR', 'CanESM5', 'CESM2', 'CESM2-WACCM', 'CNRM-CM6-1', 'CNRM-ESM2-1', 'EC-Earth3', 'EC-Earth3-Veg',
#                  'FGOALS-f3-L', 'GFDL-ESM4', 'GFDL-CM4', 'GISS-E2-1-G', 'GISS-E2-1-H', 'HadGEM3-GC31-LL', 'IPSL-CM6A-LR',
#                  'MIROC6', 'MIROC-ES2L', 'MPI-ESM1-2-HR', 'MRI-ESM2-0', 'NorESM2-LM', 'UKESM1-0-LL' ]
modelrestrict = []

if (modelrestrict != []):
    print()
    print(" ATTENTION ! On utilise un ensemble pre-contraint")
    print("=================================================")
    print()

racineCMIP6 = "/bdd/CMIP6"
racineMasques = "/home/gkrinner/CMIP6/masques"

mpy = 12

filelist = glob.glob(racineCMIP6+"/CMIP/*/*/historical/*/LImon/"+variable+"/*/latest/*.nc")
# filelist = glob.glob(racineCMIP6+"/CMIP/*/CNRM-CM6-1/historical/*/LImon/"+variable+"/*/latest/*.nc")

models = []
for ific,fichier in enumerate(filelist):
   model = fichier.rsplit("/",1)[1].split("_")[2]
   if (model not in models) and (model not in taboo):
       if (modelrestrict != []):
          if ( model in modelrestrict):
              models.append(model)
       else:
          models.append(model)

print(models)

nmod = len(models)
snowtrend = np.empty((mpy,nmod),np.float)
snowclim = np.empty((mpy,nmod),np.float)
complete = np.empty((nmod),np.bool)

for imod, model in enumerate(models):

    # print("-------------\n")
    # print("{}\n".format(model))

    # masques...

    champ = 'areacella'
    fichier = glob.glob(racineMasques+'/'+champ+'/'+champ+'_'+model+'.nc')
    if (fichier == []):
        fichier = glob.glob(racineMasques+'/pseudo_'+champ+'/'+champ+'_'+model+'.nc')
    if (fichier == []):
        print("Il manque {} pour {} !".format(champ,model))
        quit()
    f = netCDF4.Dataset(fichier[0])
    lonname = f.variables[champ].dimensions[1]
    # print('longitude:'+lonname)
    lon = f.variables[lonname][:]
    nlon = lon.size
    latname = f.variables[champ].dimensions[0]
    # print('latitude:'+latname)
    lat = f.variables[latname][:]
    nlat = f.variables[latname].size
    areacella = f.variables[champ][:,:]
    aireterre = np.sum(areacella)
    # print("Aire Terre : {}".format(aireterre))
    f.close()

    maskNH = np.zeros((nlat,nlon),np.float)
    for j in range(nlat):
        if ( lat[j] >= 0. ):
            maskNH[j,:] = 1.

    champ = 'sftlf'
    fichier = glob.glob(racineMasques+'/'+champ+'/'+champ+'_'+model+'.nc')
    if (fichier == []):
        fichier = glob.glob(racineMasques+'/pseudo_'+champ+'/'+champ+'_'+model+'.nc')
    if (fichier == []):
        print("Il manque {} pour {} !".format(champ,model))
        quit()
    f = netCDF4.Dataset(fichier[0])
    sftlf = f.variables[champ][:,:]
    f.close()

    champ = 'sftgif'
    fichier = glob.glob(racineMasques+'/'+champ+'/'+champ+'_'+model+'.nc')
    if (fichier == []):
        fichier = glob.glob(racineMasques+'/pseudo_'+champ+'/'+champ+'_'+model+'.nc')
    if (fichier == []):
        print("Il manque {} pour {} !".format(champ,model))
        quit()
    f = netCDF4.Dataset(fichier[0])
    sftgif = f.variables[champ][:,:]
    f.close()

    liste_hist = []
    for fichier in filelist:
        if ("_"+model+"_" in fichier):
            liste_hist.append(fichier)
    # sort members, filtrer
    histmemnumbers = []
    histmembers1 = []
    for ific, fichier in enumerate(liste_hist):
        member = fichier.split("/")[7] 
        if (member not in histmembers1):
            if ("p1f" in member):
                histmembers1.append(member)
                histmemnumbers.append(int(member[1:].split('i')[0]))
    histmemnumbers.sort()
    histmembers = []
    for i, imem in enumerate(histmemnumbers):
        for j, member in enumerate(histmembers1):
            if (int(member[1:].split('i')[0]) == imem):
                # verifier que toutes les annees sont la:
                liste_hist = []
                for fichier in filelist:
                    if ("_"+model+"_" in fichier) and (member in fichier):
                        liste_hist.append(fichier)
                yearOK = np.empty(int(Yend+1),np.bool)
                yearOK[Ybeg:Yend+1] = False
                for fichier in liste_hist:
                    datestr = fichier.rsplit("/",1)[1].rsplit("_",1)[1].rsplit(".nc",1)[0]
                    year1 = int(datestr[0:4]); year2 = int(datestr[7:11])
                    yearOK[year1:year2+1] = True
                if all(yearOK[Ybeg:Yend+1]):
                    histmembers.append(member)
    nhist = len(histmembers)

    print(model,nhist)

    if (nhist == 0):
        print("Aucun membre complet!")
        complete[imod] = False        
        continue
    else:
        complete[imod] = True

    snowclimmem = np.empty((mpy,nhist),np.float) 
    snowtrendmem = np.empty((mpy,nhist),np.float) 

    for ihist, histmember in enumerate(histmembers):

        liste_hist = []
        for fichier in filelist:
            if ("_"+model+"_" in fichier) and (histmember in fichier):
                liste_hist.append(fichier)
        # identifier dates, filtrer
        liste_hist2 = []
        for ficin in liste_hist:
            datestr = ficin.rsplit("/",1)[1].rsplit("_",1)[1].rsplit(".nc",1)[0]
            year1 = int(datestr[0:4]); year2 = int(datestr[7:11])
            if ( year2 >= Ybeg ) and ( year1 <= Yend ):
                liste_hist2.append(ficin)
        liste_hist2.sort()
    
        # ecrire le fichier de commandes (creation d un fichier concatene)
    
        tmppath = "tmp/"
        if os.path.exists(tmppath):
            shutil.rmtree(tmppath)
        os.mkdir(tmppath)
        tmpcmd = open("tmp.cmd", "w")
        for ific,ficin in enumerate(liste_hist2):
            tmpcmd.write("# echo {} \n".format(ficin.rsplit("/",1)[1]))
            tmpcmd.write("cdo -selyear,`seq -s ',' "+str(Ybeg)+" 1 "+str(Yend)+"`  {} ".format(ficin)+tmppath+"tmp_x{}.nc 2>/dev/null \n".format(ific))
        tmpcmd.write("# echo ncrcat... \n")
        tmpcmd.write("ncrcat -O ") 
        for ific,ficin in enumerate(liste_hist2):
            tmpcmd.write(tmppath+"tmp_x{}.nc ".format(ific))
        tmpcmd.write("-o "+tmppath+"tmp_x.nc 2>/dev/null")
        tmpcmd.close()
        os.system("bash tmp.cmd")
    
        # calculs... lire tmp/tmp_x.nc, faire le calcul... tout le tralala
    
        fichier = tmppath+"tmp_x.nc"
        f = netCDF4.Dataset(fichier)
        snow = f.variables[variable][:,:,:]
        f.close()
        ntime = snow.shape[0]
    
        # special treatments
        snow = np.where( snow <= 10000, snow, 0.)
        snow = np.where( snow >= 0 , snow, 0.)
        if (variable == "snc") and (model in sncfois100):
            snow *= 100.
        # for home-made ice sheets
        if ( variable == "snw"):
            snow = np.clip(snow, 0., snwmax)
            snowmin = np.amin(snow[0:5*mpy,:,:],axis=0)
            for it in range(ntime):
                snow[it,:,:] = np.where( snowmin[:,:] > 10., 0., snow[it,:,:])
    
        snowNHt1d = np.zeros((ntime),np.float)
        snowNH = np.zeros((nlat,nlon),np.float)
    
        mask = (1.-sftgif[:,:]/100.) * sftlf[:,:]/100. * maskNH[:,:]
        for it in range(ntime):
            if (variable == "snc"):
                snowNH[:,:] = snow[it,:,:]/100. * mask[:,:]
                snowNHt1d[it] = np.sum( snowNH[:,:]*areacella[:,:] ) / 1.e6
            elif (variable == "snw"):
                snowNH[:,:] = snow[it,:,:] * mask[:,:]
                snowNHt1d[it] = np.sum( snowNH[:,:]*areacella[:,:] ) / 1.e12

        nyears = int(ntime/mpy)
        snowNHt2d = np.reshape(snowNHt1d,(nyears,mpy))
        if (ihist == 0):
            print("{} : Maximum neige (member 1): {}".format(histmember,np.amax(snowNHt2d)))

        for imon in range(mpy):
            snowclimmem[imon,ihist] = np.average(snowNHt2d[:,imon])
            snowtrendmem[imon,ihist], intercept, r_value, p_value, std_err = stats.linregress(np.arange(float(nyears)),snowNHt2d[:,imon]) 

    for imon in range(mpy):
        snowclim[imon,imod] = snowclimmem[imon,0]
        snowtrend[imon,imod] = np.median(snowtrendmem[imon,:])

text_file = open(variable+'_trends_CMIP6_historical_'+str(Ybeg)+'-'+str(Yend)+'.txt', 'w')

for imod in range(nmod):
    if (complete[imod]):
        text_file.write('{} '.format(models[imod]))
text_file.write('\n')
for imon in range(mpy):
    for imod in range(nmod):
        if (complete[imod]):
            text_file.write('{} '.format(snowtrend[imon,imod]))
    if (complete[imod]):
        text_file.write('\n')
text_file.close()

text_file = open(variable+'_clim_CMIP6_historical_'+str(Ybeg)+'-'+str(Yend)+'.txt', 'w')

for imod in range(nmod):
    if (complete[imod]):
        text_file.write('{} '.format(models[imod]))
    for imon in range(mpy):
        if (complete[imod]):
            text_file.write('{} '.format(snowclim[imon,imod]))
    if (complete[imod]):
        text_file.write('\n')

text_file.close()
