#===========================================================================
# Nicolas Jourdain, IGE-CNRS, Grenoble, France
# December 2019
#
# Used to plot maps of present-day Antarctic melt rates.
#
# Set the 'what' variable to choose which dataset to plot.
#
#===========================================================================
import matplotlib
matplotlib.use('pdf')
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr
from matplotlib.ticker import LogFormatterSciNotation
from matplotlib import cm
from matplotlib.colors import ListedColormap, LinearSegmentedColormap
import functions_nico as nico
import os

print('                              ')
print('      |||||||                 ')
print('      | @ @ |                 ')
print('      |  U  |                 ')
print('      |  -  |                 ')
print('       -----                  ')
print('                              ')

#===========================================================================

what = 'FESOM_PRES'          # 'OBS'               for Rignot et al. (2013), updated version
                             # 'NON_LOCAL'         for ISMIP6 non-local-MeanAnt
                             # 'NON_LOCAL_MAX_PIG' for ISMIP6 non-local-PIGL
                             # 'FESOM_PRES'        for Naughten et al. (2018): MMM-rcp85 over 2006-2015

filevars='vars_'+what+'.npz' # files in which variables have been saved (to be used by AR6 team)

#===========================================================================
# Local functions to handle symmetric-log color bars:

def symlog_transform(linthresh,linscale, a):
    """Inplace transformation."""
    linscale_adj = (linscale / (1.0 - np.e ** -1))
    with np.errstate(invalid="ignore"):
      masked = np.abs(a) > linthresh
    sign = np.sign(a[masked])
    log = (linscale_adj + np.log(np.abs(a[masked]) / linthresh))
    log *= sign * linthresh
    a[masked] = log
    a[~masked] *= linscale_adj
    return a

def symlog_inv_transform(linthresh,linscale, a):
    """Inverse inplace Transformation."""
    linscale_adj = (linscale / (1.0 - np.e ** -1))
    masked = np.abs(a) > (linthresh * linscale_adj)
    sign = np.sign(a[masked])
    exp = np.exp(sign * a[masked] / linthresh - linscale_adj)
    exp *= sign * linthresh
    a[masked] = exp
    a[~masked] /= linscale_adj
    return a

#===========================================================================

if os.path.exists(filevars):

  #-- Using .nz file (to be used by AR6 team)

  print('Reading ', filevars)
  npzfile = np.load(filevars)
  x=npzfile['x']  
  y=npzfile['y']  
  basnb=npzfile['basnb']  
  grounded_msk=npzfile['grounded_msk']  
  icesheet_msk=npzfile['icesheet_msk']  
  melt2=npzfile['melt2']  

else:

  #-- Recalculating variables from original netcdf files:

  homedir = os.path.expanduser("~")
  print(homedir)
  file_basin = homedir+'/XYLAR_ISMIP6_DATA/IMBIE2/basinNumbers_8km.nc'
  file_ice_shelves = homedir+'/XYLAR_ISMIP6_DATA/IMBIE2/ice_shelf_mask_bedmap2_8km.nc'
  if ( what == 'OBS' ):
    file_melt = homedir+'/XYLAR_ISMIP6_DATA/IMBIE2/Melt_Mouginot_8km.nc'
  elif ( what == 'FESOM_PRES' ):
    file_melt = homedir+'/DATA_NAUGHTEN/melt_FESOM_Naughten2018_rcp85_M.nc'
  else:
    file_melt = homedir+'/ISMIP6/melt_rates_'+what+'.nc'
  
  #-----
  print('Reading ', file_basin)
  ncB = xr.open_dataset(file_basin)
  x = ncB['x'].values[:]
  y = ncB['y'].values[:]
  basnb = ncB['basinNumber'].values[:,:]*1.e0
  
  #-----
  print('Reading ', file_melt)
  ncM = xr.open_dataset(file_melt)
  if ( what == 'OBS' ):
    melt = ncM['melt_actual'].values[:,:]
  elif ( what == 'FESOM_PRES' ):
    melt = np.mean( ncM['melt'].values[0:10,:,:], axis=0 )
  else:
    melt = ncM['melt_rate'].values[:,:]
  melt2=melt[:,:]*1.e0
  melt2[ melt2 == 0.e0 ] = np.nan 
 
  #-----
  print('Reading ', file_ice_shelves)
  ncISF = xr.open_dataset(file_ice_shelves)
  isfmsk = ncISF['isfmask'].values[:,:]*1.e0
  basnb [ isfmsk > 0.5 ] = np.nan
  isfmsk [isfmsk < 2.e0] = np.nan
  isfmsk = isfmsk*0.e0 + 1.e0
  grounded_msk = ncISF['isfmask'].values[:,:]*1.e0
  grounded_msk[ grounded_msk > 0.e0 ]= 1.e0    # 1 over ocean and ice shelves, 0 over grounded areas
  grounded_msk[ grounded_msk < 0.e0 ]= 0.e0    # 1 over ocean and ice shelves, 0 over grounded areas
  icesheet_msk = ncISF['isfmask'].values[:,:]*1.e0
  icesheet_msk[ icesheet_msk < 1.5 ]= 0.e0
  icesheet_msk[ icesheet_msk > 1.5 ]= 1.e0 # =1 over ice shelves, =0 elsewhere
   
  grounded_msk[ ~np.isnan(melt2) ]=1.e0  
  icesheet_msk[ ~np.isnan(melt2) ]=1.e0
  icesheet_msk[ np.isnan(melt2) ]=0.e0

  # save plot variables :
  np.savez(filevars,x=x, y=y, grounded_msk=grounded_msk, icesheet_msk=icesheet_msk, basnb=basnb, melt2=melt2) 

