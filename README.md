# IPCC AR6 Chapter 9 Figures
Repository with the code and data for all figures from Chapter 9 of the Sizth Assesment Report from the Intergovernmental Panel on Climate Change (IPCC AR6)

## How to use this repository
The code to plot each figure from Chapter 9 of IPCC AR6 is contained in the `Plotting_code_and_data` directory. 
Each figure has its own folder, named after its number in the report and a brief descriptor of the figure.
If this code substantially aids your work, it can be cited using [this Zenodo reference]() [LINK TO BE ADDED]

All of the individual figure directories contain a png and pdf image of the final figure used in the IPCC AR6. 
In addition, many of these directories have a 
1. `Plot_Figure` folder that contains the code used to create the figure, 
2. `Plotted_Data` folder that contains the final plotted data in the NetCDF format required by the IPCC TSU, 
3. `PNGs` folder where plotting code will output image files of each subpanel (not alwayds `.png`, could be `.pdf`, `.eps` etc.) 
The structure within each figure folder changes slightly between figures, due to the various authors that contributed to plotting 
code for specific figures in this chapter.

Some figures require large sets of data that cannot be uploaded to GitHub or shared easily. 
As a result, some plotting code cannot be used without first downloading the required data (for example CMIP data from ESGF nodes).
The metadata of these CMIP datasets and other datasets used within the chapter are provided in the Appendix of the chapter 
and the supplementary material from the IPCC TSU. Where neccessary, the directory structure of this data can be inferred from the processing code.

## List of Figures in chapter 9 (with brief decription and the coding language used to plot them)

* Figure 9.1 - Visual Plan of chapter 9 and connections with other chapters (not included here)
* [**Figure 9.2**]() - 
* [**Figure 9.3**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_03_SST/Fig9_03_SST.pdf) - Sea surface temperature timeseries and maps (**Matlab**)
* [**Figure 9.4**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_04_fluxes/Fig9_04_fluxes.pdf) - Surface fluxes of freshwater, heat, and momentum (**Matlab**)
* [**Figure 9.5**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_05_MLD/Fig9_05_MLD.pdf) - Mixed Layer Depths (**Matlab**)
* [**Figure 9.6**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_06_OHC/Fig9_06_OHC.pdf) - Ocean Heat Content timeseries and maps (**Matlab**)
* [**Figure 9.7**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_07_zonal_temp_transects/Fig9_07_zonal_temp_transects.pdf) - Zonal transects of ocean temperature (**Matlab**)
* [**Figure 9.8**]() -
* [**Figure 9.9**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_09_OHCvsSST/Fig9_09_OHCvsSST.pdf) - Paleo-, modern- and future-changes in ocean heat content and surface temperatures (**Matlab**)
* [**Figure 9.10**]() - 
* [**Figure 9.11**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_11_BSF/Fig9_11_BSF.pdf) - Barotropic streamfunction, surface currents, and transports (**Matlab**)
* [**Figure 9.12**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_12_OceanSLR/Fig9_12_OceanSLR.pdf) - Maps of ocean sea level rise and the standard deviation of sea surface height (**Matlab**)
* [**Figure 9.13**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_13_Arctic_SI/Fig9_13_Arctic_SI.pdf) - Arctic sea-ice historical records and CMIP6 projections (**Python**)
* [**Figure 9.14**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_14_SI_warming/Fig9_14_SI_warming.pdf) - Sea-ice area as a function of temperature, CO2 emissions and time (**Python**)
* [**Figure 9.15**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_15_Antarctic_SI/Fig9_15_Antarctic_SI.pdf) - Antarctic sea-ice historical records and CMIP6 projections (**Python**)
* [**Figure 9.16**]() -
* [**Figure 9.17**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_17_GIS_synth/Fig9_17_GIS_synth.pdf) - Greenland Ice Sheet: synthesis of paleo-, modern- and future-changes (**Matlab**)
* [**Figure 9.18**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_18_AIS_synth/Fig9_18_AIS_synth.pdf) - Antarctic Ice Sheet: synthesis of paleo-, modern- and future-changes (**Matlab**)
* [**Figure 9.19**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_19_AIS_basal/Fig9_19_AIS_basal.pdf) - Antarctic basal melt rates (**Python**)
* [**Figure 9.20**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_20_Glacier_Rate/Fig9_20_Glacier_Rate.png) - Glacier mass change rates (**Python**)
* [**Figure 9.21**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_21_glaciers_changes/Fig9_21_glaciers_change.pnghttps://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_11_BSF/Fig9_11_BSF.pdf) - Glacier mass relative to 2015 (**Python**)
* [**Figure 9.22**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_22_permafrost/Fig9_22_permafrost.pdf) - Permafrost area and changes (**Python**)
* [**Figure 9.23**]() -
* [**Figure 9.24**]() -
* [**Figure 9.25**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_25_SLR_PDFs/Fig9_25_SLR_PDFs.pdf) - PDFs of projected Sea Level Rise at 2050 and 2100 under different SSPs (**Matlab**)
* [**Figure 9.26**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_26_SL_regional/Fig9_26_SL_regional.pdf) - Projected sea level change contributions under SSP1-2.6 and SSP5-8.5 (**Matlab**)
* [**Figure 9.27**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_27_SL_scenarios/Fig9_27_SL_scenarios.pdf) - Projected global mean sea level rise under different SSP scenarios (**Matlab**)
* [**Figure 9.28**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_28_RSL_scenarios/Fig9_28_RSL_scenarios.pdf) - Regional sea level change at 2100 for different SSP scnearios (**Matlab**)
* [**Figure 9.29**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_29_SL_time/Fig9_29_SL_time.pdf) - Projected timing of sea-level rise milestones (**R**)
* [**Figure 9.30**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_30_GMSL_Commitment/Fig9_30_GMSL_Commitment.pdf) - 2,000- and 10,000-year sea-level commitments as a function of peak global surface air temperature anomaly (**Matlab**)
* [**Figure 9.31**]() -
* [**Figure 9.32**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_32_ESL_proj/Fig9_32_ESL_proj.pdf) - Median amplification factor of extreme still water level by 2050 and 2100 (**Matlab**)

## List of Additional Figures related to chapter 9 (and the coding language used to plot them)

* [**Cross-chapter box Figure 9.2.1**]() - 
* [**Cross-chapter box Figure 9.1.1**]() - 
* [**FAQ 9.1**]() -
* [**FAQ 9.2**]() -
* [**FAQ 9.3**]() -
* [**Technical Summary 4**]() -

## Functions for IPCC processing/analysis

Many of the figures in Chapter 9 use Matlab functions created by Brodie Pearson and Baylor Fox-Kemper. These functions are found in the `Functions` directory,
and Matlab code in this repository is set up to find these functions automatically.

Some of the code uses ESMValTool to perform certain pre-processing operations on CMIP ensembles and observational/reanalysis data. 
These operations include: re-gridding onto matching grids, extraction of specific time periods or regions, averaging operations.
The recipes for performing these operations are provided in the `Recipes_for_ESMValTool` directory. 
**ESMValTool was only used to pre-process this data, it was not used to plot the figures in Chapter 9.**
The ESMValTool recipes are designed to crash after pre-processing the data, 
and this data can be extracted from the appropriate pre-processor directory 
(note that you may need to turn on a flag to save the pre-processed data).
