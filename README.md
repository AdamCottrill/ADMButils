Utilities to read and write files associated with AD Model Builder.

ADMButils contains a number of functions that read and write *.std, *.par,
*.pin and *.dat files associated with AD Model Builder.

The functions provided in ADMButils fall into two categories -
those that write files and those that read ADMB output and return
R-objects.  The functions write_dat and write_pin are used to produce dat
and pin files respectively.  The functions write_dat and write_pin are
modified from the glmmADMB package (available from \url{
http://otter-rsch.com }).

The functions read.std, read.par, and admb.obj all return R-objects
contained in the std and par files produced by ADMB. adbm.obj is simply a
wrapper function that first calls read.par and then calls read.std.
