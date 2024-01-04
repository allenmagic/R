############################################################################################
## Project: Produce the expert fee page
## File Name: get expert fee from our product database
## Create Date: 2023-08-28
## Author: Zheng Youxin
## Platform: RStudio
## EMail: zhengyouxin@cpe-fund.com
###########################################################################################

## Loading the shiny package
library('shiny')


## Create the UI page
ui <- page_sidebar(
  theme = bs_theme(bootswatch = "minty"),
  sidebar = sidebar(checkboxGroupInput(
    "expert","专家供应商",
    choices = unique(df_expert_fee_detail$专家供应商),
    selected = unique(df_expert_fee_detail$专家供应商)
  )),
  
  mainPanel(dataTableOutput('table_expert_fee'))
)


## Defin server logic
server <- function(input, output) {
  subsetted <- reactive({
    req(input$expert)
    df |> filter(df_expert_fee_detail %in% )
    })
  output$table_expert_fee <- renderDataTable(data<-df_expert_fee_detail)
}


## Run the application
shinyApp(ui = ui, server = server)