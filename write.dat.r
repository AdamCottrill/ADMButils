##' Write AD Model Builder *.dat files
##' 
##' write.dat takes a named list and a file name and creates a data input file
##' that can be used by AD Model Builder.
##' 
##' The order of the elements in the resultant *.dat file will be exactly the
##' same as the order in the provided list (L).  If the file name contains a
##' complete path, the dat file will be created at the specified location.  If
##' just a file name is provided, the resultant file will be created in the
##' current working directory.  If names are supplied for the elementes of L
##' they will be included a comment preceeding each element of the dat file.
##' If the element is a data frame, it will also include a comment row
##' containing the names of each column (variable) in the data frame.
##' 
##' Data frames will be printed as matrices in the resultant dat file.  If factors
##' are detected in the dataframe, they will be converted to their numerical
##' equivalent.  If factor.warn is TRUE, comments documenting the factor levels
##' and their numerical equivalents will be included in the dat file.
##' 
##' This function was modified from the dat_write from the glmmADMB package
##' available from \url{ http://otter-rsch.com/admbre/admbre.html }. 
##' 
##' @usage write.dat(L, name, factor.warn = TRUE, silent=FALSE)
##' @param L a list object containing all of the elements required for the
##'   *.dat file
##' @param name a file name, with or without the *.dat file extention
##' @param factor.warn must be boolean (true/false) and is used to indicate
##'   whether or not if the factors should be identified and their numerical
##'   equivalents documented in the *.dat file.
##' @param silent Should a message stating the file name be printed to the
##'   console?
##' @return The function produces a *.dat file at the specified location.
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @seealso \code{\link{write.pin}}
##' @references More information about AD Model Builder can be found here:
##'   \url{ http://admb-project.org/ }
##' @keywords IO utilities
##' @export
##' @examples
##' 
##' #the name of the dat file that will be produced:
##' dat.nm <- paste(getwd(),'/test.dat',sep="")
##' #objects to write out:
##' vec <- rnorm(10)
##' int <- 90
##' num <- pi
##' mat <- matrix(rlnorm(60),ncol=6)
##' dat <- iris
##' a   <- letters[1:6]
##' tab <- table(a, sample(a))
##' 
##' #combine all of the objects into a named list:
##' dat.ls <- list('vector'=vec, 'integer'=int, 'number'=num,
##'                 'matrix'=round(mat,5), 'data frame'=dat,'table'=tab)
##' 
##' #create the dat file:
##' write.dat(dat.ls, dat.nm)
##' #w/o factor level definitions:
##' write.dat(dat.ls, dat.nm, factor.warn=FALSE)
##' 
##' #here is some size and age data:
##' nobs <- 40
##' ages <- c(2, 3, 6, 2, 3, 3, 3, 2, 2, 3, 4, 3, 5, 5, 10, 4, 3, 7, 8, 7, 3, 9, 9, 8, 3, 4, 8, 9, 6, 9, 4, 5, 6, 5, 5, 3, 6, 7, 8, 4)
##' flens <- c(200,230,432,190,248,225,256,205,235,242,288,250,393,373,462,433,176,409,437,467,245,466,462,437,222,287,471,472,445,533,354,350,385,330,380,234,426,530,452,384)
##' #no names in list (or dat file)
##' dat.list <- list(nobs, ages, flens)
##' write.dat(dat.list, "testdat1")
##' 
##' #names in list (and dat file)
##' dat.list <- list("Nobs"=nobs,"Age"=ages,"Fork Lengths"=flens)
##' write.dat(dat.list, "testdat2")
##' 
##' 
write.dat <- function (L, name, factor.warn=TRUE, silent=FALSE)

        #this function was modified from the original version
        #(dat_write).  dat_write did not write out data frames
        #properly as a matrix with names.
        
	#L is a list object containing all of the elements required for the dat file
  
	#name is a complete file name (the complete path must be
	#specified, but the extention is optional)

        #factor.warn is boolean true/false and indicates if the
        #factors should be identified and their numerical equivalents
        #printed in the dat file.

        #silent - should a message stating the file name be printed to
        #the console?
  
  {

      #Check to make sure that L is a list otherwise stop
      if(data.class(L)!="list") {
          obj.nm <- deparse(substitute(L))
          stop(paste("The supplied object ('", obj.nm, "') must be a 'list'.",sep=""))
      }

     #make sure that a file name has been supplied and that it is a
     #character string:
     #if(hasArg("name")==FALSE) stop("Please provide a file name!")
     if(missing("name")==TRUE) stop("Please provide a file name!")      
     if(data.class(name)!="character") {
          file.nm <- deparse(substitute(name))
          stop(paste("The supplied name ('", file.nm, "') must be a 'character'.",sep=""))
      }
      
      
      #--------------------------------------------------
      #print out a small header
      
      brk <- "# =====================================\n"

            n = nchar(name)
      if (substring(name, n - 3, n) == ".dat") 
        file_name = name
      else file_name = paste(name, ".dat", sep = "")
      cat(brk, "# \"", file_name,
           "\" produced from R by write.dat() in MyADMButils; \n# ", 
          date(), "\n", brk, "\n", file = file_name, sep = "")

      #--------------------------------------------------
      for (i in 1:length(L)) {
          x = L[[i]]
          #--------------------------------------------------
          if (data.class(x) == "numeric") {
              cat("#", names(L)[i], "\n ", L[[i]], "\n\n", file = file_name, 
                  append = TRUE)
          #--------------------------------------------------
          } else if (data.class(x) == "matrix" |data.class(x) ==
                     "table") {
              x <- cbind(" ",x)
              cat("#", names(L)[i], "\n", file = file_name, append = TRUE)
              write.table(x, col = FALSE, row = FALSE, quote = FALSE, 
                          file = file_name, append = TRUE)
              cat("\n", file = file_name, append = TRUE)                        
          #--------------------------------------------------
          } else if (data.class(x) == "data.frame"){

              cat("#", names(L)[i], "\n", file = file_name, append = TRUE)

              #--------------------------------------------------         
              #a helper function to convert factors to numeric
              #equivalents and print out any conversions it made:
              conv.fact <- function(z,factor.warn){
                  if(is.factor(z)){
                      if(factor.warn==TRUE){
                          #fac.nm <- deparse(substitute(z))
                          fac.nm <- names(x)[j]
                          lvs <- levels(z)
                          msg <- paste(brk, "# '",fac.nm,
                                       "' was identified as a factor.  \n# The following levels were converted to their numeric equivalents:",
                                       sep="")
                          msg2 <- "\n# "
                          for (q in 1:length(lvs)) {
                              msg2 <- paste(msg2,"\t", q, " - ",
                                            lvs[q], "\n# ", sep="")
                          }
                          msg <- paste(msg,msg2,sep="")
                          cat(msg, file = file_name, append = TRUE)
                      }
                      z <- as.numeric(z)
                  } else {
                      z <- z
                  }
              }  
	      #--------------------------------------------------		
              #apply the function to each column in the data
              #frame
              #NOTE:replace loop with appropriate 'apply' function
              for (j in 1:ncol(x)) {
                  x[,j] <- conv.fact(x[,j],factor.warn)
              }

              #add a column of spaces required by admb:
              x <- cbind(" ",x)
              #append the data frame to the dat file (including
              #variable names:
              var.nms <- paste("\n# ", paste(names(x)[-1], collapse=", "),sep="")
              cat(var.nms, "\n", file = file_name, append = TRUE)
              write.table(x, file=file_name, row.names=FALSE, col.names=FALSE,
                          quote=FALSE, append=TRUE)
              cat("\n", file = file_name, append = TRUE)
          #--------------------------------------------------              
          } else {
              warning(paste("Object ",deparse(substitute(x)),
                            " is not a data class recognized by write.dat (", data.class(x), ").", sep=""))
          }
      cat(brk, file = file_name, append = TRUE)              
      }
      cat("\n", file = file_name, append = TRUE)

      if(silent!=TRUE){print(paste("Wrote file ", file_name, ".",sep=""))}
  }


#======================================================================
#testing:


# #the name of the dat file that will be produced:
# dat.nm <- paste(getwd(),'/test.dat',sep="")
# #objects to write out:
# vec <- rnorm(10)
# int <- 90
# num <- pi
# mat <- matrix(rlnorm(60),ncol=6)
# dat <- iris
# a   <- letters[1:3]
# tab <- table(a, sample(a))                    # dnn is c("a", "")
# 
# #combine all of the objects into a named list:
# dat.ls <- list('vector'=vec, 'integer'=int, 'number'=num,
#                 'matrix'=round(mat,5), 'data frame'=dat,'table'=tab)
# 
# #create the dat file:
# write.dat(dat.ls, dat.nm)
# #w/o factor level definitions:
# write.dat(dat.ls, dat.nm, factor.warn=FALSE)
# 


