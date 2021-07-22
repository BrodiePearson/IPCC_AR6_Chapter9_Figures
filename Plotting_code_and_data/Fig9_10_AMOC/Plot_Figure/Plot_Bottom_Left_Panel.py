import matplotlib
#matplotlib.use('Agg')
import os, sys, glob
import numpy as np
import matplotlib.pyplot as plt
import netCDF4
import iris

'''
Code reads data from local amoc_save_data subdirectory
1. The amoc_delta data for each ensemble member is in a text file - the AMOC rates are the change over 100 years from hist-1950-highres-future (1950-2050), with the control-1950 change removed (to account for residual drift from the short spinup)
2. The heat transport/AMOC scatter plot reads netcdf files from amoc_save_data for each model, resolution, rip_control and rip code. These come from the hist-1950 experiment (1950-2014)
'''

def read_amoc_delta(fname):
    models = []; resols = []; ocn_resols = []; rip_controls = []; rips = []; amoc_deltas = []; colours = []
    with open(fname, 'r') as fh:
        lines = fh.readlines()
        for line in lines:
            print('line ',line)
            values = line.split(' ')
            models.append(values[0])
            resols.append(values[1])
            ocn_resols.append(values[2])
            rip_controls.append(values[3])
            rips.append(values[4])
            # these are rates / year over 100 years of the HighresMIP hist-1950 + highres-future (1950-2050)
            amoc_deltas.append(float(values[5]))
            colours.append(values[6])
            
    return models, resols, ocn_resols, rip_controls, rips, amoc_deltas, colours


def plot_delta_amoc():
    '''
    Calculate the change in AMOC between start and end in hist-1950
    Factor in the change in control-1950 (as drift)
    '''
    
    fig = plt.figure(figsize=[5,3],dpi=100)
    ax = fig.add_subplot(1,1,1)
    
    experiment = 'control-1950'
    rip_control = 'r1i1p1f1'
    lines = ['-', '--', '-.', ':']
    lines = ['-']*6
    resol_ocns = ['100', '50', '25', '8']
    resol_ocns1 = [100, 50, 25, 8]
    
    models, resols, ocn_resols, rip_controls, rips, amoc_deltas, colours = read_amoc_delta('./Data/amoc_save_data/amoc_delta_data_with_CESM.txt')

    print(models)
    index = 0
    for irun, run in enumerate(models):
        model = run
        if 'EC-E' in model:
            popt = rip_controls[irun][4:6]
            label = model+popt
        else:
            label = model
        ioffset = irun*0.5 - 1 
        ax.scatter(0, 0, c = colours[irun])
        ax.scatter(0, 0, c = 'white')

        resol = resols[irun]
        rip_control = rip_controls[irun]
        ocn_resol = ocn_resols[irun]
        rip = rips[irun]

        #irip_offset = irip*0.3 - 1
        moc_delta = amoc_deltas[irun]
        ax.scatter(float(ocn_resol), moc_delta, marker = 'o', c = colours[irun], s = 60)
        ax.set_xlabel('Ocean resolution (km)', fontsize=16)
        ax.set_title('$\Delta$AMOC strength (% per year), 1950-2050', fontsize=16)
        ax.set_ylabel('$\Delta$AMOC strength (%/yr)', fontsize=16)
        ax.set_xlim([4, 110])
        ax.set_ylim([-0.5, 0.05])

    ax.legend(loc = 'lower right', ncol=2, prop={'size':8})

    fig.subplots_adjust(bottom=0.1, left=0.08, right=.95, top=.93, wspace=0.2, hspace=0.2)
    fig_name = 'delta_AMOC_historic_mmodel.png'
    #plt.savefig(os.path.join(PLOTOUT,fig_name))
    
    plt.show()

