library(kinship2)
library(dplyr)
library(randomNames)
library(plotrix)

ecomaps<-mutate(sample.ped,
       varx=sample(0:1,n(),rep=TRUE),
       age=sample(0:99,n(),rep=TRUE),
       name=randomNames(n(),which.names = "first",gender=sex-1,
                        sample.with.replacement = FALSE) %>% paste0(.,"\n",age),
       fathername=sapply(father,function(xx) {coalesce(name[match(xx,id)],"0")}),
       mothername=sapply(mother,function(xx) {coalesce(name[match(xx,id)],"0")}),
       overplotcir=sample(c(FALSE,TRUE),n(),prob =c(0.9,0.1),rep=TRUE)
       )

ecomaps.ped<-with(ecomaps,pedigree(id=id, dadid=father, momid=mother,sex=sex,
                                   affected=cbind(affected, avail,varx),
                                   famid=ped))

ecomaps.ped$id<-ecomaps$name
ecomaps.plotdata<-plot(ecomaps.ped[2])

with(ecomaps.plotdata,mapply(draw.circle,x[subset(ecomaps,ped==2)$overplotcir],
                                  y[subset(ecomaps,ped==2)$overplotcir]+boxh/2,
                                  MoreArgs=list(lwd=2,border="red",radius = boxh/2)))

# rect, boxh, boxw