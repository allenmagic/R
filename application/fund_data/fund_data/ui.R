#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(DT)

# Define UI for application with fixed header using DT::dataTableOutput
shinyUI(fluidPage(
  
  # Application title
  titlePanel("LP Fund Information"),
  
  tags$head(
    tags$style(HTML("
      /* Fixed position of filters row */
      #controls {
        position: sticky;
        top: 0;
        background-color: white;
        padding: 10px;
        z-index: 100;
      }
    "))
  ),
  
  # Filters row with selection boxes
  fluidRow(id = "controls",
           column(4,
                  selectInput("fund_input", "Select Fund:",
                              choices = c("", "All Funds")) # include an empty selection for "All"
           ),
           column(4,
                  selectInput("date_input", "Select Date:",
                              choices = c("", "All Dates")) # include an empty selection for "All"
           )
  ),
  
  # Div for a responsive table with scrolling and fixed headers using DT package
  DTOutput("table")
))
