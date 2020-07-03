library(spatstat)
library(doParallel) 
calcEnv <- function(A,fname){
  
  boxr    <- box3(xrange = c(1,2484),yrange = c(1,2484),zrange = c(1,900),unitname = "microns") #1,max(A[,3])
  coorA   <- pp3(A$V1,A$V2,A$V3,boxr,marks = NULL)
  #K       <- K3est(coorA,correction = "translation")
  calcEnv <- envelope.pp3(coorA, K3est, correction = "translation", nsim=99, nrank=1)#, transform = expression(. -4*pi*r^3/3))
  write.csv(calcEnv,paste("resEnv_K_original/Kenv",fname,"csv",sep = "."),row.names = FALSE)
  return(fname)
}

dat.files     <- list.files(path="res_coord_scaled",recursive=T,pattern="*.txt",full.names=T) # Must be scaled coordinates!!!
coord         <- lapply(dat.files, read.delim, sep=",", header=FALSE)
names(coord)  <- dat.files

# Use the environment variable SLURM_CPUS_PER_TASK to set the number of cores.
# This is for SLURM. Replace SLURM_CPUS_PER_TASK by the proper variable for your system.
# Avoid manually setting a number of cores.
ncores = Sys.getenv("SLURM_CPUS_PER_TASK") 
registerDoParallel(cores=ncores) # Shows the number of Parallel Workers to be used
print(ncores)                    # this how many cores are available, and how many you have requested.
getDoParWorkers()                # you can compare with the number of actual workers

# be careful! foreach() and %dopar% must be on the same line!
foreach(i=1:42) %dopar% {
  A<-dat.files[i]
  fname<-basename(A)
  dat<-coord[[A]]
  calcEnv(dat,fname)
}
#################### END #################################################
##########################################################################

