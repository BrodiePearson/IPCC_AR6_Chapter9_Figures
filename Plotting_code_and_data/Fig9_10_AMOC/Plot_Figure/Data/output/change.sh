#!/bin/sh
for m in CESM2 FGOALS-f3-L FGOALS-g3 GISS-E2-1-G INM-CM4-8 
do
cd /model1/hualj/IPCC/CMIP6_AMOC/output/output
mkdir ${m}
cd ${m}
for exp in lig127k midHolocene piControl 
do
ncpdq -a time,lev,lat,basin /model1/hualj/IPCC/CMIP6_AMOC/output/${m}/${exp}.nc ${exp}.nc
done
done
