library(rmarkdown)
msg<-"main docs"

render_site("docssource/")
system("git add .")
system(paste('git commit -m "',msg,'"'))
system("git push origin master")
