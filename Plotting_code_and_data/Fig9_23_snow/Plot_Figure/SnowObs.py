#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from mpl_toolkits.axes_grid1 import make_axes_locatable

"""

Format de l'axe des mois

"""
def format_fn(tick_val, tick_pos):
    # monlabels = list('DJFMAMJJASONDJ')
    monlabels = [ 'Dec', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan' ]
    return monlabels[int(tick_val)]


"""

Programme principal

"""

ok_SCE = True
ok_SWE = True

ybeg = 1981
yend = 2018
datestr = str(ybeg)+"-"+str(yend)

ny = yend - ybeg + 1
nm = 12

sce = np.zeros((ny,nm),np.float)
scetrend = np.zeros((nm),np.float)
swe = np.zeros((ny,nm),np.float)
swetrend = np.zeros((nm),np.float)
year = np.zeros((ny),np.float)

with open("data/Mudryk_scf_anom_"+datestr+".txt","r") as f:
    data = f.readlines()

for i,line in enumerate(data):
    if (i > 0):
        words = line.split()
        year[i-1] = words[0]
        for j in range(nm): 
            sce[i-1,j] = float(words[j+1])

with open("data/Mudryk_swe_anom_"+datestr+".txt","r") as f:
    data = f.readlines()

for i,line in enumerate(data):
    if (i > 0):
        words = line.split()
        year[i-1] = words[0]
        for j in range(nm): 
            swe[i-1,j] = float(words[j+1])

with open("data/Mudryk_scf_trend_"+datestr+".txt","r") as f:
    data = f.readlines()

words = data[1].split()
for j in range(nm):
   scetrend[j] = float(words[j])

with open("data/Mudryk_swe_trend_"+datestr+".txt","r") as f:
    data = f.readlines()

words = data[1].split()
for j in range(nm):
   swetrend[j] = float(words[j])

x2d, y2d = np.meshgrid(np.arange(year[0]-.5,year[ny-1]+1.5,1.),np.arange(0.5,float(nm+1),1.))

p1d = 0 
p2d = 1 

# asp1d = 12
if (yend == 2017):
   asp1d = 9.4
elif (yend == 2018):
   asp1d = 7.8
asp2d = 1.

if ( ok_SCE ) and ( ok_SWE ):
    plt.figure(figsize=(7,5))
    format_fig = (2,4)
    place_SCE1 = (0, p2d)
    place_SCE2 = (0, p1d)
    place_SWE1 = (1, p2d)
    place_SWE2 = (1, p1d)
    subtitle_trendSCE = "a) "
    subtitle_SCE = "b) "
    subtitle_trendSWE = "c) "
    subtitle_SWE = "d) "
else:
    subtitle_SCE = "a) "
    subtitle_trendSCE = "b) "
    subtitle_SWE = "a) "
    subtitle_trendSWE = "b) "
    plt.figure(figsize=(7,2))
    format_fig = (1,4)
    place_SCE1 = (0, p2d)
    place_SCE2 = (0, p1d)
    place_SWE1 = (0, p2d)
    place_SWE2 = (0, p1d)

plt.subplots_adjust( hspace=.15 )
plt.subplots_adjust( wspace=.5 )

if ( ok_SCE ):
    SCE = plt.subplot2grid(format_fig, place_SCE1, colspan=3)
    SCE.set_title(subtitle_SCE+'NH Snow Cover \n Anomaly (10$^6$ km$^2$)',fontsize=10)
    SCE.yaxis.set_major_locator(ticker.IndexLocator(base=1, offset=.5))
    SCE.yaxis.set_major_formatter(ticker.FuncFormatter(format_fn))
    SCE.xaxis.set_minor_locator(ticker.IndexLocator(base=5, offset=-.5))
    SCE.set_aspect(asp2d)
    SCE.yaxis.set_tick_params(labelsize=9.)
    im = SCE.pcolormesh(x2d, y2d, np.transpose(sce), vmin=-5.1, vmax=5.1, cmap='BrBG')
    divider = make_axes_locatable(SCE)
    cax = divider.append_axes("right", size="5%", pad=0.05)
    plt.colorbar(im, cax=cax)

if ( ok_SWE ):
    SWE = plt.subplot2grid(format_fig, place_SWE1, colspan=3)
    SWE.set_title(subtitle_SWE+'NH Snow Mass \n Anomaly (10$^3$ Gt)',fontsize=10)
    SWE.yaxis.set_major_locator(ticker.IndexLocator(base=1, offset=.5))
    SWE.yaxis.set_major_formatter(ticker.FuncFormatter(format_fn))
    SWE.xaxis.set_minor_locator(ticker.IndexLocator(base=5, offset=-.5))
    SWE.set_aspect(asp2d)
    SWE.yaxis.set_tick_params(labelsize=9.)
    im = SWE.pcolormesh(x2d, y2d, np.transpose(swe), vmin=-.51, vmax=.51, cmap='BrBG')
    divider = make_axes_locatable(SWE)
    cax = divider.append_axes("right", size="5%", pad=0.05)
    plt.colorbar(im, cax=cax)

y_pos = np.arange(nm)
# monlabels = list('JFMAMJJASOND')
# monlabels = [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ]
monlabels = [ '', '', '', '', '', '', '', '', '', '', '', '' ]

if ( ok_SCE ):
    SCEtrendplot = plt.subplot2grid(format_fig, place_SCE2)
    SCEtrendplot.barh(y_pos, scetrend, align='center', color='darkgoldenrod', ecolor='black')
    SCEtrendplot.set_title(subtitle_trendSCE+'NH Snow Cover \nTrend (10$^3$ km$^2$yr$^{-1}$)',fontsize=10)
    SCEtrendplot.spines['top'].set_visible(False)
    SCEtrendplot.spines['left'].set_visible(False)
    SCEtrendplot.get_yaxis().tick_right()
    SCEtrendplot.set_yticks(y_pos)
    SCEtrendplot.set_ylim([-.5,11.5])
    SCEtrendplot.set_yticklabels(monlabels)
    SCEtrendplot.xaxis.set_major_locator(ticker.MultipleLocator(50))
    SCEtrendplot.xaxis.set_minor_locator(ticker.MultipleLocator(250))
    SCEtrendplot.set_aspect(asp1d)

if ( ok_SWE ):
    SWEtrendplot = plt.subplot2grid(format_fig, place_SWE2)
    SWEtrendplot.barh(y_pos, swetrend, align='center', color='darkgoldenrod', ecolor='black')
    SWEtrendplot.set_title(subtitle_trendSWE+'NH Snow Mass \nTrend (Gt yr$^{-1}$)',fontsize=10)
    SWEtrendplot.spines['top'].set_visible(False)
    SWEtrendplot.spines['left'].set_visible(False)
    SWEtrendplot.get_yaxis().tick_right()
    SWEtrendplot.set_yticks(y_pos)
    SWEtrendplot.set_ylim([-.5,11.5])
    SWEtrendplot.set_yticklabels(monlabels)
    SWEtrendplot.xaxis.set_major_locator(ticker.MultipleLocator(5))
    SWEtrendplot.xaxis.set_minor_locator(ticker.MultipleLocator(25))
    # SWEtrendplot.set_aspect(asp1d/10.5)
    SWEtrendplot.set_aspect(asp1d/8.3)
 
plt.savefig("../PNGs/SnowObs"+datestr+".png")
plt.savefig("../PNGs/SnowObs"+datestr+".pdf")
plt.show()

