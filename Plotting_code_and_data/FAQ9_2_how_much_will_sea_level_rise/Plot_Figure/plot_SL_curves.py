import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import (MultipleLocator, FormatStrFormatter, AutoMinorLocator)

#to change the font
font = {'size'   : 11}
plt.rc('font', **font)
# change font
plt.rcParams['font.sans-serif'] = "Arial"
plt.rcParams['font.family'] = "sans-serif"
params = {'mathtext.default': 'regular' }          
plt.rcParams.update(params)

in_file='data/FAQ9.2_v5.0_data.xlsx'

df=pd.read_excel (in_file, sheet_name='time_series',header =0)
#df = df_temp.values[2:,:]
#print(df_temp.values[2:,:])
#df=pd.read_csv (in_file, sep=';') # get rid of detailed row

#to do add colour 
# 	add middle bar 
# choose colour of sns file
obs_col='0'
ssp85_col='#840B22'
ssp26_col='#1D3354'
color_palette=(obs_col,ssp26_col,ssp85_col)
#plt.tick_params(axis='y', which='right', labelleft=False, labelright=True)
plt.rcParams['ytick.right'] = plt.rcParams['ytick.labelright'] = True
plt.rcParams['ytick.left'] = plt.rcParams['ytick.labelleft'] = False

cm = 1/2.54  # centimeters in inches
fig, ax = plt.subplots(1,1,figsize=(19.5*cm,5*cm))
unit=100 #100 for cm, 1 for m

for idx,  type in enumerate(df.type_data.unique()):
	subset=df.loc[(df['type_data']==type)]
	ax.plot(subset.Year, subset.GMSL_m*100, color=color_palette[idx])
	#plt.fill_between(subset.Year,subset.lower_m, subset.upper_m, alpha=0.5)
	ax.fill_between(subset.Year,subset.lower_m*unit, subset.upper_m*unit, alpha=0.2, color=color_palette[idx])

ax.xaxis.set_minor_locator(MultipleLocator(10))
ax.xaxis.set_major_locator(MultipleLocator(20))
ax.yaxis.set_minor_locator(MultipleLocator(.25*unit))
ax.yaxis.set_major_locator(MultipleLocator(.5*unit))

ax.spines['top'].set_visible(False)
ax.spines['left'].set_visible(False)

plt.xlim([1970,2100])
plt.ylim([-0.02*unit, 1.1*unit])
plt.xlabel('Years')
#ax.set_ylabel('Global mean sea level change (m)')
plt.savefig('../PNGs/FAQ9.2_v5.2_unit'+str(unit)+'.pdf')

