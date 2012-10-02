##' Parse admb file and directory names 
##'
##' The argument admb can be either the directory were the model files can
##' be found, path and base name of the output files, or any file that contains
##' the path and base name.  For example, all of the following variations would
##' be acceptable: \itemize{ \item"C:/admb/model/" \item"C:/admb/model/model"
##' \item"C:/admb/model/model.rdat" } admbdir()
##' makes no attempt to verify that the file actually exists.
##' To create the complete filename, including path and file
##' extension, use paste() to combine the elements of the returned
##' list (see examples below).
##
##' @title admbdir 
##' @param admb a character string representing the modelling
##directory or model file name (with or without file extension) 
##' @param ext a file extinsion to use by default.
##' @return a named list consisting of three elements - dir, base and ext.
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @keywords misc
##' @export
##' @examples       
##' ## My.file  <- "/home/Modelling/Documents/Documents.rdat"        
##' ## (jj <- admbdir(My.file))    
##' ## My.file2 <- "/home/Modelling/Documents/Documents"        
##' ## (jj <- admbdir(My.file2))
##' ## My.dir   <- "/home/Modelling/Documents"
##' ## (jj <- admbdir(My.dir))    
##'         
##' #current working directory is used if a fully specified path isn't
##' #provided
##' (jj <- admbdir("Test"))      
##' (jj <- admbdir("Test.par"))  
##' 
##' #use paste to build fully speficied path:
##' (paste(jj$dir, "/", jj$base, jj$ext, sep = ""))
##' 
admbdir <- function(admb,ext="rdat"){
lookfor <- list(dir=getwd(), base=NA,ext=paste(".",ext,sep=""))
   # print(admb)
  #find out if there is a directory associated with admb or not:
  if(dirname(admb)==".") {
      if(grepl("\\.[^.]+$", admb)){
          #scenario # 1.
           .ext <- substr(admb, start=grep("\\.",
              unlist(strsplit(admb, ""))), stop=10000)
           .base <- gsub(.ext, "", admb)
           #lookfor <- list(dir=NA,base=.base,ext=.ext)
           lookfor$base <- .base
           lookfor$ext  <- .ext
           #print("admb was a file WITH an extention.")
      } else {
          #scenario # 1b.
          #print("admb was a file WITHOUT an extention.")
          #lookfor <- list(dir=NA,base=admb,ext=NA)
          lookfor$base <- admb          
      }
  } else if(basename(dirname(admb))==basename(admb)){
       #print("Scenario #3 - a complete path without an extension.")
       #lookfor <- list(dir=dirname(admb),base=basename(admb),ext=NA)
       lookfor$dir  <- dirname(admb)
       lookfor$base <- basename(admb)       
    } else {
       #ok so either we have a complete file and path or we have
       #simple directory 
         short <- basename(admb)
         if(grepl("\\.[^.]+$", admb)){
           .ext <- substr(short, start=grep("\\.",
              unlist(strsplit(short, ""))), stop=10000)
           .base <- gsub(.ext, "", short)
           #print("admb must have been a complete path and file WITH an extention.")
           #lookfor <- list(dir=dirname(admb),base=.base,ext=.ext)
           lookfor$dir  <- dirname(admb)
           lookfor$base <- .base
           lookfor$ext  <- .ext
       } else {
           #print("admb was just a plain directory.")
           #lookfor <- list(dir=admb,base=NA,ext=NA)
           lookfor$dir  <- admb
           lookfor$base <- basename(admb)
       }       
  }
#lookfor <- paste("Looking for: ",lookfor$dir,"/",lookfor$base,lookfor$ext,sep="")
#print(lookfor)
return(lookfor)
}
