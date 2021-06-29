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

source = "prive" # commun ou prive

# experiments = [ 'historical' ]
experiments = [ 'ssp126', 'ssp245', 'ssp370', 'ssp585' ]

# variables = ['snwN60', 'sncN60']
variables = ['tas']

for iexp, experiment in enumerate(experiments):

    if ( experiment == 'historical'):
        Ybeg = 1850; Yend = 2014; MIP = 'CMIP'
    else:
        Ybeg = 2015; Yend = 2100; MIP = 'ScenarioMIP'

    for ivar, variable in enumerate(variables):

        print("{} {}".format(variable,experiment))

        variableCMIP = variable
        
        if (variable == 'snw') or (variable == 'snc'):
           table = 'LImon'
        if (variable == 'snwN60'):
           table = 'LImon'
           variableCMIP = 'snw'
        if (variable == 'sncN60'):
           table = 'LImon'
           variableCMIP = 'snc'
        if (variable == 'tas'):
           table = 'Amon'
        if (variable == 'tasCN30'):
           table = 'Amon'
           variableCMIP = 'tas'
        
        snwmax = 500.
        
        sncfois100 = "BCC-CSM2-MR BCC-ESM1 FGOALS-f3-L"
        taboo = ['MCM-UA-1-0', 'AWI-CM-1-1-MR', 'AWI-ESM-1-1-LR'] # MCM-UA-1-0 rotten
        
        racineMasques = "/home/gkrinner/CMIP6/masques"
        
        if (source == 'commun'):
            racineCMIP6 = "/bdd/CMIP6"
            filelist = glob.glob(racineCMIP6+"/"+MIP+"/*/*/"+experiment+"/*/"+table+"/"+variableCMIP+"/*/latest/*.nc")
        elif (source == 'prive'):
            racineCMIP6 = "/data/gkrinner/CMIP6"
            filelist = glob.glob(racineCMIP6+"/"+MIP+"/"+experiment+"/"+table+"/"+variableCMIP+"/*.nc")
            # filelist = glob.glob(racineCMIP6+"/"+MIP+"/"+experiment+"/"+table+"/"+variableCMIP+"/*MPI-ESM1-2-HR*.nc")
        
        mpy = 12
        
        outpath = "Series_"+experiment+"_"+table+"_"+variable+"_"+str(Ybeg)+"-"+str(Yend)
        if (not os.path.exists(outpath)):
            os.mkdir(outpath)
        
        models = []
        for ific,fichier in enumerate(filelist):
           model = fichier.rsplit("/",1)[1].split("_")[2]
           if (model not in models) and (model not in taboo):
               models.append(model)
        models.sort()
        
        print(models)
        
        nmod = len(models)
        
        for imod, model in enumerate(models):
        
            # if (model != "FGOALS-f3-L"):
            #     continue
        
            print("-------------\n")
            print("{}\n".format(model))
        
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
            print("Aire Terre : {}".format(aireterre))
            f.close()
        
            maskNH = np.zeros((nlat,nlon),np.float)
            maskNH30 = np.zeros((nlat,nlon),np.float)
            maskNH60 = np.zeros((nlat,nlon),np.float)
            for j in range(nlat):
                if ( lat[j] >= 0. ):
                    maskNH[j,:] = 1.
                if ( lat[j] >= 30. ):
                    maskNH30[j,:] = 1.
                if ( lat[j] >= 60. ):
                    maskNH60[j,:] = 1.
        
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
        
            listefics = []
            for fichier in filelist:
                if ("_"+model+"_" in fichier):
                    listefics.append(fichier)
            # sort members, filtrer
            memnumbers = []
            members1 = []
            for ific, fichier in enumerate(listefics):
                member = fichier.rsplit("/",1)[1].split("_")[4]
                if (member not in members1):
                    if ("p1f" in member):
                        members1.append(member)
                        memnumbers.append(int(member[1:].split('i')[0]))
            memnumbers.sort()
            members = []
            for i, imem in enumerate(memnumbers):
                for j, member in enumerate(members1):
                    if (int(member[1:].split('i')[0]) == imem):
                        # verifier que toutes les annees sont la:
                        listefics = []
                        for fichier in filelist:
                            if ("_"+model+"_" in fichier) and ("_"+member+"_" in fichier):
                                listefics.append(fichier)
                        yearOK = np.empty(int(Yend+1),np.bool)
                        yearOK[Ybeg:Yend+1] = False
                        for fichier in listefics:
                            datestr = fichier.rsplit("/",1)[1].rsplit("_",1)[1].rsplit(".nc",1)[0]
                            year1 = int(datestr[0:4]); year2 = int(datestr[7:11])
                            yearOK[year1:year2+1] = True
                        if all(yearOK[Ybeg:Yend+1]):
                            members.append(member)
            nmems = len(members)
        
            for imem, member in enumerate(members):
        
                print(member)
        
                listefics = []
                for fichier in filelist:
                    if ("_"+model+"_" in fichier) and ("_"+member+"_" in fichier):
                        listefics.append(fichier)
                # identifier dates, filtrer
                listefics2 = []
                for ficin in listefics:
                    datestr = ficin.rsplit("/",1)[1].rsplit("_",1)[1].rsplit(".nc",1)[0]
                    year1 = int(datestr[0:4]); year2 = int(datestr[7:11])
                    if ( year2 >= Ybeg ) and ( year1 <= Yend ):
                        listefics2.append(ficin)
                listefics2.sort()
            
                # ecrire le fichier de commandes (creation d un fichier concatene)
        
                tmppath = "tmp_"+variable+"_"+experiment+"/"
                if os.path.exists(tmppath):
                    shutil.rmtree(tmppath)
                os.mkdir(tmppath)
                tmpcmdname = "tmp_"+variable+"_"+experiment+".cmd"
                tmpcmd = open(tmpcmdname, "w")
                for ific,ficin in enumerate(listefics2):
                    tmpcmd.write("# echo {} \n".format(ficin.rsplit("/",1)[1]))
                    tmpcmd.write("cdo -selyear,`seq -s ',' "+str(Ybeg)+" 1 "+str(Yend)+"`  {} ".format(ficin)+tmppath+"tmp_x{}.nc 2>/dev/null \n".format(ific))
                tmpcmd.write("# echo ncrcat... \n")
                tmpcmd.write("ncrcat -O ") 
                for ific,ficin in enumerate(listefics2):
                    tmpcmd.write(tmppath+"tmp_x{}.nc ".format(ific))
                tmpcmd.write("-o "+tmppath+"tmp_x.nc 2>/dev/null")
                tmpcmd.close()
                os.system("bash "+tmpcmdname)
            
                # calculs... lire tmp/tmp_x.nc, faire le calcul... tout le tralala
            
                fichier = tmppath+"tmp_x.nc"
                ficin = netCDF4.Dataset(fichier)
                var = ficin.variables[variableCMIP][:,:,:]
                ntime = var.shape[0]
            
                # special treatments
                if (variable == "snc") or (variable == "snw"):
                    maskContNH = (1.-sftgif[:,:]/100.) * sftlf[:,:]/100. * maskNH[:,:]
                if (variable == "sncN60") or (variable == "snwN60"):
                    maskContNH60 = (1.-sftgif[:,:]/100.) * sftlf[:,:]/100. * maskNH60[:,:]
                if (variable == "snc") or (variable == "snw") or (variable == "sncN60") or (variable == "snwN60"):
                    for it in range(ntime):
                        var[it,:,:] = np.where( var[it,:,:] <= 10000, var[it,:,:], 0.)
                        var[it,:,:] = np.where( var[it,:,:] >= 0 , var[it,:,:], 0.)
                if (variable == "snc"):
                    if (model in sncfois100):
                        var *= 100.
                if ( variable == "snw"):
                    # for home-made ice sheets
                    var = np.clip(var, 0., snwmax)
                    if (experiment == 'historical'):
                        varmin = np.amin(var[ntime-5*mpy:,:,:],axis=0)
                    else:
                        varmin = np.amin(var[0:5*mpy,:,:],axis=0)
                    for it in range(ntime):
                        var[it,:,:] = np.where( varmin[:,:] > 10., 0., var[it,:,:])
                if (variable == "tasCN30"):
                    maskContN30 = (1.-sftgif[:,:]/100.) * sftlf[:,:]/100. * maskNH30[:,:]
                    aireContN30 = np.sum(areacella[:,:]*maskContN30[:,:])
            
                vart1d = np.zeros((ntime),np.float)
                vart = np.zeros((nlat,nlon),np.float)
            
                for it in range(ntime):
                    if (variable == "snc"):
                        vart[:,:] = var[it,:,:]/100. * maskContNH[:,:]
                        vart1d[it] = np.sum( vart[:,:]*areacella[:,:] ) / 1.e6
                    if (variable == "sncN60"):
                        vart[:,:] = var[it,:,:]/100. * maskContNH60[:,:]
                        vart1d[it] = np.sum( vart[:,:]*areacella[:,:] ) / 1.e6
                    elif (variable == "snw"):
                        vart[:,:] = var[it,:,:] * maskContNH[:,:]
                        vart1d[it] = np.sum( vart[:,:]*areacella[:,:] ) / 1.e12
                    elif (variable == "snwN60"):
                        vart[:,:] = var[it,:,:] * maskContNH60[:,:]
                        vart1d[it] = np.sum( vart[:,:]*areacella[:,:] ) / 1.e12
                    elif (variable == "tas"):
                        vart1d[it] = np.sum( var[it,:,:]*areacella[:,:] ) / aireterre
                    elif (variable == "tasCN30"):
                        vart[:,:] = var[it,:,:] * maskContN30[:,:]
                        vart1d[it] = np.sum( vart[:,:]*areacella[:,:] ) / aireContN30
        
                nyears = int(ntime/mpy)
        
                fileout = outpath+"/"+model+"_"+experiment+"_"+table+"_"+variable+"_"+member+"_"+str(Ybeg)+"-"+str(Yend)+".nc"
                ficout = netCDF4.Dataset(fileout,"w")
        
                for dname, the_dim in ficin.dimensions.items():
                    ficout.createDimension(dname, len(the_dim) if not the_dim.isunlimited() else None)
        
                # Copy variables
                for vname, varin in ficin.variables.items():
                    if (vname != variableCMIP):
                        outVar = ficout.createVariable(vname, varin.datatype, varin.dimensions)
                    else:
                        outVar = ficout.createVariable(vname, varin.datatype, varin.dimensions[0])
            
                    # Copy variable attributes
                    outVar.setncatts({k: varin.getncattr(k) for k in varin.ncattrs()})
            
                    if (vname != variableCMIP):
                        outVar[:] = varin[:]
                    else:
                        outVar[:] = vart1d[:]
        
                ficin.close()
                ficout.close()
                os.system("rm -f "+tmpcmdname)
        
        shutil.rmtree(tmppath)
