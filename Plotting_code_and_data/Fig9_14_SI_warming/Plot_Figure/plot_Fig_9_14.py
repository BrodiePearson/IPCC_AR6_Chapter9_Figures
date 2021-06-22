# This script plots Figure 1 of the SIMIP paper draft. It reads the model data from mat files,
# and the Observations (SIA from netCDF, GSAT from XLSX) and the CO2 data from npy files.

# Author: Jakob Doerr (jakob.doerr@mpimet.mpg.de, jakob.dorr@uib.no, jakobdoerr@googlemail.com)
# Date: 18.03.2021
import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat
from netCDF4 import Dataset,num2date
import matplotlib.patches as patches
import pandas as pd

cmip = 'CMIP6'
hemisphere = 'nh'

end_hist = 2014 # the final year of the historical scenario
scenarios = ['historical','ssp585','ssp245','ssp126']


# create the time vectors
# model time
years = {'historical':np.arange(1950,end_hist+1),'ssp126':np.arange(2015,2100),
         'ssp245':np.arange(2015,2100),'ssp585':np.arange(2015,2100), 'rcp26':np.arange(2006,2100),
        'rcp85':np.arange(2006,2100),'rcp45':np.arange(2006,2100)}
# observations time
obs_years = np.arange(1979,2019)

# colors for the scenarios (from https://pyam-iamc.readthedocs.io/en/latest/tutorials/ipcc_colors.html)
colors = {'historical':'grey','ssp245':[234/255, 221/255, 61/255],'ssp126':'#003466', 'ssp585':'#990002',
         'rcp85':'#990002','rcp45':'#5492CD','rcp26':(0,52/255,102/255),'CMIP5':[204/255, 35/255, 35/255],'CMIP6':[37/255, 81/255, 204/255],'CMIP3':[30/255,150/255,132/255]}
letters = ['a)','b)','c)','d)','e)','f)','g)','h)']
ylabels = {'sia_co2':'d(Sept. sea-ice area)/dCO2 (m$^2$/t)','sia_mar_co2':'d(March sea-ice area)/dCO2 (m$^2$/t)',
           'gmst_co2':'d(Surf. temp.)/dCO2 \n(°C/1000Gt)'}
month_names = {3:'March',9:'September'}
names = {'historical':'Historical','ssp126':'SSP1-2.6','ssp245':'SSP2-4.5','ssp585':'SSP5-8.5','rcp45':'RCP45','rcp85':'RCP85'}
# ----------------------------------------------------------------------------------------------------
## Step 1: Read in the relevant data
# ---------------------------------------------------------------------------------------------------

# cmip6 data
# the data is stored in mat files, which contain data arrays with the dimensions (simulation, years, months)
# for SIA, SIV and GMST (no month dimension for GMST)
# the simulation dimension has an entry for every model member and the list of simulations is also stored in 
# the mat file, in the format 'MODEL-NAME_r*i1p1f*'

# determine the models which have SIA or GMST for any scenario. Later, once a model has no data, it will
# not be drawn in the figure (because of NaNs)
modellist = []
for scenario in scenarios:
    data = loadmat('data/'+cmip+'_'+scenario+'_'+hemisphere+'.mat')
    m_list = list(set([i[0:i.find('_')] for i in data['Simulation_names']]))
    modellist = np.concatenate([modellist,m_list])
modellist = list(sorted(set(modellist)))
print(modellist)

# create data arrays 
sia_cmip6 = {3:{},9:{}} # march and september for SIA and SIV
siv_cmip6 = {3:{},9:{}}
gmst_cmip6 = {} # yearly for GMST

