##' Read \*.par and \*.std files from AD model Builder
##' 
##' admb.obj is simply a wrapper function for the read.par and read.std
##' functions.
##' 
##' admb.obj is a wrapper function for read.par and read.std. It returns a
##' named list containing the parameter count, objective function and gradient,
##' plus parameter estimates and their associated standard errors. Additional
##' values and vectors included in the *.std file are also returned.  Parameter
##' estimates and standard deviations are returned in alphabetical order.
##' Standard deviation estimates are denoted by a *.std suffix.
##' 
##' @usage admb.obj(admb.file)
##' @param admb.file admb.file can be a directory to the admb files or complete
##'   path to the *.par or *.std files. Alternatively, admb file can
##'   be the file name with or without an extention or complete path, in
##'   which case, admb.file is assumed to be in the current working directory.
##' @return 
##'   \item{par.cnt }{The number of parameters fit by AD Model Builder}
##'   \item{obj.fct }{The value of the objective function at the solution.}
##'   \item{gradient }{The maximum gradient at the solution.}
##'   \item{parameter.est }{The value of each parameter and sd report quantity}
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @seealso \code{\link{read.par}} \code{\link{read.std}}
##' @references More information about AD Model Builder can be found here:
##'   \url{ http://admb-project.org/ }
##' @keywords utilities IO
##' @export
##' @examples
##' 
##' #using the VonB example that comes with ADMB:
##' admb.file <- system.file("Examples/Von_Bert.par", package="ADMButils")
##' admb <- admb.obj(admb.file)
##' 
admb.obj <-
function(admb.file){
	## Arguments:admb.file can  be a directory to the admb files or complete path to the par or std files
	## ----------------------------------------------------------------------
	## Purpose: A wrapper function for read.par and read.std
	## 			Returns a named list containing the parmeter count, objective function and gradient, plus parameter estimates
	##		    All off the values and vectors in the std file are included in the list
	## ----------------------------------------------------------------------
	## Author: A. Cottrill     Date:  August 13, 2009
	
	#if there is an extenstion on the end of the filename, strip it off so that we can use the base name 
	#for both par and std files
	##' n <- nchar(admb.file)
	##' admb.file <- ifelse(substring(admb.file,n-3,n)==".par"|substring(admb.file,n-3,n)=='.std', substring(admb.file,1,n-4), admb.file)
	##' admb.dir  <- dirname(admb.file)
	##' admb.base <- basename(admb.file)
	##' par.file  <- paste(admb.dir,'/', admb.base,'.par',sep='') 	
	##' std.file  <- paste(admb.dir,'/', admb.base,'.std',sep='')

##           admb <- admbdir(admb.file)
##           par.file <- paste(admb$dir,"/", admb$base,".par",sep="")
##           std.file <- paste(admb$dir,"/", admb$base,".std",sep="")
##   
##   	if(file.exists(par.file)==FALSE){
##                   stop(paste("The par file: ", par.file," could not be found.",sep=""))
##   	} else {
##   		pars <- read.par(par.file)	
##   	}
##   		
##   	if(file.exists(std.file)==FALSE){
##   		warning(paste("The std file: ", std.file," could not be found.",sep=""))
##   		stds <- list() #keep from appending nothing 
##   	} else {
##   		stds <- read.std(std.file, as.df=FALSE)	
##   	}
##   	#--------------------------------------------------------------------------------------------

        #all of the error checking is done in the read functions.
        #Just call them and stick them together:
	pars <- read.par(admb.file)	
        stds <- read.std(admb.file, as.df=FALSE)	
	obj <- append(pars,stds)
	return(obj)
}

