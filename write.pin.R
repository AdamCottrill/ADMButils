##' Create *.pin files for AD Model Builder
##' 
##' write.pin produces a file containing starting values for model written
##' using AD Model Builder.
##' 
##' write.pin has been adapted from the glmmADMB package which can be found
##' here: \url{ http://otter-rsch.com/admbre/admbre.html }. The order of the
##' elements in the provided list determines the order of values contained in
##' the resultant pin file.  These must match the order expected by AD Model
##' Builder.  The *.pin file extension is optional.  If a complete path is
##' provided, a *.pin file will be created in the specified directory.  If only
##' a character string is provided, the *.pin file will be created in the
##' current working directory.
##' 
##' write.pin is particularly useful for evaluating the stability of model
##' estimates given different starting values.  See the examples below for
##' more details.
##' 
##' @usage write.pin(L, name)
##' @param L a list of starting values.
##' @param name a character string that will be used to name the resultant
##'   *.pin file.
##' @return No value is returned to R.  The specified *.pin file is created.
##' @note write.pin has been modified from the glmmADMB package.
##' @author Hans Skaug
##' @seealso %\code{\link{par_read}}, %\code{\link{std_read}},
##'   \code{\link{write.dat}}
##' @references More information about AD Model Builder can be found here:
##'   \url{ http://admb-project.org/ } and \url{
##'   http://otter-rsch.com/admodel.htm }
##' @keywords misc IO
##' @export
##' @examples
##' 
##' #here is an example of using the last par file as the basis for the pin file
##' #using the VonBert example that ships with ADMB
##' par.file <- system.file("Examples/Von_Bert.par", package="ADMButils")
##' jj <- read.par(par.file, reduced=FALSE)		#save the model parameters as a list 'jj'
##' (jj)                                            #see what we have
##' jj$obj.fct <- NULL				#remove the log-likelihood and gradient components - not used in a pin file
##' jj$gradient <- NULL
##' jj$par.cnt <- NULL
##' pin.file <- sub(".par",".pin", par.file)        #change the file extension
##' write.pin(jj, pin.file)		#create a pin file using the parameter estimates in jj
##' 
##' #alternatively, we can build the list of starting values 'manually':
##' pins <- list('Linf'=660, 'k'=0.25, 't0'=0.0)
##' write.pin(pins, pin.file)	
##' 
##' #also possible to create random starting values using R's build in
##' # functions:
##' (pins <- list('Linf'=rnorm(1,660, 100), 'k'= rnorm(1,0.25,0.1),
##' 't0'=rnorm(1, 0, 0.1)))
##' write.pin(pins, pin.file)	
##' 
##' 
write.pin <-
function (L,name) 
{
	#name is a complete file name (the complete path must be specified, but the extention is optional)
	#L is a list object containing all of the elements required for the dat file
	n = nchar(name)
	if (substring(name, n - 3, n) == ".pin") 
		file_name = name
	else file_name = paste(name, ".pin", sep = "")
	cat("# \"", file_name, "\" produced by pin_write() from MyADMButils; ", 
			date(), "\n", file = file_name, sep = "")
	for (i in 1:length(L)) {
		x = L[[i]]
		if (data.class(x) == "numeric") 
			cat("#", names(L)[i], "\n", L[[i]], "\n\n", file = file_name, 
					append = TRUE)
		if (data.class(x) == "matrix") {
			cat("#", names(L)[i], "\n", file = file_name, append = TRUE)
			write.table(L[[i]], , col.names = FALSE, row.names = FALSE, quote = FALSE, 
					file = file_name, append = TRUE)
			cat("\n", file = file_name, append = TRUE)
		}
	}
}

