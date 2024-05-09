library(ggplot2)
library(rio)
library(dplyr)
library(ggsci)
library(GGally)

inputdata<-"syndata_df.csv"
if (!file.exists(inputdata)){system("R -f datasynthesis.R")}
d0<-import(inputdata)
ggplot(d0,aes(x=factor(bpd_or_death),y=bw))+geom_violin()+geom_boxplot(width = 0.1)
ggplot(d0,aes(x=factor(bpd_or_death),y=bw))+geom_violin()+geom_jitter(width = 0.1)

subset(d0,!is.na(bpd_or_death)) %>%
  ggplot(aes(x=factor(bpd_or_death),y=bw))+geom_violin()+geom_jitter(width = 0.1)

subset(d0,!is.na(bpd_or_death)) %>%
  ggplot(aes(x=factor(bpd_or_death),y=bw))+geom_violin(color=NA,fill="green")+
  geom_boxplot(width = 0.1,color="red",fill="purple",alpha=0.5)

subset(d0,!is.na(bpd_or_death)) %>%
  ggplot(aes(x=factor(bpd_or_death),color=factor(bpd_or_death),y=bw))+geom_violin(fill="green",linewidth=2)+
  geom_boxplot(width = 0.1,color="red",fill="purple",alpha=0.5)+coord_flip()

ggpairs(iris,aes(col=Species))

psych_variables <- attr(psychademic, "psychology")
academic_variables <- attr(psychademic, "academic")

ggduo(psychademic,
  mapping = aes(color = sex),
  academic_variables, psych_variables)

data(psychademic)

independent_variables<-c("ga","bw","gender","average72hr")
dependent_variables<-c("vent_days","bpd_or_death")

mutate(d0,gender=factor(gender),bpd_or_death=ordered(bpd_or_death)) %>%
  ggduo(mapping=aes(color = gender),independent_variables,dependent_variables)
