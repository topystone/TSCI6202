library(dplyr)
library(shiny)
library(ggplot2)
library(rio)

excludeformat<- c("list","haven_labelled","haven_labelled_spss,haven_labelled",
                  "sfc_MULTIPOLYGON,sfc","matrix,array","nativeRaster","wk_wkb,wk_vctr",
                  "wk_wkb,wk_vctr,geovctr")

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

if (!file.exists("Metadata.csv")) {

  MetaData<-mapply(function(CurrentItem,CurrentPackage){
    CurrentEnvir<-new.env()
    data(list=CurrentItem,package=CurrentPackage, envir=CurrentEnvir)
    currentdf<-try(as.data.frame(CurrentEnvir [[CurrentItem]]))
    if(is(currentdf,"try-error")) return()
    out<-Rdatasum(currentdf) %>%
      mutate(item=CurrentItem,package=CurrentPackage,rows=nrow(currentdf))
    if(nrow(out)==0) return()
    out<-subset(out,!class.type %in% excludeformat)
    if(nrow(out)>0) out
    },
    Rdata$Item,Rdata$Package, SIMPLIFY = F) %>% bind_rows() %>%
    group_by(item,package) %>%
    mutate(label=sprintf("%s,%s,[%d,%d]",item,package,rows,n()))# %d: integer

  export(MetaData,"Metadata.csv")
} else {MetaData<-import("Metadata.csv")}

#selectizeInput("InputDataset","Select Dataset",unique(MetaData$label))

# input<-list(InputDatset="starwars,dplyr,[87,11]")
#
#
#
# sprintf('as.data.frame(%s::%s) %%>%% ggplot(aes(x=height,y=birth_year))+geom_point()',selected.dataset$package[1],selected.dataset$item[1]) %>%
#   parse(text = .) %>% eval()






