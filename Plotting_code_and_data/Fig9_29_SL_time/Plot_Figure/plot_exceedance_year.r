##################################################
#
# plot_exceedance_year.r    10 November 2020
#
# Generates plots of exceedance year uncertainty
# for IPCC AR6 Ch9
#
##################################################

# Directories
main.dir <- "./"
script.dir <- main.dir
res.dir <- paste(main.dir, "/data", sep="")
plot.dir <- paste(main.dir, "/..", sep="")
plotdata.dir <- paste(main.dir, "/Plotted_Data", sep="")

# Options
plot2dev <- TRUE
plottype <- "pdf"
plot.quantiles <- c(0.05,0.17,0.83,0.95)
n.quantiles <- length(plot.quantiles) + 1

# Scenarios
scenarios <- c("ssp126", "ssp585")
scenarios.names <- list("ssp126"="SSP1-2.6","ssp585"="SSP5-8.5")
ssp.reds <- c(29, 132)
ssp.greens <- c(51, 11)
ssp.blues <- c(84, 34)
scenarios.cols <- rgb(ssp.reds, ssp.greens, ssp.blues, maxColorValue = 255)
n.scenarios <- length(scenarios)

# Years
plot.years <- seq(2000,2300,by=100)
n.years <- length(plot.years)

# Heights
heights <- seq(0.5, 2.0, by=0.5)
n.heights <- length(heights)

# Workflows
wf.types <- c(paste("wf_", rep(c(1,2,3), times=2), rep(c("f", "q"), each=3), sep=""), "wf_4")
n.wfs <- length(wf.types)

# Pbox names
pbox.workflows <- matrix(c(1,2,4,5,6,6,7,7), ncol=2, byrow=TRUE)
pbox.names <- c("No acceleration", "Assessed ice sheets", "MICI", "SEJ")
n.pboxes <- length(pbox.names)

# Variable to hold the plotted data
plotted.data <- array(NA, dim=c(n.scenarios, n.pboxes, n.heights, n.quantiles))

# Libraries, functions, and sourced code
library(ncdf4)

# Colors for each workflow
wf.reds <- c(200,53,50,128)
wf.greens <- c(94,165,127,54)
wf.blues <- c(84,197,81,168)
dist.cols <- rgb(wf.reds, wf.greens, wf.blues, maxColorValue = 255)

# Calculate the x coordinates for the
# background polygons
poly.y <- apply(rbind(heights[-1], heights[-n.heights]),2,mean)
poly.y <- c(heights[1] - (poly.y[1]-heights[1]), 
            poly.y, 
            heights[n.heights] + (heights[n.heights]-poly.y[length(poly.y)]))
poly.width <- diff(poly.y)

# Output file name
out.file <- sprintf("%s/Fig9_29_SL_time.%s", plot.dir, plottype)

# Setup the plot device
if(plot2dev) { pdf(out.file, height=4.5, width=5.5, pointsize=10) }
par(mar=c(2.5,2.0,1.5,1.2)+0.1, yaxs="i", xaxs="i")

# Layout the plots
layout(matrix(c(3,3,1,2), byrow=T, ncol=2), heights=c(0.1,0.9))

