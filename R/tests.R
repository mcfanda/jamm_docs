### mixed 1 ###
dat<-read.csv2("data/beers_bars.csv")
dat$smile<-as.numeric(as.character(dat$smile))
dat$beer<-as.numeric(as.character(dat$beer))
dat$beer<-as.numeric(scale(dat$beer,scale = F))
library(lmerTest)
model<-lmer(smile~beer+(1|bar),data=dat,REML = F)
summary(model)
model<-lmer(smile~beer+(1+beer|bar),data=dat)
summary(model)

anova(model, type=2, ddf="Kenward-Roger")

ranova(model)
