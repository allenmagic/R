#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(dplyr)
library(DT)

# Define server logic that uses DT::renderDataTable for fixed header, vertical scrolling, and number formatting
shinyServer(function(input, output, session) {
  
  # Assuming 'lp_fund_info_table' dataset is loaded or created here
  # lp_fund_info_table <- ...
  
  # Initialize fund_name and value_date choices with an empty selection
  observe({
    updateSelectInput(session, "fund_input",
                      choices = c("", unique(lp_fund_info_table$fund_name)))
    updateSelectInput(session, "date_input",
                      choices = c("", unique(as.character(lp_fund_info_table$value_date))))
  })
  
  # Reactive expression to return filtered data based on selected fund_name and value_date
  filteredData <- reactive({
    req(lp_fund_info_table)  # Ensure 'lp_fund_info_table' is available
    
    # Start with the full dataset
    data_to_show <- lp_fund_info_table
    
    # If a fund_name is selected, filter by that fund_name
    if (input$fund_input != "") {
      data_to_show <- data_to_show %>% 
        filter(fund_name == input$fund_input)
    }
    
    # If a value_date is selected, filter by that value_date
    if (input$date_input != "") {
      data_to_show <- data_to_show %>% 
        filter(value_date == input$date_input)
    }
    
    data_to_show # Return the filtered or unfiltered dataset
  })
  
  # Output the table with numeric columns formatted with thousand separators and fixed headers
  output$table <- renderDT({
    # Store the filtered data in a variable
    data <- filteredData()
    # Create the datatable
    datatable(data, options = list(
      scrollX = TRUE,
      scrollY = "800px",
      autoWidth = TRUE,
      scrollCollapse = TRUE,
      pageLength = 50  # Set the number of rows per page
    ), rownames = FALSE) %>%
      # Apply thousand separator formatting to all numeric columns except specified ones
      { dt <- .
      numeric_cols <- sapply(dt$x$data, is.numeric)
      cols_to_format <- setdiff(names(which(numeric_cols)), c('lp_name', 'fund_name', 'value_date'))
      for(col in cols_to_format) {
        dt <- formatNumber(dt, columns = col, decimal.mark = '.', big.mark = ',', thousands = TRUE, na = '')
      }
      dt
      }
  }, server = FALSE)  # server=FALSE for client-side processing (can be set to TRUE for server-side processing)
})
