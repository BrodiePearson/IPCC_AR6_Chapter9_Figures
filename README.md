# IPCC AR6 Chapter 9 Figures
### Repository with the code and data for all figures from Chapter 9 of the Sixth Assesment Report from the Intergovernmental Panel on Climate Change (IPCC AR6)

## How to use this repository
The code to plot each figure from Chapter 9 of IPCC AR6 is contained in the [`Plotting_code_and_data`](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/tree/main/Plotting_code_and_data) directory. 
Each figure has its own folder, named after its number in the report and a brief descriptor of the figure.
If code from this repository substantially aids your work, it can be cited using [this Zenodo reference]() [LINK TO BE ADDED]

All of the individual figure directories contain a `.png`, `.pdf` and/or `.eps` image of the final figure used in the IPCC AR6. 
In addition, many of these directories have a 
1. `Plot_Figure` folder that contains the code and data used to create the figure, 
2. `Plotted_Data` folder that contains the final plotted data in the NetCDF format required by the IPCC TSU, 
3. `PNGs` folder where plotting code will output image files of each subpanel (not always `.png`, could be `.pdf`, `.eps` etc.) 
The exact structure varies between figure folders due to the various authors that contributed to different figures in this chapter.

Some figures require large sets of data that cannot be uploaded to GitHub or shared easily. 
As a result, some plotting code cannot be used without first downloading the required data (for example CMIP data from ESGF nodes).
The metadata of these CMIP datasets and other datasets used within the chapter are provided in the Appendix for Chapter 9 of IPCC AR6,
and in the supplementary material from the IPCC TSU. Where neccessary, the directory structure of this data can be inferred from the processing code.

## List of ocean figures in Chapter 9 

| Figure (w/ link) | Code (w/ link)| Primary author(s) | Brief description |
| ------------- |:-------------:|:-----:| -----|
| Figure 9.1    | N/A |  CLAs   | Visual Plan of chapter (No quantitative information; not included here) |
| [**Figure 9.2**]()    | **Matlab** |  **Baylor Fox-Kemper**   |  |
| [**Figure 9.3**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_03_SST/Fig9_03_SST.pdf)    | [**Matlab timeseries**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_03_SST/Plot_Figure/Plot_GMSST.m) and [**maps**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_03_SST/Plot_Figure/Plot_SST_Maps.m)|  **Brodie Pearson**   | Sea surface temperature |
| [**Figure 9.4**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_04_fluxes/Fig9_04_fluxes.pdf)    | [**Matlab**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_04_fluxes/Plot_Figure/Plot_Flux_Maps.m) |  **Brodie Pearson**   | Surface fluxes of freshwater, heat, and momentum  |
| [**Figure 9.5**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_05_MLD/Fig9_05_MLD.pdf)    | [**Matlab**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_05_MLD/Plot_Figure/Plot_ML_Maps.m) |  **Brodie Pearson**   | Mixed Layer Depths  |
| [**Figure 9.6**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_06_OHC/Fig9_06_OHC.pdf)    | [**Matlab timeseries**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_06_OHC/Plot_Figure/Plot_OHC_Timeseries.m) and [**maps**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_06_OHC/Plot_Figure/Plot_OHC_Maps.m) |  **Brodie Pearson**   | Ocean Heat Content |
| [**Figure 9.7**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_07_zonal_temp_transects/Fig9_07_zonal_temp_transects.pdf)    | [**Matlab**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_07_zonal_temp_transects/Plot_Figure/Plot_Zonal_Transects.m) |  **Brodie Pearson**   | Zonal transects of ocean temperature |
| [**Figure 9.8**]()    | **Matlab** |  **Baylor Fox-Kemper**   |  |
| [**Figure 9.9**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_09_OHCvsSST/Fig9_09_OHCvsSST.pdf)   | [**Matlab**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_09_OHCvsSST/Plot_Figure/Plot_OHCvsSST_Timeseries.m) |  **Alan Mix** & **Brodie Pearson**   | Paleo-, modern- and future-changes in ocean heat content and surface temperatures |
| [**Figure 9.10**]()    | **Matlab** |  **Baylor Fox-Kemper**   |  |
| [**Figure 9.11**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_11_BSF/Fig9_11_BSF.pdf)    | [**Matlab maps of speed**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_11_BSF/Plot_Figure/Plot_Speed_Maps.m) and [**streamfunction**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_11_BSF/Plot_Figure/Plot_Streamfunction_Maps.m), and [**transports figure**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_11_BSF/Plot_Figure/Plot_Transport_Panels.m) |  **Brodie Pearson** & **Baylor Fox-Kemper**   |  Barotropic streamfunction, surface currents, and transports |
| [**Figure 9.12**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_12_OceanSLR/Fig9_12_OceanSLR.pdf)    | [**Matlab maps of SSH**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_12_OceanSLR/Plot_Figure/Plot_SSH_Maps.m) & [**standard deviation of SSH**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_12_OceanSLR/Plot_Figure/Plot_SSHstd_Maps.m) |  **Brodie Pearson** | Maps of ocean sea level rise and the standard deviation of sea surface height |