def plot_amoc_heat_scatter(run_dict, experiment = 'hist-1950'):

    fname = './Data/amoc_save_data/moc_transports_200404_20151011_yearly.nc'
    nc = netCDF4.Dataset(fname)
    amoc_obs = nc.variables['t_moc_mar_hc10'][:]
    nc.close()

    fname = './Data/amoc_save_data/mocha_mht_data_2014_updated_oct_2015_yearly.nc'
    nc = netCDF4.Dataset(fname)
    heat_obs = nc.variables['Q_sum'][:]
    heat_obs_ot = nc.variables['Q_ot'][:]
    heat_obs_gyre = nc.variables['Q_gyre'][:]
    nc.close()

    fig = plt.figure(figsize=[8,8],dpi=100)

    lines = ['-', '--', '-.', ':']
    symbol = ['o', 'o', 'o', 'o', 'o', 'o']
    resol_o = ['100','50','25','8']

    var_sum = 'q_sum_rapid'
    var_ot = 'q_ot_rapid'
    var_gyre = 'q_gyre_rapid'
    
    
    ax = fig.add_subplot(1,1,1)
    for irun, run in enumerate(run_dict):
        model = run['name']
        resols = run['resol']
        for ir, resol in enumerate(resols):
            model_ocn_res = run['resol_ocn'][ir]
            if resol+'_control' in run:
                rip = run[resol+'_control'][0]
                rip_control = rip
            else:
                rip = 'r1i1p1f1'
                rip_control = rip
            #if  timeseries[(model, resol, experiment, rip_control)][rip][var_sum] == []:
            #    continue
            for irip, rip1 in enumerate([rip]):
                fname = os.path.join('./Data/amoc_save_data', model+resol+experiment+rip_control+rip1+'moc_rapid'+'.nc')
                if os.path.exists(fname):
                    nc = netCDF4.Dataset(fname)
                    years = nc.variables['year'][:]
                    moc = nc.variables['moc_rapid'][:]
                    nc.close()
                    print('moc ',model, resol, moc)
                    timeseries = {}
                    for varn in [var_sum, var_ot, var_gyre]:
                        fsave = os.path.join('./Data/amoc_save_data', model+resol+experiment+rip_control+rip1+varn+'.nc')
                        #iris.save(timeseries[(model, resol, experiment, rip_control)][rip][varn], fsave)
                        nc = netCDF4.Dataset(fsave)
                        #print nc.variables
                        timeseries[varn] = nc.variables[varn][:]
                        nc.close()
                        
                    for iro, resol_ocean in enumerate(resol_o):
                        if model_ocn_res == resol_ocean:
                            ax = fig.add_subplot(1,1,1)
                            if irip == 0:
                                label = model+'-'+resol
                                if 'EC-E' in model:
                                    label = label + rip_control[4:6]
                            else:
                                label = ''
                            #years = timeseries[(model, resol, experiment, rip_control)][rip]['moc_rapid'].coord('year').points
                            all_period = np.where((years >= 1950) & (years <= 2014))
                            rapid_period = np.where((years >= 2004) & (years <= 2014))
                            for period in ['all', 'rapid']:
                                if period == 'all':
                                    alpha = 0.2; facecolors = 'none'
                                    edgecolors = run['c'][ir]
                                    period_data = all_period
                                    label_plot = ''
                                else:
                                    alpha = 1.0; facecolors = run['c'][ir]
                                    edgecolors = run['c'][ir]
                                    period_data = rapid_period
                                    label_plot = label

                                ax.scatter(moc[period_data], timeseries[var_sum][period_data], marker = symbol[ir], s = 20, alpha = alpha, facecolors = facecolors, edgecolors = edgecolors)
#                                ax.scatter(moc[period_data], timeseries[var_ot][period_data], marker = 'x', s = 20, alpha = alpha, c = run['c'][ir])
                                ax.scatter(moc[period_data], timeseries[var_gyre][period_data], marker = '^', s = 20, alpha = alpha, facecolors = facecolors, edgecolors = edgecolors)
                else:
                    print('file does not exist ',fname)

    for i in range(0, 1):
        ax = fig.add_subplot(1,1,1)
        ax.scatter(amoc_obs[:], heat_obs[:], marker = 'o', c = 'black', s = 20, label = 'RAPID-MOCHA (Total)')
#        ax.scatter(amoc_obs[:], heat_obs_ot[:], marker = 'x', c = 'black', s = 20, label = 'RAPID-MOCHA (Overturning)')
        ax.scatter(amoc_obs[:], heat_obs_gyre[:], marker = '^', c = 'black', s = 20, label = 'RAPID-MOCHA (Gyre)')
                
        
#       Legends
        color_1 = ax.scatter([],[],color=color1, marker = 'o', facecolors=color1, label='100 km models during RAPID period')
        plt.legend(handles=[color_1])
        color_1 = ax.scatter([],[],color=color1, marker = 'o', facecolors='none', label='100 km models during any period')
        plt.legend(handles=[color_1])
        color_2 = ax.scatter([],[],color=color2, marker = 'o', facecolors=color2, label='40 km models')
        plt.legend(handles=[color_2])
        color_3 = ax.scatter([],[],color=color3, marker = 'o', facecolors=color3, label='25 km models')
        plt.legend(handles=[color_3])
        color_4 = ax.scatter([],[],color=color4, marker = 'o', facecolors=color4, label='8 km models')
        plt.legend(handles=[color_4])
        
        
        plt.xlabel('Atlantic Meridional Overturning Circulation (Sv)', fontsize=16)
        plt.ylabel('Northward Heat Transport (PW)', fontsize=16)
        ax.set_xlim([3, 28])
        ax.set_ylim([-0.15, 1.7])
        ax.legend(loc='upper left', ncol=1, prop={'size':10})
        
