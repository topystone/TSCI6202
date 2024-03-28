# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# https://shiny.posit.co/

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)


fluidPage(
  tags$head(tags$link(rel="stylesheet",type="text/css",href="dashboard.css")),

# script, stylesheet are the most common rels

useShinydashboard(), useShinyjs(),

  titlePanel("MetaData Plot"),


sidebarLayout(
  sidebarPanel(
    selectizeInput("InputDataset","Select Dataset",unique(MetaData$label),selected="diamonds,ggplot2,[53940,10]"),
    selectizeInput("Layers","Select a layer (a ggplot geom function)",names(AESsummary),selected="geom_point",multiple=TRUE),
    selectizeInput("y_var","Select y variable",c()),
    box(title='additional y variables',width=NULL,collapsible=T,collapsed=T,
        lapply(ggYAes,function (ii) {
          selectizeInput(paste0(ii,"_var"),paste0("Select ",ii," variable"),c())
        })
    ),
    selectizeInput("x_var","Select x variable",c()),
    box(title='additional x variables',width=NULL,collapsible=T,collapsed=T,
        lapply(ggXAes,function (ii) {
          selectizeInput(paste0(ii,"_var"),paste0("Select ",ii," variable"),c())
        })
    ),
    lapply(ggOtherAes,function (ii) {
      selectizeInput(paste0(ii,"_var"),paste0("Select ",ii," variable"),c())
    }),
    box(title='uncommon variables',width=NULL,collapsible=T,collapsed=T,
        lapply(ggUncommonAes,function (ii) {
          selectizeInput(paste0(ii,"_var"),paste0("Select ",ii," variable"),c())
        })
    ),
      uiOutput("Facet1varMenu"),
      uiOutput("Facet2varMenu")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      actionButton("Update", "Update"),
      actionButton("debug", "Debug"), # inputId and label are required,
      plotOutput("plotoutput"),
      textOutput("plotcommand")
    )
  )
)
