# This script finds and prints all CMIP6 datasets for each experiment and variable
# that are available on CEDA-Jasmin's BADC server

# The code first deletes any existing logs, then prints the output of an ls command

# First get ocean surface temperature (tos) from all required experiments
rm ./CMIP6_Lists/tos_hist.log # Find historical CMIP simulations
ls /badc/cmip6/data/CMIP6/CMIP/*/*/historical/*/Omon/tos/g* >> ./CMIP6_Lists/tos_hist.log
rm ./CMIP6_Lists/tos_ssp126.log # Find SSP126 projections
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp126/*/Omon/tos/g* >> ./CMIP6_Lists/tos_ssp126.log
rm ./CMIP6_Lists/tos_ssp245.log # Find SSP245 projections
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp245/*/Omon/tos/g* >> ./CMIP6_Lists/tos_ssp245.log
rm ./CMIP6_Lists/tos_ssp370.log # Find SSP370 projections
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp370/*/Omon/tos/g* >> ./CMIP6_Lists/tos_ssp370.log
rm ./CMIP6_Lists/tos_ssp585.log # Find SSP585 projections
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp585/*/Omon/tos/g* >> ./CMIP6_Lists/tos_ssp585.log
rm ./CMIP6_Lists/tos_2300_ssp126.log # Find ssp126 projections out to 2300
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp126/*/Omon/tos/*/*/*2300* >> ./CMIP6_Lists/tos_2300_ssp126.log
rm ./CMIP6_Lists/tos_2300_ssp585.log # Find ssp585 projections out to 2300
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp585/*/Omon/tos/*/*/*2300* >> ./CMIP6_Lists/tos_2300_ssp585.log
rm ./CMIP6_Lists/tos_HighResMIP_hist.log # Find HighResMIP historical simulations
ls /badc/cmip6/data/CMIP6/HighResMIP/*/*/hist-1950/*/Omon/tos/g* >> ./CMIP6_Lists/tos_HighResMIP_hist.log
rm ./CMIP6_Lists/tos_HighResMIP_future.log # Find HighResMIP future projections
ls /badc/cmip6/data/CMIP6/HighResMIP/*/*/highres-future/*/Omon/tos/g* >> ./CMIP6_Lists/tos_HighResMIP_future.log

# Find models with 3D temperature field (thetao) for zonal cross sections
rm ./CMIP6_Lists/thetao_hist.log # Find historical CMIP simulations
ls /badc/cmip6/data/CMIP6/CMIP/*/*/historical/*/Omon/thetao/g* >> ./CMIP6_Lists/thetao_hist.log
rm ./CMIP6_Lists/thetao_ssp126.log # Find SSP126 projections
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp126/*/Omon/thetao/g* >> ./CMIP6_Lists/thetao_ssp126.log
rm ./CMIP6_Lists/thetao_ssp585.log # Find SSP585 projections
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp585/*/Omon/thetao/g* >> ./CMIP6_Lists/thetao_ssp585.log

# Get surface fluxes of momentum in x-direction (tauuo) from historical simulations
rm ./CMIP6_Lists/tauuo_hist.log # Find historical CMIP simulations
ls /badc/cmip6/data/CMIP6/CMIP/*/*/historical/*/Omon/tauuo/g* >> ./CMIP6_Lists/tauuo_hist.log
rm ./CMIP6_Lists/tauvo_hist.log # Find historical CMIP simulations
ls /badc/cmip6/data/CMIP6/CMIP/*/*/historical/*/Omon/tauvo/g* >> ./CMIP6_Lists/tauvo_hist.log
# Next get surface fluxes of momentum in x-direction (tauuo) from SSP585
rm ./CMIP6_Lists/tauuo_ssp585.log
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp585/*/Omon/tauuo/g* >> ./CMIP6_Lists/tauuo_ssp585.log
# Next get surface fluxes of momentum in y-direction (tauvo) from SSP585
rm ./CMIP6_Lists/tauvo_ssp585.log
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp585/*/Omon/tauvo/g* >> ./CMIP6_Lists/tauvo_ssp585.log
# Next get surface freshwater flux (wfo) from SSP585
rm ./CMIP6_Lists/wfo_ssp585.log
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp585/*/Omon/wfo/g* >> ./CMIP6_Lists/wfo_ssp585.log
# Next get surface heat flux (hfds) from SSP585
rm ./CMIP6_Lists/hfds_ssp585.log
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp585/*/Omon/hfds/g* >> ./CMIP6_Lists/hfds_ssp585.log

# Next get barotropic streamfunction (msftbarot) from required experiments
rm ./CMIP6_Lists/msftbarot_hist.log # Find historical CMIP simulations
ls /badc/cmip6/data/CMIP6/CMIP/*/*/historical/*/Omon/msftbarot/g* >> ./CMIP6_Lists/msftbarot_hist.log
rm ./CMIP6_Lists/msftbarot_ssp126.log
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp126/*/Omon/msftbarot/g* >> ./CMIP6_Lists/msftbarot_ssp126.log
rm ./CMIP6_Lists/msftbarot_ssp585.log
ls /badc/cmip6/data/CMIP6/ScenarioMIP/*/*/ssp585/*/Omon/msftbarot/g* >> ./CMIP6_Lists/msftbarot_ssp585.log
