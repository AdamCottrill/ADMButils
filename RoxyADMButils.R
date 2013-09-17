# This script documents the steps needed to create an R package
# that has been docmented using roxygen tags (see the roxygen vignette
# for details).
# This script should work 'out of the box' and should be easily
# modified for other R-packages.
# Before creating the package, make sure that you clean out the
# directory, leaving only the source folder (`/fcts) and this file.

# Despite my best efforts, Roxygen does not always update the
# descritpion and package documentation files accurately. I'm nost
# sure why. Specically, the date, version and contact information
# ofthen need to be updated manually.  (see below).  Additionally, the
# pdf version of the manual and any supporting files must be copied to
# the inst directory after the package directories are built.

# A. Cottrill
# Wed Apr 20 2011 09:20:24 
# ==========

#=====================================================

#packages we will need:
library("roxygen2")

#=====================================================
#GLOBALS:
pkg.nm   <- 'ADMButils'
root.dir <- 'C:/1work/R/MyPackages/ADMButils'
pkg.dir  <- 'C:/1work/R/MyPackages/ADMButils'
pkg.dir2 <- 'C:/1work/R/MyPackages/ADMButils/ADMButils'
fct.dir  <- 'C:/1work/R/MyPackages/ADMButils/fcts'

#Home computer (Ubuntu):
## root.dir <- '/home/adam/Dropbox/Rstuff/MyPackages/ADMButils'
## fct.dir  <- '/home/adam/Dropbox/Rstuff/MyPackages/ADMButils/fcts'
## pkg.nm   <- 'ADMButils'
## #this is the directory where the package files will be built
## pkg.dir  <- '/home/adam/R/tmp'
## pkg.dir2  <- '/home/adam/R/tmp/ADMButils'
 


#=====================================================
# this is a character vector of all files that contian our functions
# the list could be compiled from multiple directories (not tested)
(fcts <- 
 list.files(path = fct.dir, pattern = ".[rR]$", full.names=TRUE))

#=====================================================
# create the packages directories and populate them where possible with
# package.skeletion() 
package.skeleton(pkg.nm, path=pkg.dir, force=TRUE, namespace=TRUE,
                 code_files=fcts)


#=====================================================
#now clean up and modify as needed:
file.remove(paste(pkg.dir2,'/Read-and-delete-me', sep=''))

#before you roxygengize the package, replace the dummy DESCRIPTION
#file with the real one for this project:
file.copy(from=paste(fct.dir,'/DESCRIPTION', sep=''),
          to=paste(pkg.dir2,'/DESCRIPTION', sep=''), overwrite=TRUE)

#we also need to move the example data in ~/inst/
#file.copy(from=paste(root.dir,'/inst', sep=''),
#          to=paste(pkg.dir,'/inst', sep=''), overwrite=TRUE, recursive=TRUE)


(.from <- paste(root.dir,"/inst",sep=""))
#(.to   <- paste(pkg.dir,"/inst",sep=""))
#if(file.exists(.to)==FALSE) dir.create(.to, recursive=TRUE) 
file.copy(from=.from, to=pkg.dir2,
          overwrite=TRUE, recursive=TRUE)

#before we go any farther, open the DESCRIPTION file and update:
#    1. the date
#    2. the version number
#    3. Any other fields that need it.
# Note: Much of this information is also in the -package.R file and will
#    need to be sychronized there too after rog(Not the *.Rd file).  It appears as though the
#    information in the DESCRIPTION file is used for the pdf version
#    of the manual, while the -package.R information is used for the
#    on-line help.
#
#=====================================================
#now roxygengize the package to create the documention files from the
#roxygen tags:
roxygenize(pkg.dir2, pkg.dir2, copy.package=FALSE, overwrite=TRUE)
#roxygenize(pkg.dir, root.dir, copy.package=FALSE, overwrite=TRUE)


#make the pdf version of the manual and place it in the correct
#directory:
#shell.cmd <- "Rcmd Rd2pdf --pdf ADMButils"
#shell(shell.cmd)



(.from <- paste(root.dir, "/", pkg.nm, ".pdf",sep=""))
dir.create(paste(pkg.dir2, "/inst/doc/",sep=""))
(.to   <- paste(pkg.dir2, "/inst/doc/", pkg.nm, ".pdf",sep=""))
file.copy(from=.from, to=.to,
          overwrite=TRUE)


#=====================================================
#Finally now open a shell mode, cd to the pkg.dir and issue the following
#commands:
#  Rcmd Rd2dvi --pdf ADMButils  (done above)
#    * Now move pdf to ~/inst/doc/ (done above)
#    * and copy any example files to ~/inst
#
#  Rcmd check admbscaa
#  Rcmd INSTALL --build ADMButils
# for some reason, 


# Gotchas:
# if you have libraries in a non-standard location, put a .Rprofile
# file in the root.dir that contains .libPaths(), otherwise Rcmd check
# will not be able to find libraries you know are installed.

# make sure that c:\Rtools\ is in your Path variable.  If it isnt't,
# most of the build and check functions wiil work, but not all of
# them (e.g. zip).  Even worse, the error message that is thrown is
# less than helpful.

# make sure that any supporting files have bee moved to...?

pkg.zip <- "C:/1work/R/MyPackages/ADMButils/ADMButils_3.0.1.zip"
install.packages(pkg.zip)

#linux:
#From shell, install the package:
#  R CMD INSTALL ADMButils_3.0.0.tar.g
#to create a zipped package for the windows machine, change to the
#package directory and zip it up.  Send the zip file to your windows machine.
# cd /home/adam/R/x86_64-pc-linux-gnu-library/2.15
# zip -r ADMButils ADMButils
