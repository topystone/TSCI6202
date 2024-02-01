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

    output$XvarMenu<-renderUI(selectizeInput("InputXvar","Select X variable",unique(RV$selected.dataset$Column)))
    output$YvarMenu<-renderUI(selectizeInput("InputYvar","Select Y variable",unique(RV$selected.dataset$Column)))

    observe(RV$plotcommand<-sprintf('as.data.frame(%s::%s) %%>%%
                                     ggplot(aes(x=%s,y=%s))+geom_point()',
                                     RV$selected.dataset$package[1],
                                     RV$selected.dataset$item[1],
                                     input$InputXvar,input$InputYvar))
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