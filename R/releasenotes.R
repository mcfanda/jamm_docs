source("R/constants.R")
wd<-getwd()
setwd(TARGETD)
a<-system("git log --pretty=format:'%cd %s' --date=short",intern = T)
a
coms<-a[1:grep("new commitment schema",a,fixed=T)][-1]
setwd(wd)
coms

