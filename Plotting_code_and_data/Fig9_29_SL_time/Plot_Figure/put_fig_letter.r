#######################################################################
#
# put_fig_letter.r    08 July 2014
#
# Author: Gregory Garner (ggg121@psu.edu)
#
# Function that easily appends a figure letter to the current
# figure.
#
# To use this function, simply source this file:
#   source("put_fig_letter.r")
#
# Version History:
#   1.0 - 08 July 2014 - Initial coding (G.G.)
#
# Note: I wrote this code because I found it difficult to add figure
# letters to plots consistently, especially when using 
# par(mfrow=c(x,y)).  This should help circumvent those difficulties.
#
# THIS CODE IS PROVIDED AS-IS WITH NO WARRANTY (NEITHER EXPLICIT
# NOT IMPLICIT).  I SHARE THIS CODE IN HOPES THAT IT IS USEFUL, 
# BUT I AM NOT LIABLE FOR THE BEHAVIOR OF THIS CODE IN YOUR OWN
# APPLICATION.  YOU ARE FREE TO SHARE THIS CODE SO LONG AS THE
# AUTHOR(S) AND VERSION HISTORY REMAIN INTACT.
#
# Function Name: put.fig.letter
# Parameters:
#   label - The label to append to the current figure
#   location - String describing the location to append 'label'
#     Options are "topleft" (default), "topcenter", "topright",
#     "bottomleft", "bottomcenter", "bottomright".
#   x - The x-coordinate of the 'label' location (default = NULL).
#   y - The y-coordinate of the 'label' location (default = NULL).
#   offset - Adjustments in the (x,y) location of the 'label'
#     (default = c(0,0)).
#
# There must be an open plot in order for the function to work.
# The 'label' parameter is required at the function call, all other
# parameters have default values.  If either 'x' or 'y' are NULL,
# then 'location' is used.  'location' leaves some space along the
# edges in attempt to prevent the letter from being cut-off (i.e.
# outside the figure region).  Use 'offset' for fine-tuning the
# position of the label.  'offset' is applied in all cases, no
# matter if the coordinates for the label are defined by 'x' and 'y'
# or 'location'.  The 'x', 'y', and 'offset' parameters take values
# according to the normalized figure coordinate system.  (0,0)
# corresponds to the lower-left most point of the plot while (1,1)
# corresponds to the upper-right.  Therefore, an 'offset' of
# c(0.1,0.1) will move the label up and to the right by 10% of the
# figure region.  '...' parameters are passed to the 'text' function.
# Type "?text" for more details on those additional parameters.
#
#######################################################################

put.fig.letter <- function(label, location="topleft", x=NULL, y=NULL, 
                           offset=c(0, 0), ...) {
  if(length(label) > 1) {
    warning("length(label) > 1, using label[1]")
  }
  if(is.null(x) | is.null(y)) {
    coords <- switch(location,
                     topleft = c(0.015,0.98),
                     topcenter = c(0.5525,0.98),
                     topright = c(0.985, 0.98), 
                     bottomleft = c(0.015, 0.02), 
                     bottomcenter = c(0.5525, 0.02), 
                     bottomright = c(0.985, 0.02),
                     c(0.015, 0.98) )
  } else {
    coords <- c(x,y)
  }
  this.x <- grconvertX(coords[1] + offset[1], from="nfc", to="user")
  this.y <- grconvertY(coords[2] + offset[2], from="nfc", to="user")
  text(labels=label, x=this.x, y=this.y, xpd=TRUE, ...)
}