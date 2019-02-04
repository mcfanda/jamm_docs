wd<-getwd()
td<-"/home/marcello/Skinner/Forge/jamovi/jamm/"
setwd(td)
mversion<-"1.0.1"
a<-system(paste0(" git log ",mversion," --pretty=format:'%cd %s' --date=short"),intern = T)
coms<-a[1:grep("new commitment schema",a,fixed=T)][-1]
