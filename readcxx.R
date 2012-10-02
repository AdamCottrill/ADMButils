##' Read R-objects created by ADMB2R cxx files
##'
##' This function is the work horse of the admnscaa package and
##' replaces scan.scaa().  After a model is
##' run using the ADMB executable, this function will scan in the output files
##' and create an scaa object that can then be analyzed or plotted with the
##' other functions in the package.
##' 
##' Unlike its predicessor, this function relies on the package admb2R
##' written by Prager et al.  This function combines the contents of the cxx
##' file with the contents of the par and report files and returns a scaa
##' object.  An object of class scaa is essentially a named list of the model
##' parameters, selected model inputs and calculated quantities.  This function
##' uses admb.obj() from the ADMButil packages to get the values contained in
##' the *.par and *.std files.  Other quantities are read in from the
##' admb2R  rdat file as specified in the cxx file associated witht the model.
##' 
##' The argument ModelDir can be either the directory were the model files can
##' be found, path and base name of the output files, or any file that contains
##' the path and base name.  For example, all of the following variations would
##' be acceptable: \itemize{ \item"C:/admb/model/" \item"C:/admb/model/model"
##' \item"C:/admb/model/model.rdat" } If the *.rdat, *.std or *.par file can't be
##' found an error will be thrown.
##' 
##' The simple named list structure of the returned scaa object makes it easy
##' to add new components (or write helper functions) using R's append()
##' function.  Similarly, existing components can be easily accessed or
##' extracted.  For example, if a non-standard plot or summary table is
##' desired.
##' 
##' Currently, all of the vectors and matrices contained in the resultant scaa
##' object are named appropriately with years and/or ages.
##
##' 
##' @title Read cxx
##' @param ModelDir the name of a fitted admb object created with
##'        admb2R or the modelling directory.
##' @return a list containing the elements of fitted scaa model
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @keywords misc
##' @export
##' @examples
##' ## MyModel <- system.file("ExampleFiles/aa_02.rdat")
##' ## my.scaa <- readcxx(MyModel)
##' ## names(my.scaa)

readcxx <- function(ModelDir){

    require(ADMButils)
    
    if(!is.character(ModelDir))stop("'ModelDir' must be a character string.")

    FilePath <- admbdir(ModelDir)
    .rdat    <- paste(FilePath$dir,"/",FilePath$base,".rdat",sep="")
    .std     <- paste(FilePath$dir,"/",FilePath$base,".std",sep="")
    .par     <- paste(FilePath$dir,"/",FilePath$base,".par",sep="")
    
    #Verify that the rdat file actually exist
    if(file.exists(.rdat) == FALSE){
      stop(paste("Rdat File: ",.rdat, " does not exist!",sep=""))
    }

    #get the values from the par and std files:
    #(they will through there own errors if the files par or std files can't be found)
    #scaa <- admb.obj(FilePath)
    .par <- read.par(.par)
    .std <- read.std(.std,FALSE)

    #change the names of a couple of variables to match our current naming conventions:
    names(.std) <- gsub("BIOMASS","Biomass",names(.std))
    names(.std) <- gsub("SP_BIO","SpBio",names(.std))
  
    #read in the scaa objects contained in the rdat file: 
    scaa <- dget(.rdat)
    scaa$info$FileDir <- dirname(.rdat)

    #now add the par and std elements:
    scaa$info <- append(scaa$info,.par)
    #this doesn't work quite as expected...
    scaa$std <- .std
    return(scaa)
}

