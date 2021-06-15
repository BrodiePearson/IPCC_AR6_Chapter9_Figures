#!/bin/sh

for exp in midPliocene
do
echo $exp
cp output/avg_anomaly_NorESM1-F_${exp}.nc output/avg_anomaly_${exp}.nc
done

for exp in lig127k 
do
echo $exp
cdo add output/avg_anomaly_CESM2_${exp}.nc output/avg_anomaly_IPSL-CM6A-LR_${exp}.nc output/step1.nc
cdo add output/avg_anomaly_NESM3_${exp}.nc output/avg_anomaly_NorESM1-F_${exp}.nc output/step2.nc
cdo add output/step1.nc output/step2.nc output/step3.nc
cdo divc,4 output/step3.nc output/avg_anomaly_${exp}.nc
rm -f output/step*.nc
done

for exp in midHolocene 
do
echo $exp
cdo add output/avg_anomaly_CESM2_${exp}.nc output/avg_anomaly_IPSL-CM6A-LR_${exp}.nc output/step1.nc
cdo add output/avg_anomaly_NESM3_${exp}.nc output/avg_anomaly_MRI-ESM2-0_${exp}.nc output/step2.nc
cdo add output/step1.nc output/step2.nc output/step3.nc
cdo add output/step3.nc output/avg_anomaly_NorESM1-F_${exp}.nc output/step4.nc
cdo divc,5 output/step4.nc output/avg_anomaly_${exp}.nc
rm -f output/step*.nc
done


