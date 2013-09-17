# this file contains a number of tests that should be true for an mcmc
# object created by read.mcmc
# Nrow, Ncol and nms are defined in the calling script.

test_that("read.mcmc tests",{
   expect_that(my.mcmc, is_a("mcmc"))
   expect_that(dim(my.mcmc)[1], equals(Nrow))
   expect_that(dim(my.mcmc)[2], equals(Ncol))
   expect_that(varnames(my.mcmc), is_identical_to(nms))
})
