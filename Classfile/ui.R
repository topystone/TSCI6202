#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("MetaData Plot"),


    sidebarLayout(
        sidebarPanel(
          selectizeInput("InputDataset","Select Dataset",unique(MetaData$label)),
          uiOutput("XvarMenu"),
          uiOutput("YvarMenu"),
          uiOutput("ColorvarMenu"),
          uiOutput("SizevarMenu"),
          uiOutput("AlphavarMenu"),
          uiOutput("Facet1varMenu"),
          uiOutput("Facet2varMenu"),
          actionButton("Update", "Update"),
          actionButton("debug", "Debug"), # inputId and label are required
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plotoutput"),
            textOutput("plotcommand")
        )
    )
)