#        plt.text(20, 0.6, 'Ocean \n '+resol_o[i]+' km')
#        if i == 1 or i == 3:
#            ax.yaxis.tick_right()
#            ax.yaxis.set_label_position("right")
#        if i < 2:
#            #ax.axes.get_xaxis().set_visible(False)
#            ax.axes.get_xaxis().set_ticklabels([])

    plt.suptitle('Relation of AMOC and Northward Heat Transport at 26.5N', fontsize=16)

    fig.subplots_adjust(bottom=0.1, left=0.08, right=.92, top=.93, wspace=0.03, hspace=0.13)
    #plt.savefig(os.path.join(PLOTOUT,'AMOC_heat_multi_model_'+experiment+'.pdf'))
    #plt.savefig(os.path.join(PLOTOUT,'AMOC_heat_multi_model_'+experiment+'.png'))
    
    plt.show()

if __name__ == '__main__':
    cnames_ores = {'100':'red', '50':'blue', '25':'green', '8':'cyan'}
    years = np.arange(1950, 2950)
    
    run_hist = {}; run_future = {}
    mohc_cmip_resols = ['LL', 'MM', 'HM', 'HH']
    cmip_colours = {'LL':['blue', 0.3], 'MM': ['green', 0.5], 'HM':['red', 0.8], 'HH':['purple', 0.9]}

    color1 = (0.4863, 0.5098, 0.5098)
    color2 = (0.6235, 0, 0.6235)
    color3 = (0, 0.6235, 0)
    color4 = (0, 0.6235, 0.6235)

    experiments = ['control-1950', 'hist-1950', 'spinup-1950', 'highres-future','hist-future']
    cmcc = {'name': 'CMCC-CM2', 'resol': ['HR4', 'VHR4'], 'resol_sym': ['-HR4', '-VHR4'], 'c':[color3,color3], 'resol_ocn': ['25','25']}
    ecmwf = {'name': 'ECMWF-IFS', 'resol':['LR', 'MR', 'HR'], 'resol_sym':['-LR', '-MR', '-HR'], 'c':[color1, color3, color3], 'LR':['r1i1p1f1', 'r2i1p1f1', 'r3i1p1f1', 'r4i1p1f1', 'r5i1p1f1', 'r6i1p1f1'], 'MR':['r1i1p1f1', 'r2i1p1f1', 'r3i1p1f1'], 'HR':['r1i1p1f1', 'r2i1p1f1', 'r3i1p1f1', 'r4i1p1f1', 'r5i1p1f1', 'r6i1p1f1'], 'resol_ocn': ['100','25','25']}
    mohc = {'name': 'HadGEM3-GC31', 'resol': ['LL', 'MM', 'HM', 'HH'], 'resol_sym': ['-LL', '-MM', '-HM', '-HH'], 'c':['red',color1,color3,color3,color4], 'resol_ocn': ['100','25', '25', '8'], 'spinup': ['-LL', '-MM', '-MM', '-MH'], 'LL':['r1i1p1f1', 'r1i2p1f1', 'r1i3p1f1'], 'MM':['r1i1p1f1', 'r1i2p1f1', 'r1i3p1f1'], 'HM':['r1i1p1f1', 'r1i2p1f1', 'r1i3p1f1'], 'HH':['r1i1p1f1']}
    mpi = {'name': 'MPI-ESM1-2', 'resol': ['HR', 'XR'], 'resol_sym': ['-HR', '-XR'], 'c':[color2,color2], 'resol_ocn': ['50','50']}
    ecearth = {'name': 'EC-Earth3P', 'resol': ['LR', 'HR'], 'resol_sym': ['', '-HR'], 'c':[color1, color1, color3, color3], 'resol_ocn': ['100','25'], 'LR':['r1i1p2f1', 'r2i1p2f1', 'r3i1p2f1'], 'HR':['r1i1p2f1', 'r2i1p2f1', 'r3i1p2f1'], 'LR_control':['r1i1p2f1', 'r2i1p2f1', 'r3i1p2f1'], 'HR_control':['r1i1p2f1', 'r2i1p2f1', 'r3i1p2f1']}
    ecearth1 = {'name': 'EC-Earth3P', 'resol': ['LR', 'HR'], 'resol_sym': ['', '-HR'], 'c':[color1, color3], 'resol_ocn': ['100','25'], 'LR':['r1i1p1f1'], 'HR':['r1i1p1f1'], 'LR_control':['r1i1p1f1'], 'HR_control':['r1i1p1f1']}
    cnrm = {'name': 'CNRM-CM6-1', 'resol': ['LR', 'HR'], 'resol_sym': ['', '-HR'], 'c':[color1, color3], 'LR_control':['r1i1p1f2'], 'HR_control':['r1i1p1f2'], 'resol_ocn': ['100', '25']}
                  
    run_dict = [mohc, ecearth, ecearth1, cnrm, cmcc, mpi, ecmwf]

    plot_amoc_heat_scatter(run_dict)

    plot_delta_amoc()
