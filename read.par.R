##' Read AD Model Builder *.par files.
##'
##' This function scans in an admb *.par file and returns a named list
##' containing the number of parameters in the model, the objective function
##' value, gradient and optionally, the parameter estimates.
##' 
##' If 'reduced' is FALSE, all of the parameter estimates are included as named
##' elements of the returned list.  Usually, the parameter estimates and their
##' associated standard deviations are read in from the std file using the
##' function 'read.std'.
##' 
##' @usage read.par(par.file, reduced = TRUE)
##' @param par.file A character string representing the path to the admb par
##'   file. The ".par" extension is optional.  If a complete path is provided,
##'   read.par will use it, if only a file name is provided, read.par will look
##'   for the *.par file in the current working directory.
##' @param reduced TRUE/FALSE. If FALSE, all of the elements of the *.par file
##'   are returned, if TRUE, a three element, named list containing the number
##'   of parameters, the objective function value and gradient are returned.
##' @return \item{par.cnt }{the number of estimated parameters in the model }
##'   \item{obj.fct }{the value of the objective function } \item{gradient
##'   }{the maximum gradient component at the returned solution.}
##'   \item{parameters }{parameter values at the returned solution.  Each
##'   parameter in the model is returned as a separate named element if
##'   'reduced'==FALSE. }
##' @note read.par can be called directly, but it is more often called by the
##'   wrapper function admb.obj().
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @export
##' @seealso \code{\link{admb.obj}}, \code{\link{read.std}}
##' @references More information about AD Model Builder can be found here:
##'   \url{ http://admb-project.org/ } and \url{
##'   http://otter-rsch.com/admodel.htm }
##' @keywords utilities IO
##' @examples
##' 
##' #using the VonB example that comes with ADMB:
##' par.file <- system.file("Examples/Von_Bert.par", package="ADMButils")
##' par.est <- read.par(par.file)
##' par.long <- read.par(par.file, reduced=FALSE)
##' 
read.par <-
function(par.file,reduced=TRUE){
	## Arguments: par.file - a complete path to the admb par file. The ".par" extention is optional
	##			  reduced  - TRUE/FALSE, if false, all of the elements of the par file are returned, if true, a three element, named list containing
	##						 the number of parameters, the objective function value and gradient are returned.  
	## ----------------------------------------------------------------------
	## Purpose: This function scans in an admb par file and returns a names list contiaining the number of parameters, objective function value 
	##			and gradient are returned. If reduced is FALSE, all of the parameter estimates are included as named elements of 
	#			the list.  Usually, the parameter estimates and their associated standard deviations are read in from the std file using read.std
	## ----------------------------------------------------------------------
	## Author: A. Cottrill     Date:  August 13, 2009
	
	##' n = nchar(par.file)
	##' if (substring(par.file, n - 3, n) == ".par"){
	##' 	file_name = par.file
	##' } else {
	##' 	file_name = paste(par.file, ".par", sep = "")
	##' }

        .par <- admbdir(par.file)
        file_name <- paste(.par$dir,"/",.par$base,".par",sep="")

        if(!file.exists(file_name)){
           stop(paste("The file: ", file_name, "does not exist!",sep=""))
        }
        
	jj <- scan(file_name, what="")
	jj <- sub(':','',jj)
	#the first three values are in a fixed location in every dat file:
	par.cnt  <- as.numeric(jj[6])
	obj.fct  <- as.numeric(jj[11])
	gradient <- as.numeric(jj[16])
	
	pars <- list("par.cnt"=par.cnt, "obj.fct"=obj.fct, "gradient" = gradient)
	
	if(reduced==FALSE){
		jj 	 <- jj[-(1:16)]
		hash <- which(jj=="#")					#the locations of the hash marks indicating a parameter name follows
		jj.a <- hash + 2						#the start of each parameter element
		jj.b <- c(hash - 1, length(jj))			
		jj.b <- jj.b[-1]						#the end of each parameter element
		jj.l <- jj.b-jj.a + 1					#the length of each parameter element
		#here are the single parameter values
		xx 		 <- as.numeric(jj[jj.a[jj.l==1]])
		xx.names <- jj[jj.a[jj.l==1]-1]		#there names
		
		#convert the vector of parmeter estiamtes to a list with appropriate names
		xx 		  <- sapply(xx,list)
		names(xx) <- xx.names
		
		#here are the parameter elements that are more than one element long (i.e. vectors)
		if (length(jj.l[jj.l>1])>0){
			for (i in 1:length(jj.a[jj.l>1])){
				vv <- list(as.numeric(jj[jj.a[jj.l>1][i]:jj.b[jj.l>1][i]]))
				names(vv) <- jj[jj.a[jj.l>1]-1][i]
				xx <- append(xx,vv)
			}
		}
		pars <- append(pars,xx)
	}	
	return(pars)
}

