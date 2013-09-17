##'  Function to read a basic AD Model Builder fit.
##' 
##' Use for instance by:
##' simple.fit <- read.fit('c:/admb/examples/simple') Then the object
##' 'simple.fit' is a list containing sub-objects names', 'est',
##' 'std', 'cor', and 'cov' for all model  parameters and sdreport
##' quantities.  Originally from:
##' \url{http://admb-project.org/courses/old-courses-and-course-material/july-2009/DataInOut.pdf}
##' @title read.fit()
##' @param file the base name of the admb files to read (i.e. w/o any extension)
##' @return a list of admb values and estimates.  List contains the
##'   following elements:
##'   \item{nopar}{the number of parameters in the fitted model}
##'   \item{nlogl}{the value of the objective function}
##'   \item{maxgrad}{the maximum gradient of the objective fucntion at
##' the current solution.}
##'   \item{est}{A named vector of the parameter estimates.}
##'   \item{std}{A named vector of the standard deviation of each estimate.}
##'   \item{cor}{The estiamted correlation matrix.}
##'   \item{cov}{The estiamted covariance matrix.}
##' @author blatently copied by Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @export
##' @seealso \code{\link{orgfit}}, \code{\link{orgpar}}
##' @references More information about AD Model Builder can be found here:
##'   \url{ http://admb-project.org/ } and \url{
##'   http://otter-rsch.com/admodel.htm }
##' @keywords utilities IO

read.fit<-function(file){

   admb <- admbdir(file)
   par.file <- paste(admb$dir,"/", admb$base,".par",sep="")
   if(!file.exists(par.file)){
      stop(paste("The par file: ",
         par.file," could not be found.",sep=""))
    }       
    
    ret     <- list()
    parfile <- as.numeric(scan(par.file,
               what='', n=16, quiet=TRUE)[c(6,11,16)])
    ret$nopar      <- as.integer(parfile[1])
    ret$nlogl      <- parfile[2]
    ret$maxgrad    <- parfile[3]

   #now get the information from the correlation file:
    cor.file <- paste(admb$dir,"/", admb$base,".cor",sep="")
    if(!file.exists(cor.file)){
      stop(paste("The cor file: ",
         cor.file," could not be found.",sep=""))
    } else {       
    lin            <- readLines(cor.file)
    ret$npar       <- length(lin)-2
    ret$logDetHess <- as.numeric(strsplit(lin[1], '=')[[1]][2])
    sublin         <- lapply(strsplit(lin[1:ret$npar+2], ' '),function(x)x[x!=''])
    ret$names      <- unlist(lapply(sublin,function(x)x[2]))
    ret$est        <- as.numeric(unlist(lapply(sublin,function(x)x[3])))
    ret$std        <- as.numeric(unlist(lapply(sublin,function(x)x[4])))
    ret$cor        <- matrix(NA, ret$npar, ret$npar)
    corvec         <- unlist(sapply(1:length(sublin), function(i)sublin[[i]][5:(4+i)]))
    ret$cor[upper.tri(ret$cor, diag=TRUE)] <- as.numeric(corvec)
    ret$cor[lower.tri(ret$cor)] <- t(ret$cor)[lower.tri(ret$cor)]
    ret$cov        <- ret$cor*(ret$std%o%ret$std)
}
    return(ret)
}



