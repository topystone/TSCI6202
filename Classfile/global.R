library(dplyr)
library(shiny)
library(ggplot2)

Rdatasum <-. %>%
  sapply(function(xx) tryCatch(data.frame(class.type=paste(class(xx), collapse=","),
                                                unique=length(unique(xx))),
                               error=function(e) {}),
                                 simplify=FALSE) %>%
  bind_rows(.id="Column")

Rdata<-data(package = .packages(all.available = TRUE))$results %>%
  as.data.frame() %>%
  mutate (Item= gsub(" .*","",Item),code=paste0(Package,"::",Item))

parseEval<-. %>% parse(text=.) %>% try(eval(.))
# "try" will return "Error", will keep on running the codes

Rdatainfo<- Rdata$code [1:200]%>% sapply(parseEval,simplify=FALSE) %>% lapply(Rdatasum)

xx<- Rdata [1:30,]


MetaData<-mapply(function(CurrentItem,CurrentPackage){
  CurrentEnvir<-new.env()
  data(list=CurrentItem,package=CurrentPackage, envir=CurrentEnvir)
  currentdf<-try(as.data.frame(CurrentEnvir [[CurrentItem]]))
  if(is(currentdf,"try-error")) return()
  out<-Rdatasum(currentdf) %>%
    mutate(item=CurrentItem,package=CurrentPackage,rows=nrow(currentdf))
  if(nrow(out)>0) out
  },
  Rdata$Item,Rdata$Package, SIMPLIFY = F) %>% bind_rows() %>%
  group_by(item,package) %>%
  mutate(label=sprintf("%s,%s,[%d,%d],",item,package,rows,n()))# %d: integer

selectizeInput("InputDataset","Select Dataset",unique(MetaData$label))




