#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        # x    <- faithful[, 2]
        # bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white',
        #      xlab = 'Waiting time to next eruption (in mins)',
        #      main = 'Histogram of waiting times')
        ggplot(faithful,aes(x=waiting))+geom_histogram(bins=input$bins)

    })
    RV <-reactiveValues()
    observe(RV$selected.dataset<-subset(MetaData,label==input$InputDataset))

# create dynamic menus
    # output$XvarMenu<-renderUI(selectizeInput("InputXvar","Select X variable",unique(RV$selected.dataset$Column)))
    # output$YvarMenu<-renderUI(selectizeInput("InputYvar","Select Y variable",unique(RV$selected.dataset$Column)))
    # output$ZvarMenu<-renderUI(selectizeInput("InputZvar","Select Z variable",unique(RV$selected.dataset$Column)))
    # output$ColorvarMenu<-renderUI(selectizeInput("InputColorvar","Select color",c("NULL",unique(RV$selected.dataset$Column))))
    # output$SizevarMenu<-renderUI(selectizeInput("InputSizevar","Select size",c("NULL", unique(RV$selected.dataset$Column))))
    # output$AlphavarMenu<-renderUI(selectizeInput("InputAlphavar","Select alpha",c("NULL",unique(RV$selected.dataset$Column))))
    output$AESMenus<-renderUI(lapply(c(ggCoreAes,ggOtherAes),
                                     function (xx) {
                                       selectizeInput(AesIDs, AesLabels,
                                                      c("NULL",unique(RV$selected.dataset$Column)))
                                       }))
    output$Facet1varMenu<-renderUI(selectizeInput("InputFacet1var","Select Facet1",c("NULL",subset(RV$selected.dataset,unique <7)$Column)))
    output$Facet2varMenu<-renderUI(selectizeInput("InputFacet2var","Select Facet2",c("NULL",subset(RV$selected.dataset,unique <7)$Column)))


    # plot command
    observe({
      input$Update;
      Facet1<-isolate(input$InputFacet1var);
      Facet2<-isolate(input$InputFacet2var);
      Facetcode<-case_when(Facet1=="NULL"&Facet2=="NULL"~"",
                Facet1==Facet2~sprintf("+facet_wrap(vars(%s))",Facet1),
                Facet1=="NULL"~sprintf("+facet_grid(rows=NA,cols=vars(%s))",Facet2),
                Facet2=="NULL"~sprintf("+facet_grid(rows=vars(%s),cols=NA)",Facet1),
                Facet1!="NULL"&Facet2!="NULL"~sprintf("+facet_grid(rows=vars(%s),cols=vars(%s))",Facet1,Facet2),
                TRUE~"EXCEPTION"
      );
      isolate(
        RV$plotcommand <- sprintf(
          'as.data.frame(%s::%s) %%>%% ggplot(aes(%s))+%s',
          RV$selected.dataset$package[1],
          RV$selected.dataset$item[1],
          sapply(AesIDs,function(xx) if(input[[xx]]!="NULL") input[[xx]]) %>%
            unlist %>%
            paste0(gsub("_var","",names(.)),"=",.,collapse=","),
          # input$InputXvar,
          # input$InputYvar,
          # input$InputZvar,
          # input$InputColorvar,
          # input$InputSizevar,
          # input$InputAlphavar,
          paste0(input$Layers,"()",collapse=" + ")
          # combining basic plotcommand with "Facetcode" from above
        ) %>% paste(Facetcode)
      )
    })

    output$plotoutput<-renderPlot(RV$plotcommand %>% parse(text=.) %>% eval())
    output$plotcommand<-renderText(RV$plotcommand)

        observe(if (input$debug > 0) {browser()} )

}



# testdata<-subset(MetaData,label==input$InputDataset)
# foo<-new.env()
# PackageVariable<-unique(testdata$package)
# ItemVariable<-unique(testdata$item)
# data(list=ItemVariable,package=PackageVariable, envir=foo)
# attach(foo)
# ggplot(data=cancer, aes(x=age, y=meal.cal)) + geom_point()