# Start reading in the model data and pick the first member of every model
for scenario in scenarios:
    print(scenario)
    #Initialize data arrays:
    for month in [3,9]:
        sia_cmip6[month][scenario] = np.zeros((len(modellist),len(years[scenario])))
        siv_cmip6[month][scenario] = np.zeros((len(modellist),len(years[scenario])))
    gmst_cmip6[scenario] = np.zeros((len(modellist),len(years[scenario])))  
    
    # read in data
    raw_data = loadmat('data/'+cmip+'_'+scenario+'_'+hemisphere+'.mat')
    raw_years = raw_data['Years'][0]
    simulations = raw_data['Simulation_names']
    
    # create an index array which maps the years of the scenario in this script to the years in 
    # the scenario in the .mat data.
    year_idx = np.where(np.isin(raw_years,years[scenario]))[0]
    # create an index array for the control period, to be able to compute GMST anomalies
    control_idx = np.where(np.isin(raw_years,np.arange(1850,1900)))[0] 
    
    # sort data to data arrays and select first member
    for i,model in enumerate(modellist):
        index = np.asarray([j for j in range(len(simulations)) if model+'_' in simulations[j]])
        if len(index) > 0: # if there is data for this model in the mat file
            # sia, siv
            for month in [3,9]:
                # sia
                curr_data = raw_data['sia_'+hemisphere][index,:,month-1]
                sia_cmip6[month][scenario][i,:] = curr_data[0,year_idx]
                #sia_cmip6[month][scenario][i,:] = np.nanmean(curr_data[:,year_idx],0)
              
            # gmst (calculate anomalies) 
            curr_data = raw_data['gmst'][index,:]
            gmst_cmip6[scenario][i,:] = curr_data[0,year_idx] - np.nanmean(curr_data[0,control_idx])
            #gmst_cmip6[scenario][i,:] = np.nanmean(curr_data[:,year_idx] - np.nanmean(curr_data[:,control_idx]),0)
        else: # if there is no data, fill with NaNs
            for month in [3,9]:
                sia_cmip6[month][scenario][i,:] *= np.nan
            gmst_cmip6[scenario][i,:] *= np.nan
# ----------------------------------
# observations of SIA, take mean over several
# the observations are saved in npy files
obs_names = ['osisaf','nsidc_nt','nsidc_bt']

data = Dataset('data/SeaIceArea__NorthernHemisphere__monthly__UHH__v2019_fv0.01.nc')
t = data.variables['time']
obs_time = [a.year for a in num2date(t[:],t.units,t.calendar)][0::12]
obs_sia = {}
for month in [2,8]:
    obs_data = np.nanmean([data.variables[obs_name][month::12] for obs_name in obs_names],0)
    obs_std = np.nanstd([data.variables[obs_name][month::12] for obs_name in obs_names],0)
    obs_sia[month+1] = np.zeros(len(obs_years))*np.nan
    # map the data to the correct years
    obs_sia[month+1][np.isin(obs_years,obs_time)] = obs_data[np.isin(obs_time,obs_years)]
    
# -------------------------------
# GSAT observations
gsat_file = pd.read_excel('./data/IPCC_GSAT.xlsx')
raw_years = np.array(gsat_file['Provisional time series for use in GSAT '][8:-2])
obs_data = np.array(gsat_file['Unnamed: 11'][8:-2])
obs_gmst = np.zeros(len(obs_years))*np.nan
obs_gmst[np.isin(obs_years,raw_years)] = obs_data[np.isin(raw_years,obs_years)]
# --------------------
# read in the cumulative co2 emissions for the simulations and for the observations
# they are also stored in npy files
# for the historical period until 2017, emissions are taken from the Carbon Budget 2018 
# (https://www.earth-syst-sci-data.net/10/2141/2018/)
# for the scenarios, CMIP6 co2 data is taken from the Input4MIP emissions data 
# (https://tntcat.iiasa.ac.at/SspDb/dsd?Action=htmlpage&page=welcome)
co2 = {}
data = np.load('data/CO2_'+cmip+'.npy',allow_pickle=True)
for scenario in scenarios:   
    co2data = data[scenario][1,:]
    co2years = data[scenario][0,:]
    co2[scenario] = co2data[np.isin(co2years,years[scenario])]
    # for the co2 emissions in the period of observations, use emissions data for ssp245, 
    # because observed co2 emissions only go until 2017 (but sia and gmst observations until 2018)
    if scenario == 'ssp245':
        # co2 data for observations
        obs_co2 = co2data[np.isin(co2years,obs_years)]
        ## co2 for satellite historical period (1979-2014)
        hist_co2 = co2data[np.isin(co2years,np.arange(1979,2015))]

        
# end of data read in 
# ------------------------------------------------------------------------------------------
# plot 
fig = plt.figure(figsize=(8,6.5))