# Loop over the scenarios
for(i in 1:n.scenarios){
  
  # This fit type
  this.scenario <- scenarios[i]
  
  # Start the plot
  plot.new()
  plot.window(ylim=range(poly.y), xlim=c(2000,2300))
  axis(1, at=plot.years[-length(plot.years)], cex.axis=1.0)
  axis(1, at=2300, label="2300+", cex.axis=1.0)
  mtext(scenarios.names[this.scenario], line=0.2, cex=1.0, font=2, col=scenarios.cols[i])
  poly.cols <- c("gray90", "white")
  for(k in 1:length(heights)){
    polygon(y=c(poly.y[k],poly.y[k],poly.y[k+1],poly.y[k+1]),
            x=c(1900,3000,3000,1900), col=poly.cols[(k%%2)+1], border="black")
  }
  abline(v=seq(2050,2300,by=50), lty=3, col="gray70")
  box()
  
  # Loop over the workflows
  for(j in 1:n.pboxes){
    
    # Which workflows are aggregated into this pbox?
    this.pbox.workflows <- pbox.workflows[j,]
    
    # Initialize variables to hold the individual workflow values
    workflow.seg.lengths <- array(NA, dim=c(length(this.pbox.workflows), n.heights, length(plot.quantiles)))
    workflow.dist.median <- array(NA, dim=c(length(this.pbox.workflows), n.heights))
    
    # Loop over these workflows
    for(k in 1:length(this.pbox.workflows)){
      
      # This workflow
      this.workflow <- wf.types[this.pbox.workflows[k]]
      workflow.file <- sprintf("%s/%s_%s_milestone_figuredata.nc", res.dir, this.workflow, this.scenario)
      workflow.nc <- nc_open(workflow.file)
      
      # Get the heights and quantiles
      nc.heights <- ncvar_get(workflow.nc, "heights")
      nc.qs <- ncvar_get(workflow.nc, "quantiles")
      
      # Load the exceedance year data
      dist.data <- ncvar_get(workflow.nc, "exceedance_years")  #[heights, quantiles]
      
      # Determine the height indices
      height.ind <- which(nc.heights %in% (heights*1000))
      
      # Get the line segment lengths
      workflow.seg.lengths[k,,] <- dist.data[height.ind,-3]
      
      # Get the median
      workflow.dist.median[k,] <- dist.data[height.ind, 3]
      
      # Close the netcdf file
      nc_close(workflow.nc)
    }
    
    # Calculate the pbox values to plot
    seg.lengths <- array(NA, dim=c(n.heights, length(plot.quantiles)))
    low.idx <- which(plot.quantiles < 0.5)
    hi.idx <- which(plot.quantiles > 0.5)
    seg.lengths[,1:length(low.idx)] <- sapply(low.idx, function(x) apply(workflow.seg.lengths[,,x], 2, min))
    seg.lengths[,(length(low.idx)+1):length(plot.quantiles)] <- sapply(hi.idx, function(x) apply(workflow.seg.lengths[,,x], 2, max))
    dist.median <- apply(workflow.dist.median, 2, mean)
    
    # Any value that equals 2300, set to a higher number so it renders off the plot
    seg.lengths[seg.lengths >= 2300] <- 9999
    dist.median[dist.median >= 2300] <- 9999
    
    # Store the plotted data
    plotted.data[i,j,,c(1,2,4,5)] <- seg.lengths
    plotted.data[i,j,,3] <- dist.median
    
    # Determine the y coordinate for this distribution
    this.y <- poly.y[-length(poly.y)] + j*(poly.width/(n.pboxes+1))
    
    # Plot the line segments
    segments(y0=this.y, x0=seg.lengths[,2], x1=seg.lengths[,3],
             col="black", lwd=4.7, lty=1, lend=2)
    segments(y0=this.y, x0=seg.lengths[,1], x1=seg.lengths[,4],
             col="black", lwd=2.7, lty=1, lend=2)
    
    segments(y0=this.y, x0=seg.lengths[,2], x1=seg.lengths[,3],
             col=dist.cols[j], lwd=3.2, lty=1, lend=2)
    segments(y0=this.y, x0=seg.lengths[,1], x1=seg.lengths[,4],
             col=dist.cols[j], lwd=1.2, lty=1, lend=2)
    
    # Plot the median as a point
    points(dist.median, this.y, pch=21, bg=dist.cols[j])
    
    # Append the "legend"
    if(i == 2){
      text(x=2100, y=this.y[1], pos=4, cex=0.85,
           labels=pbox.names[j])
    }
    
  }
  
  # Append the height legend in the corners
  if(i == 1){
    text(x=2000, y=heights[-n.heights]-0.3*(heights[2]-heights[1]), pos=4, cex=0.95,
         labels=sprintf("%0.1f m", heights[-n.heights]), font=2)
    text(x=2000, y=heights[n.heights]-0.3*(heights[2]-heights[1]), pos=4, cex=0.95,
         labels=sprintf("%0.1f meters since 2005", heights[n.heights]), font=2)
  }else{
    text(x=2000, y=heights-0.3*(heights[2]-heights[1]), pos=4, cex=0.95,
         labels=sprintf("%0.1f m", heights), font=2)
  }
  
}

# Start a new plot for the legend only
par(mar=c(0,0,0,0))
plot.new()
plot.window(xlim=c(0,1), ylim=c(0,1))
text(x=0, y=0.7, pos=4, cex=1.3, font=2,
     labels="Projected timing of sea-level rise milestones")
text(x=0, y=0.3, pos=4, cex=1.3,
     labels="Under different forcing scenarios and workflow assumptions")

# Close the plot
if(plot2dev){ dev.off() }

#####################################################################################

# Generate the plotted data files ---------------------------------------------------

# Define the dimension variables
height.ncdim <- ncdim_def("height", "meters", heights)
percentile.ncdim <- ncdim_def("percentile", "", c(plot.quantiles[c(1,2)], 0.5, plot.quantiles[c(3,4)])*100)

# Define the missing value flag
mv <- 9999

# Initialize list for variables
these.vars = vector("list", n.pboxes)

# Loop over the scenarios
for(i in 1:n.scenarios){
  
  # Loop over the pboxes
  for(j in 1:n.pboxes){
    
    # Create the variables for the netcdf file
    these.vars[[j]] <- ncvar_def(gsub(" ", "_", pbox.names[j]), "year", list(height.ncdim, percentile.ncdim), missval = mv)
    
  }
  
  # Create the netcdf file with these variables
  newnc <- nc_create(paste(plotdata.dir, "/Fig9-29_", scenarios[i], "_data.nc", sep=""), these.vars)
  
  # Loop over the pboxes again
  for(j in 1:n.pboxes){
    
    # Append the data to the netcdf file
    ncvar_put(newnc, these.vars[[j]], plotted.data[i,j,,], start=c(1,1), count=c(n.heights, n.quantiles))
    
  }
  
  # Put the additional information into the netcdf file
  ncatt_put(newnc, 0, "title", "Projected timing of sea-level rise milestones under different forcing scenarios and workflow assumptions")
  ncatt_put(newnc, 0, "units", "year (CE)")
  ncatt_put(newnc, 0, "creator", "Gregory Garner (gregory.garner@rutgers.edu)")
  ncatt_put(newnc, 0, "activity", "IPCC AR6 (Chapter 9)")
  ncatt_put(newnc, 0, "comments", paste("Data is for the", scenarios.names[scenarios[i]], "panel of Figure 9.29 in the IPCC Working Group I contribution to the Sixth Assessment Report"))
  ncatt_put(newnc, 0, "missing_value_note", "Missing values indicate a percentile with a value greater than or equal to the time horizon of the projections (>= year 2300)")
  
  # Close the netcdf file
  nc_close(newnc)
  
}