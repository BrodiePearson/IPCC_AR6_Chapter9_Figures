#!/bin/sh
mkdir output

for m in CESM2
do
echo $m
cdo selyear,0451/0500 tos_Omon_${m}_lig127k_r1i1p1f1_gn_045101-050012.nc output/${m}_lig127k.nc
cdo selyear,0451/0500 tos_Omon_${m}_midHolocene_r1i1p1f1_gn_045101-050012.nc output/${m}_midHolocene.nc
cdo selyear,0001/0050 tos_Omon_${m}_piControl_r1i1p1f1_gn_000101-009912.nc output/${m}_piControl.nc
done

#!for m in GISS-E2-1-G
#!do
#!echo $m
#!cdo selyear,2950/2999 tos_Omon_${m}_lig127k_r1i1p1f1_gn_295001-299912.nc output/${m}_lig127k.nc
#!cdo selyear,2950/2999 tos_Omon_${m}_midHolocene_r1i1p1f1_gn_295001-299912.nc output/${m}_midHolocene.nc
#!cdo selyear,3101/3150 tos_Omon_${m}_midPliocene-eoi400_r1i1p1f1_gn_310101-315012.nc output/${m}_midPliocene.nc
#!cdo selyear,4150/4199 tos_Omon_${m}_piControl_r1i1p1f1_gn_415001-421012.nc output/${m}_piControl.nc
#!done

for m in IPSL-CM6A-LR
do
echo $m
cdo selyear,2350/2399 tos_Omon_${m}_lig127k_r1i1p1f1_gn_235001-239912.nc output/${m}_lig127k.nc
cdo selyear,2350/2399 tos_Omon_${m}_midHolocene_r1i1p1f1_gn_235001-239912.nc output/${m}_midHolocene.nc
#!cdo selyear,2000/2049 tos_Omon_${m}_midPliocene-eoi400_r1i1p1f1_gn_185001-204912.nc output/${m}_midPliocene.nc
cdo selyear,1850/1899 tos_Omon_${m}_piControl_r1i1p1f1_gn_185001-194912.nc output/${m}_piControl.nc
done

for m in MRI-ESM2-0
do
echo $m
cdo selyear,2101/2150 tos_Omon_${m}_midHolocene_r1i1p1f1_gn_195101-215012.nc output/${m}_midHolocene.nc
cdo selyear,1850/1899 tos_Omon_${m}_piControl_r1i1p1f1_gn_185001-255012.nc output/${m}_piControl.nc
done

for m in NESM3
do
echo $m
cdo selyear,1650/1699 tos_Omon_${m}_lig127k_r1i1p1f1_gn_160001-169912.nc output/${m}_lig127k.nc
cdo selyear,1848/1897 tos_Omon_${m}_midHolocene_r1i1p1f1_gn_179801-189712.nc output/${m}_midHolocene.nc
cdo selyear,1000/1049 tos_Omon_${m}_piControl_r1i1p1f1_gn_100001-119912.nc output/${m}_piControl.nc
done

for m in NorESM1-F
do
echo $m
cdo selyear,1651/1700 tos_Omon_${m}_lig127k_r1i1p1f1_gn_165101-170012.nc output/${m}_lig127k.nc
cdo selyear,1651/1700 tos_Omon_${m}_midHolocene_r1i1p1f1_gn_165101-170012.nc output/${m}_midHolocene.nc
cdo selyear,2451/2500 tos_Omon_${m}_midPliocene-eoi400_r1i1p1f1_gn_245101-250012.nc output/${m}_midPliocene.nc
cdo selyear,1501/1550 tos_Omon_${m}_piControl_r1i1p1f1_gn_150101-155012.nc output/${m}_piControl.nc
done



for m in CESM2 GISS-E2-1-G IPSL-CM6A-LR MRI-ESM2-0 NESM3 NorESM1-F 
do
echo $m
for exp in lig127k midHolocene midPliocene piControl
do 
echo $exp
cdo remapbil,r360x180 output/${m}_${exp}.nc output/regrid1_${m}_${exp}.nc
done
done

for m in CESM2 GISS-E2-1-G IPSL-CM6A-LR MRI-ESM2-0 NESM3 NorESM1-F
do
echo $m
for exp in piControl
do
echo $exp
ncra output/regrid1_${m}_${exp}.nc output/regrid_${m}_${exp}.nc
done
done

for m in CESM2 GISS-E2-1-G IPSL-CM6A-LR MRI-ESM2-0 NESM3 NorESM1-F
do
echo $m
for exp in lig127k midHolocene midPliocene 
do
echo $exp
cdo yearmean output/regrid1_${m}_${exp}.nc output/regrid_${m}_${exp}.nc
done
done

for m in CESM2 GISS-E2-1-G IPSL-CM6A-LR MRI-ESM2-0 NESM3 NorESM1-F
do
echo $m
for exp in lig127k midHolocene midPliocene
do
echo $exp
cdo sub output/regrid_${m}_${exp}.nc output/regrid_${m}_piControl.nc output/anomaly_${m}_${exp}.nc
done
done

for m in CESM2 GISS-E2-1-G IPSL-CM6A-LR MRI-ESM2-0 NESM3 NorESM1-F
do
echo $m
for exp in lig127k midHolocene midPliocene
do
echo $exp
cdo fldmean output/anomaly_${m}_${exp}.nc output/avg_anomaly_${m}_${exp}.nc
done
done


