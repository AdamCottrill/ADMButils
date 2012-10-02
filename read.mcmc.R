##' Read in text files produced by AD model build's MCMC functions
##' and create an mcmc object that can be examined using R's built in
##' tools (Coda, mcmcplots ect).
##' 
##' @title read.mcmc
##' @param mcmc.file - the name of or path to the ascii file that
##'    contains the output from admb.
##' @param header - a boolean value indicating whether or not names
##'    of the variables are included in the top row of the mcmc file.
##'    This may or may not be true depending on how tpl was
##'    structured and will have to be checked. 
##' @param burnin - how many simulations should be discarded as the
##'    burnin period.  Any value less than or equal to the number of
##'    simulation is acceptable.
##' @param delimiter - this can be either whitespaces, tabs,
##'    semi-colons or commas. 
##' @param names - this can either be a file name in the same directory
##'    as mcmc.file or a vector of character strings that correspond 
##'    to the columns in the mcmc file.  This argument is maintained for
##'    flexibility.  Incorporating variable names into mcmc file when
##'    it is created and then using header==TRUE is the prefered approach.
##' @param ... - additional arguments to be passed to read.table().
##' @return an mcmc object
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @keywords misc
##' @export

read.mcmc <- function(mcmc.file="mcmc.csv", header = TRUE, burnin=1000,
                      delimiter=",", names=NULL,... ){

    require(coda)  #to convert text file to mcmc object

    mcmc.file <- gsub("[\\]", "/", mcmc.file)  #use slashes in paths
                                        #rather than double back
                                        #slashes
    #Check each of the arguments:
    #does the file exist?
    if(file.exists(mcmc.file) == FALSE){
        stop(paste("The file:'", mcmc.file, "' does not seem to exist."))}

    #delimiter can only be whitespaces, commas, or semi-colons
    match.arg(as.character(delimiter),c(" ",";",",","\t"))
    
    #make sure that header is boolean:
    match.arg(as.character(header),c("TRUE","FALSE"))
    
    # first read in the mcmc file:
    # if the delimiter is a space, the header isn't always read in
    # correctly if the delimiter argument is supplied.
    if(delimiter==' '){
      my.mcmc <- read.table(mcmc.file, header=header,...)  
    } else {
      my.mcmc <- read.table(mcmc.file, header=header, sep=delimiter,...)      
    }
    
    #now we need to try and figure out what is going on with the names
    #was a names argument provided? if not, then return option 4 from
    #above:
    if(header==FALSE){
      if(!is.null(names) & length(names)==1){
         #see if a 'names' is a file that exists
         #if not try pasting on the directory of the mcmc file and
         #test again, if this works re-assign names and read in the
         #files using the new, longer names argument.
         if(file.exists(names)==FALSE){
            if(file.exists(paste(dirname(mcmc.file),"/",names, sep=""))){
              names <- paste(dirname(mcmc.file),"/",names, sep="")
            } else {
              warning(paste(names, " could not be found.",sep=""))
            }
          }
         
          if(file.exists(names)){
            #if the file exists - read it in, check the number of elements
            #and apply them if possible, otherwise, issue a warning.
            my.mcmc.names <- read.table(names, sep=",")
            my.mcmc.names <- as.character(unlist(my.mcmc.names))
            if(length(my.mcmc.names)==ncol(my.mcmc)){
              #remove any trailing or leading whitespaces  
              my.mcmc.names <-sub("^[[:space:]]*(.*?)[[:space:]]*$",
                                  "\\1", my.mcmc.names, perl=TRUE)
              names(my.mcmc) <- my.mcmc.names 
            } else {
              warning(paste("A file '", names,
                "' exists, but it contains the wrong number of elements (",
                length(my.mcmc.names), " instead of ", ncol(my.mcmc),
                "). \nNo names assigned to mcmc object."))
            }
          }  
        } else {
          #if the number of names match the number of columns go ahead
          #and use them:
          if(length(names)==ncol(my.mcmc)){
              #remove any trailing or leading whitespaces  
              names <-sub("^[[:space:]]*(.*?)[[:space:]]*$",
                                  "\\1", names, perl=TRUE)
              names(my.mcmc) <- names
          } else if(length(names)>1 & length(names)!=ncol(my.mcmc)){
              warning ("'names' contains the wrong number of elements (",
                length(names), " instead of ", ncol(my.mcmc),
                "). \nNo names assigned to mcmc object.")
          } #else {
        }            
      }       

    #make sure that each column has a distinct name:
    if(length(names(my.mcmc)) != length(unique(names(my.mcmc)))){
        warn.txt <- "The names in mcmc object may not be unique."
        warning(warn.txt)
    }
    
    #make sure that burn in is a positive number
    if(!is.numeric(burnin) | burnin<0 | burnin > nrow(my.mcmc)) {
        warn.txt <-
        ("The burn in period must be a positive integer less than the number of rows in mcmc.file.")
        warn.txt <-
        paste(warn.txt,"\nNo 'Burn-in' period was removed from the mcmc simulations.",sep="")
        warning(warn.txt)
     } else {
        #discard the burn-in values from the mcmc chain
        my.mcmc <- my.mcmc[(burnin + 1):nrow(my.mcmc),]
     }
    
    #convert the matrix to an mcmc object so that coda functions can
    #work:
    my.mcmc <- try(coda::as.mcmc(my.mcmc), silent=TRUE)
    if(inherits(my.mcmc, what="try-error")){
        stop(my.mcmc[1])
    }

    #my.mcmc <- as.mcmc(my.mcmc)
    return(my.mcmc)
}


