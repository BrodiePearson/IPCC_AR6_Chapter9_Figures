README

Description of the data
=======================

The data set consists of the following comma-separated values (CSV) files:

A1-A4  upper_branch_forcrate_{0.001,0.0005,0.0002,0.0001}_degC_year-1.csv

       Quasi-static simulations of the upper hystersis branch for different global mean 
       temperature forcing rates (0.001, 0.0005, 0.0002 & 0.0001 degrees Celsius per year), 
       using the reference model parameters.

B1-B4  lower_branch_forcrate_{0.001,0.0005,0.0002,0.0001}_degC_year-1.csv

       Quasi-static simulations of the lower hystersis branch for different global mean 
       temperature forcing rates (-0.001, -0.0005, -0.0002 & -0.0001 degrees Celsius per year), 
       using the reference model parameters.

C      upper_branch_equilibrium.csv

       Equilibrium simulations forked from the upper reference hystersis branch, 
       using the reference model parameters.

D      lower_branch_equilibrium.csv

       Equilibrium simulations forked from the lower reference hystersis branch, 
       using the reference model parameters.

E      upper_branch_forcrate_0.0001_degC_year-1_parameter_sensitivity.csv

       Quasi-static simulations of the upper hystersis branch of all members of the 
       model parameter sesitivity ensemble, using the reference global mean temperature 
       forcing rate (0.0001 degrees Celsius per year).

F      lower_branch_forcrate_0.0001_degC_year-1_parameter_sensitivity.csv

       Quasi-static simulations of the lower hystersis branch of all members of the 
       model parameter sesitivity ensemble.using the reference global mean temperature 
       forcing rate (-0.0001 degrees Celsius per year).


The columns in files A-D are as follows:

    Global mean temperature change (in degrees Celsius), 
    Antarctic mean surface air temperature change (in degrees Celsius), 
    Sea-level relevant ice volume (in meters sea-level equivalent)

The columns in files E-F are as follows:

    Global mean temperature change (in degrees Celsius), 
    Antarctic mean surface air temperature change (in degrees Celsius), 
    Sea-level relevant ice volume (in meters sea-level equivalent) for the following varied 
    model parameters:
        Ice-flow enhancement factor for SSA velocities of 0.6,
        Pseudo-plastic sliding law exponent of 0.5,
        Pseudo-plastic sliding law exponent of 0.25,
        Decay rate of subglacial meltwater in the till layer of 3 mm year-1,
        Decay rate of subglacial meltwater in the till layer of 5 mm year-1,
        Upper mantle viscosity of 5e20 pascal-seconds,
        Upper mantle viscosity of 1e20 pascal-seconds,
        Upper mantle viscosity of 1e19 pascal-seconds,
        Ice-shelf removal at continental shelf margin,
        Horizontal model grid resolution of 8 km
        
