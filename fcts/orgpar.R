##' Format ADMB parameter estimates for emacs org-mode buffers.
##'
##' Print model summaries that can be pasted into a summary
##' report.  Currently, summaries are only printed in org format.    
##' @title orgpar()
##' @param fit An admb model fit created by read.fit()
##' @param clipboard TRUE/FALSE - if TRUE the results are copied to
##'  clipboard so that they can be pasted directly into an org-mode
##'  buffer.  Otherwise the formated results are simply printed on the screen.
##' @param digits the number of sigfificant digits the results are
##'   reported to
##' @return Nothing is returned to the R interpreter.
##' @seealso \code{\link{orgfit}} \code{\link{read.fit}}
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @export
##' @keywords misc

orgpar <- function(fit, clipboard=TRUE, digits=4)
{
  
  #get the values from the fitted object:
  .nms  <- fit$names
  .est  <- signif(fit$est, digits)
  .std  <- signif(fit$std, digits)
  #these are things we need to create for org format:
  sep <- rep("|",length(.nms))
  cr <- rep("\n",length(.nms))
  header <- ("| Parameter | Estimate | SD |\n")
  #put it all together
  txtbody <- t(cbind(sep, .nms, sep, .est, sep, .std, sep, cr))
  txtbody <- paste(header,paste(txtbody, collapse=""),collapse="")
  #print it out to the console:
  cat(txtbody, file='', sep='', fill=FALSE, labels=NULL,
  append=FALSE)
  #copy it to the clipboard
  if(clipboard==TRUE){
    writeClipboard(txtbody, format=1)
    cat("\nParameter estimates copied to clipboard.\n")                   
  }                    
}


##' Format ADMB output for emacs org-mode buffers..
##'
##'  Print model summaries to R console in Org-mode format
##'  orgfit() produces a summary of paramater count, objective funtion
##'  value, AIC and gradient.  The results can be copied directly to the
##'  clipboard for copying to other summary/reporting files
##' @title orgfit()
##' @param fit An admb model fit created by read.fit()
##' @param clipboard TRUE/FALSE - if TRUE the results are copied to
##'  clipboard so that they can be pasted directly into an org-mode
##'  buffer.  Otherwise the formated results are simply printed on the screen.
##' @return Nothing is returned to the R interpreter.
##' @seealso \code{\link{orgpar}} \code{\link{read.fit}}
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @export
##' @keywords misc
orgfit <- function(fit, clipboard=TRUE)
{
  ## Purpose: print model summaries to R console in Org-mode format
  ## org.fit produces a summary of paramater count, objective funtion
  ## value, AIC and gradient.  The results can be copied directly to the
  ## clipboard for copying to other summary/reporting files
  ## ----------------------------------------------------------------------
  ## Arguments: 
  ##     fit    <- An admb model fit created by read.fit()    
  ## ----------------------------------------------------------------------
  ## Author: Adam Cottrill, Date: 11 May 2011, 13:03

   .parCnt <- fit$nopar
   .NLL    <- fit$nlogl
   .AIC    <- 2 * .parCnt + 2 * .NLL
   .grad <- fit$maxgrad
   txt <- paste("|Model",.parCnt,.NLL,.AIC,.grad,"\n", sep="|")
   cat(txt)
  if(clipboard==TRUE){
    writeClipboard(txt, format=1)
    cat("\nModel summary copied to clipboard.\n")                   
  }                    
}
