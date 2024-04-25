library(ggplot2)
library(rio)
library(dplyr)
library(ggsci)

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

