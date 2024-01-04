## This is ui.R script for app
library(shiny)
library(shinydashboard)


ui <- dashboardPage(
  ## Use shiny theme

  ## Dashboard header
  dashboardHeader(title = "Investor Portal"),
  
  ## Dashboard sidebar
  dashboardSidebar(
    ## There are some items in sidebar
    sidebarMenu(
      ## Investment Portfolios
      menuItem("Investment Portfolios", tabName = "portfolios"),
      ## Fund Performance
      menuItem("Fund Performance", tabName = "performance")
    )
  ),
  
  ## Dashboard body
  dashboardBody(
    # set the css style for this page
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
    ),
    
    # There are some items in body
    tabItems(
      # first item
      
      tabItem(tabName = "portfolios",
              fluidRow(
                # Create select for this tabitem
                column(width = 4,
                  selectInput("entity","出资人实体",
                              c("Please select an entity",unique(as.character(df_lp_investment_summary$lp_name)))
                              ,width = 360
                ),
                  selectInput("value_date","出资人实体",
                              c("Please select value date",unique(df_lp_investment_summary$value_date))
                              ,width = 360
                ))
                ),
                # Create valueBox for show summary value for LP 
              fluidRow(
                valueBoxOutput("commitmentBox",width = 3),
                valueBox("76%","Progress",width = 3),
                valueBox("14.20 millions","Distribution",width = 3),
                valueBox("17.00 millions","Capital Account Balance",width = 3)
              )),
      # second item
      tabItem(tabName = "performance",
              h2("Fund Performace"))
    )
  ))
