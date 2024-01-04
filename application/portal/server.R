# Load the ggplot2 package which provides
# the 'mpg' dataset.
library(ggplot2)

function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- df_lp_fund_info
    if (input$entity != "Please select an entity") {
      data <- data[data$lp_name == input$entity,]
    }
    data
  }))
  
  # Set value box for dashboard
  # valueBox 1 - commitmentBox for show lp commitment total value
  output$commitmentBox <- renderValueBox({
    if (input$entity != "Please select an entity" && input$value_date != "Please select value date") {
    df_lp_investment_summary %>% filter(value_date == input$value_date & lp_name == input$entity) -> commitement
      commit_value <- paste0(as.numeric(commitement[,c("total_paid_amount")])/100000000, "亿元")
    } else
    {commit_value <- c("NA")}
      valueBox(
        commit_value,"总实缴",icon = icon("fingerprint")
      )
    })
}