# draw SIA vs GMST for March and September
for m,month in enumerate([3,9]):
    ax = plt.subplot(2,4,m*4+1)
    ax.text(-0.22,1.02,letters[m*4],fontsize=12,transform=plt.gca().transAxes)
    for scenario in scenarios:
        for i,model in enumerate(modellist):
            ax.plot(gmst_cmip6[scenario][i,:],sia_cmip6[month][scenario][i,:],
                    color=colors[scenario],marker='.',alpha=0.1,linestyle='',markersize=1.414)
            
        # try to draw a 'model mean' and a shading around the data, which is difficult,
        # since both GMST and SIA are varying between models
        # to do so, bin the data in GMST bins and compute mean and STD for every GMST bin 
        if scenario == 'historical':
            bins = np.linspace(np.nanpercentile(gmst_cmip6[scenario],5),min(np.nanpercentile(gmst_cmip6[scenario][:,-5::],95),5),15)
        else:
            bins = np.linspace(np.nanpercentile(gmst_cmip6[scenario],5),min(np.nanpercentile(gmst_cmip6[scenario][:,-5::],50),5),15)
        binned_index = np.digitize(gmst_cmip6[scenario],bins)
        binned_gmst_mean = np.asarray([np.nanmean(gmst_cmip6[scenario][binned_index == i]) 
                                       for i in range(1, len(bins)) if len(binned_index[binned_index == i])> 30])
        binned_sia_mean = np.asarray([np.nanmean(sia_cmip6[month][scenario][binned_index == i]) 
                                      for i in range(1, len(bins)) if len(binned_index[binned_index == i])> 30])
        binned_sia_std = [np.nanstd(sia_cmip6[month][scenario][binned_index == i]) 
                          for i in range(1, len(bins)) if len(binned_index[binned_index == i])> 30]
        # bin mean
        ax.plot(binned_gmst_mean,binned_sia_mean,color=colors[scenario],linewidth=2,label=scenario,zorder=50)
        lower_bound = np.max([binned_sia_mean*0,binned_sia_mean-binned_sia_std],0)
        upper_bound = binned_sia_mean+binned_sia_std
        # bin shading
        ax.fill_between(binned_gmst_mean,lower_bound,upper_bound,facecolor=colors[scenario],alpha=0.3)
        
    # finally, add observations to the plot
    ax.scatter(obs_gmst,obs_sia[month],color='k',s=4,zorder=100)   
    # add 1 million km² line for ice-free threshold
    if month == 9:
        plt.plot([0,10],[1,1],linestyle='--',color='k',linewidth=0.5)
    ax.set_ylabel(month_names[month]+' sea-ice area (million km$^2$)')
    ax.set_xlim(0,5)
    ax.set_ylim(bottom=0)
    ax.spines['right'].set_color('none')
    ax.spines['top'].set_color('none')

ax.set_xlabel('Temp. anomaly (°C)')

 
# draw SIA vs CO2 emissions
for m,month in enumerate([3,9]):
    plt.subplot(2,4,m*4+2)
    plt.text(-0.22,1.02,letters[m*4+1],fontsize=12,transform=plt.gca().transAxes)
    for scenario in scenarios:
        for i,model in enumerate(modellist):
            plt.plot(co2[scenario],sia_cmip6[month][scenario][i,:],color=colors[scenario],
                     marker='.',alpha=0.1,linestyle='',markersize=1.414)
        # multi-model mean
        plt.plot(co2[scenario],np.nanmean(sia_cmip6[month][scenario],0),color=colors[scenario],linewidth=2,label=names[scenario],zorder=50)
        # shading around mean
        plt.fill_between(co2[scenario],np.nanmean(sia_cmip6[month][scenario],0)-np.nanstd(sia_cmip6[month][scenario],0),
                         np.nanmean(sia_cmip6[month][scenario],0)+np.nanstd(sia_cmip6[month][scenario],0),facecolor=colors[scenario],
                        alpha=0.3)
    # observations
    plt.plot(obs_co2,obs_sia[month],color='k',linestyle='',marker='o',markersize=np.sqrt(4),label='Observations',zorder=100) 
    # add 1 million km² line for ice-free threshold
    if month == 9:
        plt.plot([0,10000],[1,1],linestyle='--',color='k',linewidth=0.5)
    plt.ylabel(month_names[month]+' sea-ice area (million km$^2$)')
    plt.ylim(bottom=0)
    plt.xlim(0,10000)
    plt.gca().spines['right'].set_color('none')
    plt.gca().spines['top'].set_color('none')
plt.xlabel('Cum. CO2 emissions (Gt)')    
lgd = plt.legend(frameon=False,labelspacing=0.2,markerscale=0,loc='upper right',bbox_to_anchor=[1.24,1,0,0])
for item in lgd.legendHandles:
    item.set_visible(False)
# set colors of legend
for i,text in enumerate(lgd.get_texts()):
    plt.setp(text, color = lgd.legendHandles[i].get_c()) 
    
