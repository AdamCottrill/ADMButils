# this file contains a number of tests that should be true for an mcmc
# object created by read.mcmc that include warnings

# Nrow, Ncol and nms are defined in the calling script.



test_that("'names' file not found",{
    
    cat("'names' file not found: ")
    mcmc.file <- paste(HomeDir, '/wnames/mcmc.csv', sep="")
    nms <- paste(rep("V", 4),seq(1,4),sep="")

    expect_that(my.mcmc <- read.mcmc(mcmc.file, header=FALSE,
                        delim=",", names="NoNames.txt"),
           gives_warning())
    expect_that(my.mcmc, is_a("mcmc"))
    expect_that(dim(my.mcmc)[1], equals(Nrow))
    expect_that(dim(my.mcmc)[2], equals(Ncol))
    expect_that(varnames(my.mcmc), is_identical_to(nms))
    rm(my.mcmc)
})

test_that("'names' file with too many entries",{

    cat("\n'names' file with too many entries: ")
    .NewNames <-  c("K", "r", "q", "MSP","TooMany")
    nms <- paste(rep("V", 4),seq(1,4),sep="")
    mcmc.file <- paste(HomeDir, '/wnames/MCMC_Results.txt', sep="")

    expect_that(my.mcmc <- read.mcmc(mcmc.file, header=FALSE, delim=" ",
                      names = .NewNames), gives_warning())
    expect_that(my.mcmc, is_a("mcmc"))
    expect_that(dim(my.mcmc)[1], equals(Nrow))
    expect_that(dim(my.mcmc)[2], equals(Ncol))
    expect_that(varnames(my.mcmc), is_identical_to(nms))
    rm(my.mcmc)
})



test_that("'names' file with too few entries",{

    cat("\n'names' file with too few entries: ")    
    .NewNames <-  c("K", "r","TooFew")
    nms <- paste(rep("V", 4),seq(1,4),sep="")
    mcmc.file <- paste(HomeDir, '/wnames/MCMC_Results.txt', sep="")
 
    expect_that(my.mcmc <- read.mcmc(mcmc.file, header=FALSE, delim=" ",
                      names = .NewNames), gives_warning())
    expect_that(my.mcmc, is_a("mcmc"))
    expect_that(dim(my.mcmc)[1], equals(Nrow))
    expect_that(dim(my.mcmc)[2], equals(Ncol))
    expect_that(varnames(my.mcmc), is_identical_to(nms))
    rm(my.mcmc)
})

context("'names' with duplicates")
test_that("'names' with duplicates",{

    cat("\n'names' with duplicates: ")
    .NewNames <-  c("K", "r", "Same", "Same")
    nms <-  c("K", "r", "Same", "Same")
    mcmc.file <- paste(HomeDir, '/wnames/MCMC_Results.txt', sep="")
    expect_that(my.mcmc <- read.mcmc(mcmc.file, header=FALSE, delim=" ",
                     names = .NewNames), gives_warning())

    expect_that(my.mcmc, is_a("mcmc"))
    expect_that(dim(my.mcmc)[1], equals(Nrow))
    expect_that(dim(my.mcmc)[2], equals(Ncol))
    expect_that(varnames(my.mcmc), is_identical_to(nms))
    rm(my.mcmc)
})


# mcmc file that contains non-numeric values.

# check burning
# burn in too long
# burn in negative
# burn in non-numeric


# no header, names vector:

test_that("Burn in too long:",{

    cat("\nBurn in too long: ")
    .NewNames <-  c("K", "r", "q", "MSP")
    #answers:
    nms <-  c("K", "r", "q", "MSP")
    Nrow2 <- 20000
     
    mcmc.file <- paste(HomeDir, '/wnames/mcmc.csv', sep="")
    expect_that(my.mcmc   <- read.mcmc(mcmc.file, header=FALSE, burnin=25000,
                           delim=",",  names = .NewNames), gives_warning())
    expect_that(my.mcmc, is_a("mcmc"))
    expect_that(dim(my.mcmc)[1], equals(Nrow2))
    expect_that(dim(my.mcmc)[2], equals(Ncol))
    expect_that(varnames(my.mcmc), is_identical_to(nms))
    rm(my.mcmc)
})



test_that("Burn-in is negative:",{

    cat("\nBurn-in is negative: ")
    .NewNames <-  c("K", "r", "q", "MSP")
    #answers:
    nms <-  c("K", "r", "q", "MSP")
    Nrow2 <- 20000
     
    mcmc.file <- paste(HomeDir, '/wnames/mcmc.csv', sep="")
    expect_that(my.mcmc   <- read.mcmc(mcmc.file, header=FALSE, burnin=-1000,
                           delim=",",  names = .NewNames), gives_warning())
    expect_that(my.mcmc, is_a("mcmc"))
    expect_that(dim(my.mcmc)[1], equals(Nrow2))
    expect_that(dim(my.mcmc)[2], equals(Ncol))
    expect_that(varnames(my.mcmc), is_identical_to(nms))
    rm(my.mcmc)
})

test_that("Burn-in is non-numeric:",{

    cat("\nBurn-in is non-numeric: ")
    .NewNames <-  c("K", "r", "q", "MSP")
    #answers:
    nms <-  c("K", "r", "q", "MSP")
    Nrow2 <- 20000
     
    mcmc.file <- paste(HomeDir, '/wnames/mcmc.csv', sep="")
    expect_that(my.mcmc   <- read.mcmc(mcmc.file, header=FALSE, burnin="NonNumeric",
                           delim=",",  names = .NewNames), gives_warning())
    expect_that(my.mcmc, is_a("mcmc"))
    expect_that(dim(my.mcmc)[1], equals(Nrow2))
    expect_that(dim(my.mcmc)[2], equals(Ncol))
    expect_that(varnames(my.mcmc), is_identical_to(nms))
    rm(my.mcmc)
})



test_that("Non-numeric Input Error: ",{

    cat("\nNon-numeric Input Error: ")
    mcmc.file <- paste(HomeDir, '/wheader/NonNumeric.csv', sep="")
    expect_that(my.mcmc   <- read.mcmc(mcmc.file),
                throws_error())    
})



