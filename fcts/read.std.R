##' Retrieve parameter estimates and standard deviations from AD Model Builder
##' *.std files
##' 
##' Read in the parameter estimates and their associated standard errors from
##' an AD Model Builder *.std file
##' 
##' If 'as.df' is TRUE, the returned object will be a rectangular data frame
##' with columns 'Name', 'Estimate', 'StDev'.  If 'as.df' is FALSE, the
##' returned object is a named list.  Standard deviations are identified in the
##' named list by a '.sd' suffix.  The list elements are sorted alphabetically
##' by name. The 'as.df'=TRUE option is particularly useful for model summaries
##' and 'pretty' printing using Sweave().  The named list returned by read.std
##' is sorted alphabetically, but includes both model parameters and calculated
##' or estimated quantities.  The values in the returned data frame are
##' unsorted and appear exactly as they appear in the AD Model Builder *.std
##' file.  If the model estimates n parameters, the first n rows of the data
##' frame will contain the estimated parameters.  The remaining rows in the
##' data frame correspond to estimated quantities.
##' 
##' @usage read.std(std.file, as.df = TRUE)
##' @param std.file A character string representing the path to the admb *.std
##'   file. The ".std" extension is optional.  If a complete path is provided,
##'   read.std will use it, if only a file name is provided, read.std will look
##'   for the *.std file in the current working directory.
##' @param as.df TRUE/FALSE - should the returned object be a named list or
##'   three column data frame?
##' @return A rectangular dataframe with columns 'Name', 'Estimate', 'StDev' OR
##'   a named list of the form: \item{par1 }{estimate for parameter1}
##'   \item{par1.sd }{standard deviation associated with the estimate for
##'   parameter1 } ...
##' @note read.std can be called directly, but it is often called by the
##'   wrapper function admb.obj().
##' @author Adam Cottrill
##' @seealso \code{\link{read.par}}, \code{\link{admb.obj}},
##' @references More information about AD Model Builder can be found here:
##'   \url{ http://admb-project.org/ } and \url{
##'   http://otter-rsch.com/admodel.htm }
##' @keywords IO utilities
##' @export
##' @examples
##' 
##' #using the VonB example that comes with ADMB:
##' std.file <- system.file("Examples/Von_Bert.std", package="ADMButils")
##' std.list <- read.std(std.file, as.df=FALSE)
##' std.df <- read.std(std.file, as.df=TRUE)
##' std.df2 <- read.std(std.file)
##' 
read.std <-
function(std.file,as.df=TRUE){

   admb <- admbdir(std.file)
   std.file<- paste(admb$dir,"/", admb$base,".std",sep="")
   if(!file.exists(std.file)){
      stop(paste("The std file: ",
         std.file," could not be found.",sep=""))
    }       

   jj <- scan(std.file, what="")
    jj <- jj[-(1:5)]
	jj.names <- jj[seq(2,(length(jj)),4)] 
	jj.vals  <- as.numeric(jj[seq(3, (length(jj)), 4)])
	jj.sdevs <- as.numeric(jj[seq(4, (length(jj)), 4)])
	if(as.df==TRUE){
		#just return a retangular dataframe of parameter names, estimates and standard deviations
    	jj.est <- data.frame("Name"=jj.names, "Estimate"=jj.vals, "StDev"=jj.sdevs)
	} else {
		#first get the elements of length one
		zz   <- as.data.frame(table(jj.names))				#name and length of each element
		zz.1 <- as.character(zz$jj.names[zz$Freq==1])		#subset of elements with one value (not vectors)
		nms  <- jj.names[is.element(jj.names, zz.1)]			#there names
		vals <- jj.vals[is.element(jj.names, zz.1)]			#there values
		sds  <- jj.sdevs[is.element(jj.names, zz.1)]			#there standard deviations
		
		jj.est 		  <- sapply(vals,list)			#create a named list of estimates 
		names(jj.est) <- nms
		
		jj.sd 		  <- sapply(sds,list)					#create a named list of standard deviations
		names(jj.sd)  <- paste(nms,".sd",sep="")
		
		jj.est 		  <- append(jj.est,jj.sd)				#append the estimates to the sd's
		jj.est 		  <- jj.est[sort(names(jj.est))]
		
		if(length(zz$Freq[zz$Freq>1])>0){
			#now get all of the elements that are longer than one one value (i.e. - vectors)
			zz.9 <- as.character(zz$jj.names[zz$Freq > 1])
			nms  <- jj.names[is.element(jj.names, zz.9)]		#the names
			vals <- jj.vals[is.element(jj.names, zz.9)]			#the estimates
			sds  <- jj.sdevs[is.element(jj.names, zz.9)]		#the standard deviations
		
			xx <- list()										#an empty list to temporarily hold the vectors
			for (i in 1:length(zz.9)){
				vecs 		<- list(vals[which(nms==zz.9[i])])	#extract the estimates for this element
				names(vecs) <- zz.9[i]
				vecs.sd 	<- list(sds[which(nms==zz.9[i])])	#extract the st devs for this element
				names(vecs.sd) <- paste(zz.9[i],".sd",sep="")
				jj.est 		<- append(jj.est,vecs)				#add them to the existing list
				jj.est 		<- append(jj.est,vecs.sd)
			}
			#jj.est <- append(jj.est,xx)
			jj.est <- jj.est[sort(names(jj.est))]				#sort by element name (so that we can find things)
		}
	}
    return(jj.est)
    }

