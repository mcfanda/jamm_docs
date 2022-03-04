library(rmarkdown)
library(Rsearchable)
HERE<-getwd()
msg<-"updates"
render_site("docssource/")
system("git add .")
system(paste('git commit -m "',msg,'"'))
system("git push origin master")

  ### the following is needed for organization pages
source("R/constants.R")
cmd<-paste("cp -R ",paste0(SOURCE_FOLDER,"/*"),paste0(TARGET_FOLDER,"/"))
system(cmd)
setwd(TARGET_FOLDER)
system("git add .")
system(paste('git commit -m "',msg,'"'))
system("git push origin master")
setwd(HERE)


