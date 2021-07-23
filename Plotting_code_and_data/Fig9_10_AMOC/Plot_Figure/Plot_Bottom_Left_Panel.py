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
    plt.savefig(os.path.join('../PNGs/',fig_name))
    
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

    plot_delta_amoc()
