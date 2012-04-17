##' Utilities to read and write files associated with AD Model Builder. ~~
##' ADMButils ~~
##' ADMButils contains a number of functions that read and write *.std, *.par,
##' *.pin and *.dat files associated with AD Model Builder.
##' 
##' \tabular{ll}{
##'     Package: \tab ADMButils\cr
##'     Type: \tab Package\cr
##'     Version:
##'     \tab 2.0.1\cr
##'     Date: \tab 2011-09-01\cr
##'     License: \tab GLP\cr
##'     LazyLoad: \tab
##'     yes\cr
##' }
##' The functions provided in ADMButils fall into two categories -
##' those that write files and those that read ADMB output and return
##' R-objects.  The functions write_dat and write_pin are used to produce dat
##' and pin files respectively.  The functions write_dat and write_pin are
##' modified from the glmmADMB package (available from \url{
##' http://otter-rsch.com }).
##' 
##' The functions read.std, read.par, and admb.obj all return R-objects
##' contained in the std and par files produced by ADMB. adbm.obj is simply a
##' wrapper function that first calls read.par and then calls read.std.
##' 
##' @name ADMButils-package
##' @aliases ADMButils-package ADMButils
##' @docType package
##' @author Adam Cottrill
##' 
##' Maintainer: Adam Cottrill <adam.cottrill@@ontario.ca>
##' @references More information about AD Model Builder can be found here:
##'   \url{ http://admb-project.org/ }
##' @keywords package
##' @examples
##' 
##' ##' #here are a couple of example files
##' par.file <- system.file("Examples/vonb_francis.par",package="ADMButils")
##' std.file <- system.file("Examples/vonb_francis.std", package="ADMButils")
##' 
##' read.par(par.file)
##' read.std(std.file)
##' 
##' 
NULL



