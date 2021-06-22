#!/bin/bash

depth="15"

# year1=1995
# year2=2014
year1=1979
year2=1998

declare -a liste_exp=("land-hist" "amip" "historical")
declare -a liste_mip=("LS3MIP" "CMIP" "CMIP")
declare -a liste_exp=("land-hist")
declare -a liste_mip=("LS3MIP")
nexp=${#liste_exp[@]}

let istop=${nexp}-1
for iexp in `seq 0 1 ${istop}`; do

  experiment=${liste_exp[iexp]}
  project=${liste_mip[iexp]}
  echo
  echo -
  echo "- MIP: "${project}"; Experiment: "${experiment}
  echo - 
  echo

  variableout="pf"${depth}"m"
  datapath="/data/gkrinner/permafrost"
  
  liste=`ls /data/gkrinner/CMIP6/${project}/${experiment}/Lmon/tsl/*.nc | cut -d'/' -f9 | cut -d'_' -f-3 | cut -d'_' -f3`
  
  outdir=${variableout}"_"${experiment}_${year1}"-"${year2}
  rm -rf ${datapath}/${outdir} ${outdir}
  mkdir -p ${datapath}/${outdir}
  ln -s ${datapath}/${outdir} .
  
  echo -n "Nombre de modeles : " ; echo ${liste} | wc -w
  for model in ${liste} ; do
    echo -n "'"${model}"',"
  done
  echo
  
  echo
  echo Calcul...
  echo
  for model in ${liste} ; do
  
    echo ${model}
    ficin=`ls /data/gkrinner/CMIP6/${project}/${experiment}/Lmon/tsl/*_${model}_*.nc | head -n1`
    ficout=`basename ${ficin} | rev | cut -b 21- | rev`"_${year1}0101-${year2}1231.nc"
    ficout=`echo ${ficout} | sed "s/tsl/${variableout}/g"`
  
    cdo -seldate,${year1}-01-01,${year2}-12-31 ${ficin} $outdir"/"${ficout} >/dev/null 2>&1 
  
  done
  
  # masques : chercher original, sinon refaire
  for maskvar in sftlf sftgif ; do
     echo
     echo Masque ${maskvar}
     echo
     for model in ${liste}; do
         fichier=`ls /home/gkrinner/CMIP6/masques/${maskvar}/${maskvar}_${model}.nc 2>/dev/null | head -n 1`
         if [ "XX"${fichier}"XX" != "XXXX" ] ; then
          cp ${fichier} ${outdir}/${maskvar}_${model}.nc
          diag="Original trouve."
         else
          substitute=/home/gkrinner/CMIP6/masques/pseudo_${maskvar}/${maskvar}_${model}.nc
          if [ -f  ${substitute} ] ; then
            cp ${substitute} ${outdir}/${maskvar}_${model}.nc
            diag="Substitution trouvee."
          else
            diag="Besoin de substitution. ++++++++++++++++++++++++"
          fi
         fi
         echo ${model}" : "${diag}
     done
  done
  
  #
  # Analyse
  #

  reglist="NH" # "glob NH SH"
  
  for reg in ${reglist}; do
  
    if [ $reg == "glob" ] ; then
        LS=-90; LN=90
        factscale=511185932 # Superficie de la Terre
    elif [ $reg == "NH" ] ; then
        LS=0; LN=90
        factscale=255592966 # Superficie d'une hemisphere
    elif [ $reg == "SH" ] ; then
        LS=-90; LN=0
        factscale=255592966 # Superficie d'une hemisphere
    else
        echo "Define limits"
        exit
    fi
  
    outfile=${variableout}"_"${experiment}"_"${reg}"_"${year1}"-"${year2}".txt"
    rm -rf ${outfile}
  
    echo
    echo $reg
    echo
  
    for model in ${liste} ; do
  
  
        ficin=${outdir}/${variableout}*"_"${model}"_"*"_${year1}0101-${year2}1231.nc"
  
        zlist=`cdo showlevel ${ficin}  2>/dev/null`
        zs=( ${zlist} )
        let nz=${#zs[@]}
  
        for i in `seq 1 1 ${nz}`; do
          let im1=${i}-1
          if (( $(echo "${zs[im1]} <= ${depth}" |bc -l) )); then
            if [ ${i} -eq ${nz} ] ; then
              let i1=${i}; let i2=${i}
              p1=.5
            elif (( $(echo "${zs[i]} > ${depth}" |bc -l) )) ; then
              let i1=${i}; let i2=${i}+1
              p1=`echo "(${zs[i]}-${depth})/(${zs[i]}-${zs[im1]})" | bc -l`
            fi
          fi
        done
        p2=`echo "1-${p1}" | bc -l` 

        surfacemax=`cdo -output -mulc,${factscale} -fldmean -sellonlatbox,0,360,${LS},${LN} \
                        -mul -mulc,-0.01 -subc,100 ${outdir}/sftgif_${model}.nc -mulc,0.01 -mul ${outdir}/sftlf_${model}.nc -addc,1. -mulc,0. \
                        -seltimestep,1 -sellevidx,1 ${ficin} 2>/dev/null`
        land=`cdo -output -mulc,${factscale} -fldmean -sellonlatbox,0,360,${LS},${LN} \
                  -mulc,0.01 -mul ${outdir}/sftlf_${model}.nc -addc,1. -mulc,0. \
                  -seltimestep,1 -sellevidx,1 ${ficin} 2>/dev/null`
        echo ${model} "- Surface max : " ${surfacemax} " - Land: " ${land}
  
        cdo -mul -mulc,-0.01 -subc,100 ${outdir}/sftgif_${model}.nc -mulc,0.01 -mul ${outdir}/sftlf_${model}.nc \
            -ltc,273.15 -timmax -sellevidx,${i1} ${ficin} tmp1.nc 2>/dev/null
        cdo -mul -mulc,-0.01 -subc,100 ${outdir}/sftgif_${model}.nc -mulc,0.01 -mul ${outdir}/sftlf_${model}.nc \
            -ltc,273.15 -timmax -sellevidx,${i2} ${ficin} tmp2.nc 2>/dev/null
        cdo -add -mulc,${p1} tmp1.nc -mulc,${p2} tmp2.nc ${outdir}/${model}.nc 2>/dev/null
        rm -f tmp1.nc tmp2.nc
  
        extent=`cdo -output -mulc,${factscale} -fldmean -sellonlatbox,0,360,${LS},${LN} ${outdir}/${model}.nc 2>/dev/null`
  
        echo ${model} " " $extent >> $outfile
  
    done
  
  done

done
