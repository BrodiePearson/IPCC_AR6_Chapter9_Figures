#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

variable = "snc"
# variable = "snw-cover"
cmip = "CMIP6"
lettre = "a"

# aabeg="1981"; aaend="2017"
aabeg="1981"; aaend="2014"
# aabeg="1995"; aaend="2014"

vertical = True

nmon = 12
nyr=int(aaend)-int(aabeg)+1
labels = [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ]

boxprops = dict(linestyle='-', linewidth=2, color='black')
flierprops = dict(marker='x', markerfacecolor='red', markersize=3, linestyle='none')
medianprops = dict(linestyle='-', linewidth=2, color='blue')
whiskerprops = dict(linestyle='-', linewidth=2, color='black')
capprops = dict(linestyle='-', linewidth=2, color='black')

if (cmip == "CMIP5"):
    if (int(aaend) >= 2006):
        fichier = variable+"_clim_CMIP5_historical+rcp85_"+aabeg+"-"+aaend+".txt"
    else:
        fichier = variable+"_clim_CMIP5_historical_"+aabeg+"-"+aaend+".txt"
elif (cmip == "CMIP6"):
    if (int(aaend) >= 2015):
        fichier = variable+"_clim_CMIP6_historical+ssp585_"+aabeg+"-"+aaend+".txt"
    else:
        fichier = variable+"_clim_CMIP6_historical_"+aabeg+"-"+aaend+".txt"
else:
    quit()
nmod = 0
print("J'utilise le fichier {}".format(fichier))
with open(fichier,"r") as f:
    data = f.readlines()
nmod = len(data)

models = []
sce = np.zeros((nmod,nmon),np.float)
for i,line in enumerate(data):
    words = line.split()
    models.append(words[0])
    for j in range(nmon):
       sce[i,j] = float(words[j+1])

sce[:,:] /= 1.e6

obssce = np.zeros((nyr,nmon),np.float)
# with open("NOAA-CDR-Snow/nhsce_1995-2014-monthly.txt","r") as f:
with open("Mudryk_scf_"+aabeg+"-"+aaend+".txt","r") as f:
    data = f.readlines()

for i,line in enumerate(data):
    words = line.split()
    for j in range(nmon):
       obssce[i,j] = float(words[j])

obssce[:,:] /= 1.e6

# for j in range(nmon):
#   scesorted = sorted(sce[:,j])
#   print j+1, scesorted[0], np.percentile(sce[:,j],25), np.percentile(sce[:,j],50), np.percentile(sce[:,j],75), scesorted[nmod-1]

fig, ax = plt.subplots()
ax.boxplot(sce[:,:], sym='x', vert=vertical, whiskerprops=whiskerprops, boxprops=boxprops, flierprops=flierprops, medianprops=medianprops, capprops=capprops, zorder=1)
ax.set_title(lettre+') '+cmip+' NH Snow Extent ('+aabeg+'-'+aaend+')')
if vertical:
    ax.set_xlabel('Month')
    ax.set_ylabel('Extent (10$^6$ km$^2$)')
    titleext = "vertical"
    xtickNames = plt.setp(ax, xticklabels=labels)
    plt.setp(xtickNames,rotation=0)
    ax.set_ylim([-2,61.])
else:
    ax.set_xlabel('Extent (10$^6$ km$^2$)')
    ax.set_ylabel('Month')
    titleext = "horizontal"
    ytickNames = plt.setp(ax, yticklabels=labels)
    plt.setp(ytickNames,rotation=0)
    ax.set_xlim([-2,61.])

parts=ax.violinplot(obssce, vert=vertical, widths=0.75, showmeans=False, showextrema=False, showmedians=True)
for pc in parts['bodies']:
    pc.set_facecolor('green')
    pc.set_edgecolor('green')
    pc.set_alpha(.7)
# for partname in ('cmedians'):
#     vp = parts[partname]
    vp = parts['cmedians']
    vp.set_edgecolor('orange')
    vp.set_linewidth(2)


plt.savefig("../PNGs/"+variable+"_NH_"+cmip+"_"+aabeg+"-"+aaend+"_"+titleext+".png")
plt.savefig("../PNGs/"+variable+"_NH_"+cmip+"_"+aabeg+"-"+aaend+"_"+titleext+".pdf")
plt.show()
