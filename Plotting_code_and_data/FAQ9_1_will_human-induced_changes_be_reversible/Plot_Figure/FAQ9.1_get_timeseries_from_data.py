#!/usr/bin/env python
 
# script to plot sea level curve through last glacial cycle
# Data from Dutton / Lambeck via Peter Clark
 
import numpy as np
import matplotlib.pyplot as plt
from scipy.ndimage.filters import uniform_filter1d
from scipy.ndimage.filters import gaussian_filter1d
from scipy import interpolate
 
 
plotname = 'FAQ9.1-RSL-last-glacial-cycle'
 
file = 'data/FAQ9.1-timeseries-data-Dutton'
 
data = np.loadtxt(open(file+'.txt', 'r'), usecols=(0, 1))
 
time = data[:,0]
rsl = data[:,1]
 
time = time * -1. # to convert to negative (i.e. past) time
 
 
 
# interpolate irregular-spaced data to 1yr intervals
 
x = time
y = rsl
f = interpolate.interp1d(x, y)
 
xnew = np.arange(-150, 0, 0.001)
ynew = f(xnew)   # use interpolation function returned by `interp1d`
 
time = xnew
rsl = ynew
 
# resample the data
 
N = 5000          # this is the length of the smoothing in years
sig = 2500
 
#rsl_smth = uniform_filter1d(rsl, size=N)
rsl_smth = gaussian_filter1d(rsl, sig)
rsl_smth.shape = rsl.shape
 
 
 
 
### Plot
 
fig = plt.figure(figsize=(12, 4))
#gs = GridSpec(2, 4, hspace=0.4, wspace=0.75)
plt.subplots_adjust(left=0.1, bottom=0.2, right=0.9, top=0.95, wspace=0, hspace=0)
#plt.subplot(gs[0, 0:3])
 
plt.plot(time, rsl, color='slategray', linewidth='1', alpha=0.5)
plt.plot(time, rsl_smth, color='steelblue', linewidth='10', alpha=0.5)
#plt.text(-700000, 465, 'smoothing = '+str(N)+' ka')
plt.axis(xmin=-150, xmax=0, ymin=-150, ymax=15)
#plt.axis(xmin=-800000, xmax=0, ymin=-10, ymax=3)
 
 
#plt.xlim(xlim[:])
#plt.xlim(5300000, 0)  # decreasing time
plt.xlabel('Thousands of years before present')
plt.ylabel('Global mean sea level (m)')
 
plt.savefig('../PNGs/' + plotname + '.pdf', dpi=300)
print("saving figure %s" % plotname + '.pdf')

