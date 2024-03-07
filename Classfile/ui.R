# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# https://shiny.posit.co/

library(shiny)

fluidPage(
  tags$head(tags$link(rel="stylesheet",type="text/css",href="dashboard.css")),

# script, stylesheet are the most common rels

  titlePanel("MetaData Plot"),


  sidebarLayout(
    sidebarPanel(
      selectizeInput("InputDataset","Select Dataset",unique(MetaData$label)),
      selectizeInput("Layers","Select a layer (a ggplot geom function)",names(AESsummary),selected="geom_point",multiple=TRUE),
      uiOutput('y_menu'),
      uiOutput('x_menu'),
      uiOutput('xmax_menu'),
      uiOutput('xmin_menu'),
      uiOutput('ymax_menu'),
      uiOutput('ymin_menu'),
      uiOutput('label_menu'),
      uiOutput('xend_menu'),
      uiOutput('yend_menu'),
      uiOutput('angle_menu'),
      uiOutput('intercept_menu'),
      uiOutput('lower_menu'),
      uiOutput('middle_menu'),
      uiOutput('radius_menu'),
      uiOutput('slope_menu'),
      uiOutput('upper_menu'),
      uiOutput('xintercept_menu'),
      uiOutput('xlower_menu'),
      uiOutput('xmiddle_menu'),
      uiOutput('xupper_menu'),
      uiOutput('yintercept_menu'),
      uiOutput('shape_menu'),
      uiOutput('size_menu'),
      uiOutput('colour_menu'),
      uiOutput('linetype_menu'),
      uiOutput('linewidth_menu'),
      uiOutput('fill_menu'),
      uiOutput('alpha_menu'),
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
