#=============================================================
# /home/adam/Dropbox/Rstuff/MyScripts/DevelopmentSratchPad/read.mcmc/RunTests.R
# Created: September 6, 2012.
#
# DESCRIPTION:
#
# This script run a series of tests to verify the behaviour of
# read.mcmc.  read.mcmc is designed be flexible, accepting mcmc files
# with and with a header, delimited by a number of different possible
# delimiters, and an optional burn-in period.  The tests in this
# script ensure that all of those options are available and return the
# expected mcmc object.  There are also a number of tests at the
# bottom of the scripts that test the warning produced by read.mcmc()
# for mis-matched names or other mis-specified input arguments.
# 
#
# A. Cottrill
#=============================================================

# LIBRARIES:

library(testthat)

#reporter <- 'minimal'
reporter <- 'summary'

#here is where we're working
#HomeDir <-
#  "/home/adam/Dropbox/Rstuff/MyScripts/DevelopmentSratchPad/read.mcmc"
HomeDir <- "c:/1work/DropBox/Dropbox/Rstuff/MyPackages/ADMButils/inst/tests/read.mcmc"
#Answers:
nms     <- c("K", "r", "q", "MSP")
Nrow    <- 19000
Ncol    <- 4

#load the function
#source(paste(HomeDir,"/read.mcmc.R", sep=""))
fctFile <-
  "C:/1work/DropBox/Dropbox/Rstuff/MyPackages/ADMButils/fcts/read.mcmc.R"
source(fctFile)

#============================
#header in file:

#read the mcmc using the default arguments
mcmc.file <- paste(HomeDir, '/wheader/mcmc.csv', sep="")
cat("txt file with header.  Default Args: ")
my.mcmc   <- read.mcmc(mcmc.file)
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#with space as the delimiter 
mcmc.file <- paste(HomeDir, '/wheader/MCMC_Results.txt', sep="")
cat("txt file with header: ")
my.mcmc   <- read.mcmc(mcmc.file, delim=" ")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#read the csv mcmc:
mcmc.file <- paste(HomeDir, '/wheader/mcmc.csv', sep="")
cat("csv file with header: ")
my.mcmc   <- read.mcmc(mcmc.file, delim=",")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#read the tab-delmited mcmc file:
mcmc.file <- paste(HomeDir, '/wheader/mcmctabs.txt', sep="")
cat("tab delimited text file with header: ")
my.mcmc   <- read.mcmc(mcmc.file, delim="\t")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#read the tab-delmited mcmc file:
mcmc.file <- paste(HomeDir, '/wheader/mcmcsemicolons.txt', sep="")
cat("semicolon delimited text file with header: ")
my.mcmc   <- read.mcmc(mcmc.file, delim=";")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#============================
# no header, with associated names file:
mcmc.file <- paste(HomeDir, '/wnames/MCMC_Results.txt', sep="")
cat("txt file without header: ")
my.mcmc <- read.mcmc(mcmc.file, header=FALSE, delim=" ",
                      names="MCMC_Names.txt")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#with space as the delimiter 
mcmc.file <- paste(HomeDir, '/wnames/MCMC_Results.txt', sep="")
cat("txt file without header: ")
my.mcmc   <- read.mcmc(mcmc.file, header=FALSE, delim=" ",
                       names="MCMC_Names.txt")

test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#read the csv mcmc:
mcmc.file <- paste(HomeDir, '/wnames/mcmc.csv', sep="")
cat("csv file without header: ")
my.mcmc   <- read.mcmc(mcmc.file, header=FALSE,
                       delim=",",  names="MCMC_Names.txt")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)


#read the tab-delmited mcmc file:
mcmc.file <- paste(HomeDir, '/wnames/mcmctabs.txt', sep="")
cat("tab delimited text file without header: ")
my.mcmc   <- read.mcmc(mcmc.file, header=FALSE, delim="\t",
                       names="MCMC_Names.txt")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#read the semicolon-delmited mcmc file:
mcmc.file <- paste(HomeDir, '/wnames/mcmcsemicolons.txt', sep="")
cat("semicolon delimited file without header: ")
my.mcmc   <- read.mcmc(mcmc.file, header=FALSE, delim=";",
                       names="MCMC_Names.txt")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)



#============================
# no header, names vector:
.NewNames <-  c("K", "r", "q", "MSP")

mcmc.file <- paste(HomeDir, '/wnames/MCMC_Results.txt', sep="")
cat("txt file with names vector: ")
my.mcmc <- read.mcmc(mcmc.file, header=FALSE, delim=" ",
                     names = .NewNames)
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#with space as the delimiter 
mcmc.file <- paste(HomeDir, '/wnames/MCMC_Results.txt', sep="")
cat("txt file with names vector: ")
my.mcmc   <- read.mcmc(mcmc.file, header=FALSE, delim=" ",
                       names = .NewNames)
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#read the csv mcmc:
mcmc.file <- paste(HomeDir, '/wnames/mcmc.csv', sep="")
cat("csv file with names vector: ")
my.mcmc   <- read.mcmc(mcmc.file, header=FALSE,
                       delim=",",  names = .NewNames)
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)


#read the tab-delmited mcmc file:
mcmc.file <- paste(HomeDir, '/wnames/mcmctabs.txt', sep="")
cat("tab delimited text file with names vector: ")
my.mcmc   <- read.mcmc(mcmc.file, header=FALSE, delim="\t",
                       names = .NewNames)
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#read the semicolon-delmited mcmc file:
mcmc.file <- paste(HomeDir, '/wnames/mcmcsemicolons.txt', sep="")
cat("semicolon delimited file with names vector: ")
my.mcmc   <- read.mcmc(mcmc.file, header=FALSE, delim=";",
                       names = .NewNames)
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#============================
#no header, no names file:
nms <- paste(rep("V", 4),seq(1,4),sep="")

mcmc.file <- paste(HomeDir, '/wonames/MCMC_Results.txt', sep="")
cat("no header, no names: ")
my.mcmc <- read.mcmc(mcmc.file, header=FALSE, delim=" ")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

mcmc.file <- paste(HomeDir, '/wonames/mcmc.csv', sep="")
cat("csv file without header, no names: ")
my.mcmc <- read.mcmc(mcmc.file, header=FALSE, delim=",")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#tab delmited
mcmc.file <- paste(HomeDir, '/wonames/mcmctabs.txt', sep="")
cat("tab delimited file without header, no names: ")
my.mcmc <- read.mcmc(mcmc.file, header=FALSE, delim="\t")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#semi-colon delimited
mcmc.file <- paste(HomeDir, '/wonames/mcmcsemicolons.txt', sep="")
cat("semicolon delimited file header, no names: ")
my.mcmc <- read.mcmc(mcmc.file, header=FALSE, delim=";")
test_file(paste(HomeDir, "/tests/pass.R", sep=""), reporter=reporter)
rm(my.mcmc)

#===============================================================
#now we need to cover edge/error cases that issue warnings:

#'names' file not found
#'names' with too few entries
#'names' with too many entries
#'names' with duplicates


# check burn-in
# burn-in too long
# burn-in negative
# burn-in non-numeric

# mcmc file that contains non-numeric values. (error)

cat("Warnings:\n")
test_file(paste(HomeDir, "/tests/warn.R", sep=""), reporter=reporter)