#============================================================================================
# Plotting the map:

fig, ax = plt.subplots()

# Customize colormap :
# NB: modify the Ncool to Nwarm ratio (total=256) to place zero as desired.
Ncool=86
Nwarm=256-Ncool
#------------------------------------------
# Defining IPCC colormap:
#LinL = np.loadtxt('IPCC_cryo_div.txt')
LinL = np.loadtxt('IPCC_cryo_div.txt')
LinL = LinL*0.01
#
b3=LinL[:,2] # value of blue at sample n
b2=LinL[:,2] # value of blue at sample n
b1=np.linspace(0,1,len(b2)) # position of sample n - ranges from 0 to 1
# setting up columns for list
g3=LinL[:,1]
g2=LinL[:,1]
g1=np.linspace(0,1,len(g2))
r3=LinL[:,0]
r2=LinL[:,0]
r1=np.linspace(0,1,len(r2))
# creating list
R=zip(r1,r2,r3)
G=zip(g1,g2,g3)
B=zip(b1,b2,b3)
# transposing list
RGB=zip(R,G,B)
rgb=zip(*RGB)
# print rgb
# creating dictionary
k=['red', 'green', 'blue']
LinearL=dict(zip(k,rgb)) # makes a dictionary from 2 lists
ipcc_cmap=matplotlib.colors.LinearSegmentedColormap('ipcc',LinearL,256)
#---------------------------------
# moving the zero of colorbar
cool = cm.get_cmap(ipcc_cmap, Ncool)
tmp1 = cool(np.linspace(0.70, 1.0, Ncool)) # decrease 0.70 to have more white in the middle light-blue colors
print(tmp1.shape)
warm = cm.get_cmap(ipcc_cmap, Nwarm)
tmp2 = warm(np.linspace(0.0, 0.25, Nwarm)) # increase 0.20 to have more white in the middle light-yellow colors
print(tmp2.shape)
newcolors = np.append(tmp1[::-1,:],tmp2[::-1,:],axis=0)
newcmp = ListedColormap(newcolors)

# extreme color range values and corresponding tick levels of the symmetric-log contourf levels:
minval=-5.0
maxval=135.0
lin_threshold=1.0
lin_scale=1.0
[min_exp,max_exp]=symlog_transform(lin_threshold,lin_scale,np.array([minval,maxval]))
lev_exp = np.arange( np.floor(min_exp),  np.ceil(max_exp)+1 )
levs = symlog_inv_transform(lin_threshold,lin_scale,lev_exp)
levs = nico.sigdigit(levs,2)

