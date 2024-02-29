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

  # create dynamic menus
  # output$XvarMenu<-renderUI(selectizeInput("InputXvar","Select X variable",unique(RV$selected.dataset$Column)))
  # # lapply(c(ggCoreAes,ggOtherAes),function (xx) {sprintf("input$%s_menu<-selectizeInput('%s_var', 'Select %s variable', unique(RV$selected.dataset$Column)", xx,xx,xx)}) %>% unlist %>% cat(sep="\n")
  # # output$AESMenus<-renderUI(lapply(c(ggCoreAes,ggOtherAes),
  #                                  function (xx) {
  #                                    selectizeInput(AesIDs, AesLabels,
  #                                    c("NULL",unique(RV$selected.dataset$Column)))
  #                                    }))

  output$x_menu<-renderUI(selectizeInput('x_var', 'Select x variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$xmax_menu<-renderUI(selectizeInput('xmax_var', 'Select xmax variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$xmin_menu<-renderUI(selectizeInput('xmin_var', 'Select xmin variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$y_menu<-renderUI(selectizeInput('y_var', 'Select y variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$ymax_menu<-renderUI(selectizeInput('ymax_var', 'Select ymax variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$ymin_menu<-renderUI(selectizeInput('ymin_var', 'Select ymin variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$angle_menu<-renderUI(selectizeInput('angle_var', 'Select angle variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$intercept_menu<-renderUI(selectizeInput('intercept_var', 'Select intercept variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$label_menu<-renderUI(selectizeInput('label_var', 'Select label variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$lower_menu<-renderUI(selectizeInput('lower_var', 'Select lower variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$middle_menu<-renderUI(selectizeInput('middle_var', 'Select middle variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$radius_menu<-renderUI(selectizeInput('radius_var', 'Select radius variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$slope_menu<-renderUI(selectizeInput('slope_var', 'Select slope variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$upper_menu<-renderUI(selectizeInput('upper_var', 'Select upper variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$xend_menu<-renderUI(selectizeInput('xend_var', 'Select xend variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$xintercept_menu<-renderUI(selectizeInput('xintercept_var', 'Select xintercept variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$xlower_menu<-renderUI(selectizeInput('xlower_var', 'Select xlower variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$xmiddle_menu<-renderUI(selectizeInput('xmiddle_var', 'Select xmiddle variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$xupper_menu<-renderUI(selectizeInput('xupper_var', 'Select xupper variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$yend_menu<-renderUI(selectizeInput('yend_var', 'Select yend variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$yintercept_menu<-renderUI(selectizeInput('yintercept_var', 'Select yintercept variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$colour_menu<-renderUI(selectizeInput('colour_var', 'Select colour variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$fill_menu<-renderUI(selectizeInput('fill_var', 'Select fill variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$linetype_menu<-renderUI(selectizeInput('linetype_var', 'Select linetype variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$linewidth_menu<-renderUI(selectizeInput('linewidth_var', 'Select linewidth variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$shape_menu<-renderUI(selectizeInput('shape_var', 'Select shape variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$size_menu<-renderUI(selectizeInput('size_var', 'Select size variable', c('NULL',unique(RV$selected.dataset$Column))))
  output$alpha_menu<-renderUI(selectizeInput('alpha_var', 'Select alpha variable', c('NULL',unique(RV$selected.dataset$Column))))
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