# draw SIA vs time
for m,month in enumerate([3,9]):
    ax = plt.subplot(2,4,m*4+3)
    ax.text(-0.22,1.02,letters[m*4+2],fontsize=12,transform=plt.gca().transAxes)
    #ax_lines = plt.subplot(2,20,14+m)
    for j,scenario in enumerate(scenarios):
        for i,model in enumerate(modellist):
            ax.plot(years[scenario],sia_cmip6[month][scenario][i,:],color=colors[scenario],
                    marker='.',alpha=0.1,linestyle='',markersize=1.414)
        # multi-model mean
        ax.plot(years[scenario],np.nanmean(sia_cmip6[month][scenario],0),color=colors[scenario],linewidth=2,zorder=50)
        lower_bound = np.nanmean(sia_cmip6[month][scenario],0)-np.nanstd(sia_cmip6[month][scenario],0)
        upper_bound = np.nanmean(sia_cmip6[month][scenario],0)+np.nanstd(sia_cmip6[month][scenario],0)
        # shadig around mean
        ax.fill_between(years[scenario],lower_bound,upper_bound,facecolor=colors[scenario],alpha=0.3)
        
        # add vertical lines at the end for future scenarios
        if scenario != 'historical':
            rect = patches.Rectangle((2100+3*j,max(lower_bound[-1],0)),1,upper_bound[-1]-max(lower_bound[-1],0),
                                     edgecolor=colors[scenario],facecolor=colors[scenario],clip_on=False)
            ax.add_patch(rect)
    # observations
    ax.scatter(obs_years,obs_sia[month],color='k',s=4,zorder=100)
    # add 1 million km² line for ice-free threshold
    if month == 9:
        plt.plot([1950,2100],[1,1],linestyle='--',color='k',linewidth=0.5)
    ax.set_ylabel(month_names[month]+' sea-ice area (million km$^2$)')
    ax.set_ylim(bottom=0)
    ax.set_xlim(1950,2100)

    ax.spines['right'].set_color('none')
    ax.spines['top'].set_color('none')
ax.set_xlabel('Time')

# last two panels: dGMST/dCO2 vs dSIA/dCO2. First, read in those metrics
# for the cmips, and the observations
cmips = ['CMIP3','CMIP5','CMIP6']
for cmip in cmips:
    data[cmip] = np.load('data/'+cmip+'_sensitivity_'+hemisphere+'.npy',allow_pickle=True)
# observed sensitivities
obsdata = np.load('data/obs_sensitivity_'+hemisphere+'.npy',allow_pickle=True)

# plot function
def plot_fig4(metric1,metric2,letter,xlabel=False,yrange=None):
    plt.text(-0.2,1.02,letter,fontsize=12,transform=plt.gca().transAxes)
    i = 0
    for cmip in cmips:
        data1 = data[cmip][metric1]
        data2 = data[cmip][metric2]
        mask = np.logical_and(~np.isnan(data1), ~np.isnan(data2))

        f_data1 = data1[mask]
        f_data2 = data2[mask]
        plt.scatter(data1,data2,color=colors[cmip],s=12)
        if len(f_data1) > 0:
            corr = np.corrcoef(f_data1,f_data2)[1][0]
            plt.text(0.1,0.95-i*0.055,cmip+': R = '+str(np.round(corr,2)),color=colors[cmip],transform=plt.gca().transAxes)
            i += 1
    # plot observations and internal variability around it:
    plt.scatter(np.nanmean(obsdata[metric1]),np.nanmean(obsdata[metric2]),color='black',s=20)
    for i in range(len(data['CMIP6'][metric1+'_vari'])):
        vari_x = data['CMIP6'][metric1+'_vari'][i]
        vari_y = data['CMIP6'][metric2+'_vari'][i]
        mean_x = np.nanmean(obsdata[metric1])
        mean_y = np.nanmean(obsdata[metric2])
        plt.fill_between([mean_x-vari_x,mean_x+vari_x],[mean_y-vari_y,mean_y-vari_y],
                                 [mean_y+vari_y,mean_y+vari_y],facecolor='k',alpha=0.05)
    plt.ylim(top=plt.gca().get_xlim()[0]+1)
    if xlabel:
        plt.xlabel(ylabels[metric1])
    plt.ylabel(ylabels[metric2])
    plt.gca().spines['right'].set_color('none')
    plt.gca().spines['top'].set_color('none')
    plt.ylim(yrange)

# plot
plt.subplot(2,4,4)
plot_fig4('gmst_co2','sia_mar_co2','d)',yrange=[-3.5,2.1])
plt.subplot(248)
plot_fig4('gmst_co2','sia_co2','h)',xlabel=True,yrange=[-5,1.1])

plt.tight_layout(h_pad = 0.1,rect=[0, 0, 0.99, 0.99])
plt.savefig('../PNGs/Fig_9_14.pdf')

# end of script