cax=ax.contourf(x*1.e-3,y*1.e-3,melt2,levs,cmap=newcmp,norm=matplotlib.colors.SymLogNorm(linthresh=lin_threshold, linscale=lin_scale,vmin=minval, vmax=maxval),zorder=0)
ax.contour(x*1.e-3,y*1.e-3,basnb,np.linspace(0.5,20.5,21),linewidths=0.5,colors='gray',zorder=5)
ax.contour(x*1.e-3,y*1.e-3,grounded_msk,linewidths=0.5,colors='black',zorder=10)
ax.contour(x*1.e-3,y*1.e-3,icesheet_msk,linewidths=0.5,colors='black',zorder=15)
# Zoom on Amundsen:
zoomfac=2.85
xll_ori = -2000.0
yll_ori =  -900.0
xur_ori = -1450.0
yur_ori =  -150.0
xll_des =   -50.0
yll_des =  -500.0
xur_des = xll_des + zoomfac * (xur_ori-xll_ori)
yur_des = yll_des + zoomfac * (yur_ori-yll_ori)
ax.plot([xll_ori, xur_ori, xur_ori, xll_ori, xll_ori],[yll_ori, yll_ori, yur_ori, yur_ori, yll_ori],'k',linewidth=0.6,zorder=20)
ax.fill([xll_des, xur_des, xur_des, xll_des, xll_des],[yll_des, yll_des, yur_des, yur_des, yll_des],'w',edgecolor='k',zorder=25)
i1=np.argmin(np.abs(x*1.e-3-xll_ori))
i2=np.argmin(np.abs(x*1.e-3-xur_ori))+1
j1=np.argmin(np.abs(y*1.e-3-yll_ori))
j2=np.argmin(np.abs(y*1.e-3-yur_ori))+1
xzoom= xll_des + zoomfac * (x*1.e-3-xll_ori)
yzoom= yll_des + zoomfac * (y*1.e-3-yll_ori)
print([i1, i2, j1, j2])
print(np.shape(melt2), np.shape(xzoom))
ax.contourf(xzoom[i1:i2],yzoom[j1:j2],melt2[j1:j2,i1:i2],levs,cmap=newcmp,norm=matplotlib.colors.SymLogNorm(linthresh=lin_threshold, linscale=lin_scale,vmin=minval, vmax=maxval),zorder=30)
ax.contour(xzoom[i1:i2],yzoom[j1:j2],basnb[j1:j2,i1:i2],np.linspace(0.5,20.5,21),linewidths=0.5,colors='gray',zorder=32)
ax.contour(xzoom[i1:i2],yzoom[j1:j2],grounded_msk[j1:j2,i1:i2],linewidths=0.5,colors='black',zorder=35)
ax.contour(xzoom[i1:i2],yzoom[j1:j2],icesheet_msk[j1:j2,i1:i2],linewidths=0.5,colors='black',zorder=40)
ax.plot([xll_des, xur_des, xur_des, xll_des, xll_des],[yll_des, yll_des, yur_des, yur_des, yll_des],'k',linewidth=1.0,zorder=45)

#-----

ratio=1.00
ax.set_aspect(1.0/ax.get_data_ratio()*ratio)

# colorbar :
formatter = LogFormatterSciNotation(10, labelOnlyBase=False, minor_thresholds=(np.inf, np.inf)) # "(np.inf, np.inf)" so that all ticks will be labeled 
cbar = fig.colorbar(cax, format=formatter, fraction=0.035, pad=0.02, ticks=levs)
cbar.ax.set_title('m/yr',size=8)
cbar.outline.set_linewidth(0.3)
cbar.ax.tick_params(labelsize=6,which='both')

#-----

ax.set_xlim(-2800,2800)
ax.set_ylim(-2300,2300)

if ( what == 'OBS' ):
  title="Observational estimate (Rignot et al. 2013)"
elif ( what == 'NON_LOCAL' ):
  title="ISMIP6 non-local-MeanAnt (Jourdain et al. 2020)"
elif ( what == 'NON_LOCAL_MAX_PIG' ):
  title="ISMIP6 non-local-PIGL (Jourdain et al. 2020)"
elif ( what == 'FESOM_PRES' ):
  title="FESOM-MMM-rcp85 (Naughten et al. 2018)"
else:
  title=what
ax.set_title(title,size=9)

ax.set_ylabel('y (km)',size=7)
ax.set_xlabel('x (km)',size=7)
ax.tick_params(labelsize=7)

#-----

namefig='../PNGs/map_melt_AR6_pres_'+what+'.pdf'
fig.savefig(namefig)