## List of cryosphere figures in Chapter 9 

| Figure (w/ link) | Code (w/ link)| Primary author(s) | Brief description |
| ------------- |:-------------:|:-----:| -----|
| [**Figure 9.13**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_13_Arctic_SI/Fig9_13_Arctic_SI.pdf)    | [**Python timeseries**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_13_Arctic_SI/Plot_Figure/plot_9_13_and_9_15_LEFT_Panels.py) and [**maps**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_13_Arctic_SI/Plot_Figure/plot_Fig_9_13_RIGHT_and_Fig_9_15_RIGHT.py) |  **Dirk Notz**   | Arctic sea-ice historical records and CMIP6 projections |
| [**Figure 9.14**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_14_SI_warming/Fig9_14_SI_warming.pdf)    | [**Python**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_14_SI_warming/Plot_Figure/plot_Fig_9_14.py) |  **Jakob Doerr**   | Sea-ice area as a function of temperature, CO2 emissions and time |
| [**Figure 9.15**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_15_Antarctic_SI/Fig9_15_Antarctic_SI.pdf)    | [**Python timeseries**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_15_Antarctic_SI/Plot_Figure/plot_9_13_and_9_15_LEFT_Panels.py) and [**maps**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_15_Antarctic_SI/Plot_Figure/plot_Fig_9_13_RIGHT_and_Fig_9_15_RIGHT.py) |  **Dirk Notz**   | Antarctic sea-ice historical records and CMIP6 projections  |
| [**Figure 9.16**]()    | **Matlab** |  **Baylor Fox-Kemper** & **Brodie Pearson**   |  |
| [**Figure 9.17**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_17_GIS_synth/Fig9_17_GIS_synth.pdf)    | [**Matlab maps**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_17_GIS_synth/Plot_Figure/Plot_GIS_Future_Maps.m) and [**timeseries**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_17_GIS_synth/Plot_Figure/Plot_Greenland_Timeseries.m) |  **Brodie Pearson** & **Baylor Fox-Kemper**   | Greenland Ice Sheet: synthesis of paleo-, modern- and future-changes |
| [**Figure 9.18**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_18_AIS_synth/Fig9_18_AIS_synth.pdf)    | [**Matlab maps**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_18_AIS_synth/Plot_Figure/Plot_AIS_Future_Maps.m) and [**timeseries**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_18_AIS_synth/Plot_Figure/Plot_Antarctic_Timeseries.m) |  **Brodie Pearson** & **Baylor Fox-Kemper**   | Antarctic Ice Sheet: synthesis of paleo-, modern- and future-changes |
| [**Figure 9.19**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_19_AIS_basal/Fig9_19_AIS_basal.pdf)    | [**Python past maps**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_19_AIS_basal/Plot_Figure/PLOT_shade_melt_rate_maps.py) and [**future maps**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_19_AIS_basal/Plot_Figure/PLOT_shade_future_melt_anomalies_maps.py) |  **Nicolas Jourdain**   | Antarctic basal melt rates |
| [**Figure 9.20**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_20_Glacier_Rate/Fig9_20_Glacier_Rate.png)   | [**Python**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_20_Glacier_Rate/Plot_Figure/SCRIPT/MB_figure_FGD_mar2021_commented.m) |  **Lucas Riuz**   | Glacier mass change rates |
| [**Figure 9.21**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_21_glaciers_changes/Fig9_21_glaciers_change.pnghttps://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_11_BSF/Fig9_11_BSF.pdf)    | [**Python**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_21_glaciers_changes/Plot_Figure/SCRIPT/Relative_glacier_mass_change_figure.m) |  **Lucas Riuz**   | Glacier mass relative to 2015 |
| [**Figure 9.22**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_22_permafrost/Fig9_22_permafrost.pdf)    | [**Python**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_22_permafrost/Plot_Figure/PLOT_AR6_WGI_Fig9-24.py) |  **Gerhard Krinner**   | Permafrost area and changes |
| [**Figure 9.23**]()    | **Python** |  **Gerhard Krinner**   |  |
| [**Figure 9.24**]()    | **Python** |  **Gerhard Krinner**   |  |

## List of sea level figures in Chapter 9 

| Figure (w/ link) | Code (w/ link)| Primary author(s) | Brief description |
| ------------- |:-------------:|:-----:| -----|
| [**Figure 9.25**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_25_SLR_PDFs/Fig9_25_SLR_PDFs.pdf)    | [**Matlab**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_25_SLR_PDFs/Plot_Figure/plot_SLRbarwhisker_RCPs.m) |  **Bob Kopp**   | PDFs of projected Sea Level Rise at 2050 and 2100 under different SSPs |
| [**Figure 9.26**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_26_SL_regional/Fig9_26_SL_regional.pdf)    | [**Matlab timeseries**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_26_SL_regional/Plot_Figure/Plot_SL_Contribution_Timeseries.m) and [**maps**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_26_SL_regional/Plot_Figure/Plot_SL_Contribution_Maps.m) |  **Brodie Pearson**   | Projected sea level change contributions under SSP1-2.6 and SSP5-8.5 |
| [**Figure 9.27**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_27_SL_scenarios/Fig9_27_SL_scenarios.pdf)    | [**Matlab**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_27_SL_scenarios/Plot_Figure/Plot_GMSL_Projected_Scenarios.m)|  **Bob Kopp**   | Projected global mean sea level rise under different SSP scenarios |
| [**Figure 9.28**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_28_RSL_scenarios/Fig9_28_RSL_scenarios.pdf)    | [**Matlab**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_28_RSL_scenarios/Plot_Figure/Plot_RSL_Scenario_Maps.m) |  **Brodie Pearson**   | Regional sea level change at 2100 for different SSP scnearios |
| [**Figure 9.29**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_29_SL_time/Fig9_29_SL_time.pdf)   | [**R code**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_29_SL_time/Plot_Figure/plot_exceedance_year.r) |  **Bob Kopp**   | Projected timing of sea-level rise milestones |
| [**Figure 9.30**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_30_GMSL_Commitment/Fig9_30_GMSL_Commitment.pdf)    | [**Matlab**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_30_GMSL_Commitment/Plot_Figure/plot_SLR_commitments.m) |  **Baylor Fox-Kemper** & **Brodie Pearson**   | 2,000- and 10,000-year sea-level commitments as a function of peak global surface air temperature anomaly |
| [**Figure 9.31**]()    | **Unknown** |  **Mark Hemer** & **Billy Sweet**   |  |
| [**Figure 9.32**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_32_ESL_proj/Fig9_32_ESL_proj.pdf)    | [**Matlab**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Fig9_32_ESL_proj/Plot_Figure/Plot_fig9_32_ESL.m)|  **Tim Hermans** & **Brodie Pearson**   | Median amplification factor of extreme still water level by 2050 and 2100 |

## List of additional figures in chapter 9

| Figure (w/ link) | Code (w/ link)| Primary author(s) | Brief description |
| ------------- |:-------------:|:-----:| -----|
| **Box 9.2**    | Not available yet |  **Thomas Froelicher**   | Marine Heatwaves |
| [**Cross-chapter box Figure 9.1.1**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Cross_Chapter_Box_9_1/CCBox9.1_Figure1_FGD_18x9cm.pdf)   | [**Python/Jupyter notebook**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/Cross_Chapter_Box_9_1/Plot_Figure/plot_AR6_CCBox9.1_FGD.ipynb) |  **Matt Palmer**   | Global energy inverntory and global sea-level budget |
| [**FAQ 9.1**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/FAQ9_1_will_human-induced_changes_be_reversible/FAQ9_1.pdf)    | [**Python**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/FAQ9_1_will_human-induced_changes_be_reversible/Plot_Figure/FAQ9.1_get_timeseries_from_data.py) |  **Sophie Berger**   | Can melting of the ice sheets be reversed? |
| [**FAQ 9.2**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/FAQ9_2_how_much_will_sea_level_rise/FAQ9_2.pdf)    | [**Python**](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Plotting_code_and_data/FAQ9_2_how_much_will_sea_level_rise/Plot_Figure/plot_SL_curves.py) |  **Sophie Berger**    | How much will sea level rise in the next few decades? |
| **FAQ 9.3**    | N/A |  **Sophie Berger**    | Gulf stream shutdown schematic (No quantitative information; not included here) |

## Functions for IPCC processing/analysis
### Matlab Functions
Many of the figures in Chapter 9 use Matlab functions created by Brodie Pearson and Baylor Fox-Kemper. These functions are found in the `Functions` directory,
and the Matlab code within this repository is set up to use these functions automatically.

### ESMValTool recipes
Some of the code uses [ESMValTool](https://github.com/ESMValGroup/ESMValTool) to perform certain pre-processing operations on CMIP ensembles and observational/reanalysis data. 
These operations include: re-gridding onto matching grids, extraction of specific time periods or regions, and temporal/spatial averaging.
**ESMValTool is a tool for processing and plotting CMIP data. In Chapter 9 ESMValTool was used to process some datasets, but it was not used to plot this data.**

ESMValTool uses *recipes* and *diagnostics* which each perform a specific purpose. *Recipes* are used to extract and process the appropriate datasets from CMIP and other sources. *Diagnostics* are used to plot figures (or calculate diagnostics) using this extracted and processed data.
The ESMValTool recipes for Chapter 9 are contained within this directory. The recipes in this repository are designed to crash after processing the data, although you may need to create an empty diagnostic file with the name contained at the end of the recipe, so that ESMValTool thinks it will eventually plot the processed data.
After ESMValTool crashes, the processed data can be extracted from the appropriate pre-processor directory. 
Note that you may need to turn off a flag (such as switching `remove_preproc_dir` to `false`) to save the processed data.

The ESMValTool recipe directory contains:

- A [*config* file](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Functions/ESMValTool_Recipes/config-brodie-Jasmin.yml), which sets various configuration switches including the directories that ESMValTool looks for data sets from CMIP and other sources
- A [`Recipes`](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/tree/main/Functions/ESMValTool_Recipes/Recipes) directory containing the ESMValTool recipes used to extract and process data for Chapter 9. 
- A [`CMIP6_Lists`](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/tree/main/Functions/ESMValTool_Recipes/CMIP6_Lists) directory that contains terminal print outs of the list of available model datasets for a particular experiment and variable combination. Some models have multiple datasets (ensemble), in which case we used the first available dataset (which can be validated by looking at the recipes). This list contains information about the latest version release of each of these model datasets at the time the Chapter 9 figures were created.
- A [`Create_CMIP6_lists.sh`](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/blob/main/Functions/ESMValTool_Recipes/Create_CMIP6_lists.sh) script that was the basis for producing the printouts in the [`CMIP6_Lists` directory](https://github.com/BrodiePearson/IPCC_AR6_Chapter9_Figures/tree/main/Functions/ESMValTool_Recipes/CMIP6_Lists)
