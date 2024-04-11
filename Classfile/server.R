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

  RV <-reactiveValues()
  observe(RV$selected.dataset<-subset(MetaData,label==input$InputDataset))

  observe({
    req(selected.column<-unique(RV$selected.dataset$Column))
    selected.optional.column<-c("NULL",selected.column)
    selected.discrete.column<-unique(subset(RV$selected.dataset,unique <7)$Column)
    runjs("$('.box.collapsed-box').addClass('custom-toggle-collapse')")
    runjs("$('.custom-toggle-collapse button.btn-box-tool').click()")

    for (ii in ggAllAes) {
      iichoices<- if (!ii %in% ggCoreAes) {selected.optional.column} else {selected.column}
      updateSelectizeInput(inputId=paste0(ii,"_var"),choices = iichoices)
    }

    output$Facet1varMenu<-renderUI(selectizeInput("InputFacet1var","Select Facet1",c("NULL",selected.discrete.column)))
    output$Facet2varMenu<-renderUI(selectizeInput("InputFacet2var","Select Facet2",c("NULL",selected.discrete.column)))

    runjs("
        var checkCustomToggleInterval = setInterval(function(){
          if($('.collapsed-box.custom-toggle-collapse').length == 0){
            clearInterval(checkCustomToggleInterval);
            $('.custom-toggle-collapse button.btn-box-tool').click();
            $('.custom-toggle-collapse').removeClass('custom-toggle-collapse');
          }
        },100);
        ");
  })

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

    # AesArgs<-reactiveValuesToList(input)[AesIDs] %>% unlist()
    # AesArgs<-AesArgs[AesArgs!="NULL"]
    # AesArgs<-paste0(gsub("_var","",names(AesArgs)),"=",AesArgs,collapse=",")

    AesArgs<-isolate(reactiveValuesToList(input)[AesIDs]) %>%
      unlist() %>%
      {.[.!="NULL"]} %>%
      paste0(gsub("_var","",names(.)),"=",.,collapse=",")

    isolate(
      RV$plotcommand <- sprintf('as.data.frame(%s::%s) %%>%% ggplot(aes(%s)) + %s',
                                RV$selected.dataset$package[1],
                                RV$selected.dataset$item[1],AesArgs,paste0(input$Layers,"()",collapse=" + ")) %>%
        paste(Facetcode))
  })

  output$plotoutput<-renderPlot(RV$plotcommand %>% parse(text=.) %>% eval())
  output$plotcommand<-renderText(RV$plotcommand)

  observe(if (input$debug > 0) {browser()} )

}
