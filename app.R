library(shiny)
library(shinydashboard)
library(ggplot2)
library(RSQLite)
library(shinyjs)
library(xts)
library(dygraphs)
library(V8)
library(diagram)
library(DiagrammeR)
library(DT)



database <- "db.sqlite"


ui <- dashboardPage(
  dashboardHeader(title = "Shiny-ERP for Slottie AG", titleWidth = 350),
  dashboardSidebar(
    width = 350,
    
    #good icons: balance-scale, line-chart, calendar, code-branch, sitemap
    #https://fontawesome.com/icons?d=gallery
    
    sidebarMenu(
      menuItem("Home", tabName = "tab_home", icon = icon("home")),
      
      # Finance
      menuItem(
        "Finance",
        tabName = "tab_finane",
        icon = icon("line-chart"),
        menuItem(
          "REA Transactions",
          tabName = 'tab_reatransactions',
          icon = icon('exchange')
        ),
        menuItem(
          "ALE Accounting",
          tabName = 'tab_aleacclunting',
          icon = icon('balance-scale')
        )
      ),
      # Operations
      menuItem(
        "Operations",
        tabName = "tab_operations",
        icon = icon("industry"),
        menuItem(
          "Procurement",
          tabName = 'tab_procurement',
          icon = icon('shopping-basket'),
          menuSubItem('Incoming Goods', tabName = 'tab_procurement_incoming_goods'),
          menuSubItem('Receipt Incoming Goods', tabName = 'tab_procurement_receipt_incoming_goods')
        ),
        menuItem(
          "Manufacturing",
          tabName = 'tab_manufacturing',
          icon = icon('wrench')
        ),
        menuItem("Sales",
                 tabName = 'tab_sales',
                 icon = icon('truck'))
      ),
      
      # Data Warehouse
      menuItem(
        "Data warehouse",
        tabName = "tab_datawarehouse",
        icon = icon("database"),
        menuSubItem(
          'Table Browser (SQLITE)',
          tabName = 'tab_tablebrowser',
          icon = icon('table')
        )
      ),
      # Settings
      menuItem(
        "Administration",
        tabName = "tab_administration",
        icon = icon("gears"),
        menuSubItem('Resources',
                    tabName = 'tab_resources',
                    icon = icon("gears")),
        menuSubItem('Agents',
                    tabName = 'tab_agents',
                    icon = icon("users")),
        menuSubItem('Bill of Materials',
                    tabName = 'tab_billofmaterials',
                    icon = icon("sitemap")),
        menuSubItem('Routings',
                    tabName = 'tab_routings',
                    icon = icon("users"))
      )
      
    )
  ),
  
  
  dashboardBody(tabItems(
    #tab_home
    tabItem(
      tabName = "tab_home",
      fluidRow(
        div(img(
          src = 'shiny-erp.png', align = "center", width = "450"
        ), style = "text-align: center;"),
        h3("Shiny-ERP"),
        h3("A REA-compliant ERP-Prototpye for Slottie AG"),
        #h3("Candle Manufacturing Inc. Shiny-ERP"),
        #h3("Decision Support System"),
        p("Technische Universität Wien"),
        p(
          tags$a(href = "https://www.imw.tuwien.ac.at/fc/", "Financial Enterprise Management Group, 2018")
        ),
        p(
          tags$a(href = "mailto:christian.fischer-pauzenberger@tuwien.ac.at", "Christian Fischer-Pauzenberger")
        ),
        p("Walter S.A. Schwaiger")
      )
      
      # fluidRow(box(plotOutput("plot1", height = 250)),
      #          box(
      #            title = "Controls",
      #            sliderInput("slider", "Number of observations:", 1, 100, 50)
      #          ))
    ),
    #tab tab_procurement_incoming_goods
    tabItem(
      tabName = "tab_procurement_incoming_goods",
      box(  title = "Enter incoming goods details", status = "primary", width = 12, solidHeader = TRUE,
            collapsible = TRUE,
              
            selectInput("proc_ig_selectInput_fromAgent", label = "Select Agent (external, supplier)", 
                          choices = NULL, 
                          selected = NULL),
            selectInput("proc_ig_selectInput_material", label = "Select Resource (material)", 
                        choices = NULL, 
                        selected = NULL),
            sliderInput("proc_ig_sliderInput_amount", "Amount in pcs:", 1, 100, 10),
            selectInput("proc_ig_selectInput_toAgent", label = "Select Agent (internal, warehouse)", 
                        choices = NULL, 
                        selected = NULL),
            
            dateInput("proc_ig_selectInput_timestamp", "Date:", value = Sys.Date(), format = "dd-mm-yyyy"),
            actionButton("proc_ig_actionButton_preview", "Preview")
      ),
      box(title = "Preview ", status = "primary", width = 12, solidHeader = TRUE,
          collapsible = TRUE,
          
          verbatimTextOutput("proc_ig_verbatimTextOutput_preview", placeholder = TRUE),
        
          grVizOutput("proc_ig_grVizOutput_graph")
      )
    ),
    
    tabItem(
      tabName = "tab_tablebrowser",
      box(  title = "Table Browser", status = "primary", width = 12, solidHeader = TRUE,
            collapsible = TRUE,
            selectInput("datawarehouse_tb_selectInput_table", label = "Select table of interest", 
                        choices = NULL, 
                        selected = NULL),
            actionButton("datawarehouse_tb_actionButton_go", "Go")
    ),
      box(  title = "Table Browser", status = "primary", width = 12, solidHeader = TRUE,
            collapsible = TRUE,
            dataTableOutput('datawarehouse_tb_dataTable_table')
            
      )
    )
  )))

server <- function(input, output, session) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  
  
  # update proc_ig_selectInput_fromAgent
  con <- dbConnect(RSQLite::SQLite(), database)
  resultset = dbGetQuery(con, "select distinct description from agent where isExternalAgent = 1")
  dbDisconnect(con)
  updateSelectInput(session, "proc_ig_selectInput_fromAgent", choices = resultset$description,
                    selected = NULL)
  
  # update proc_ig_selectInput_material
  con <- dbConnect(RSQLite::SQLite(), database)
  resultset = dbGetQuery(con, "select distinct description from material")
  dbDisconnect(con)
  updateSelectInput(session, "proc_ig_selectInput_material", choices = resultset$description,
                    selected = NULL)
  
  # update proc_ig_selectInput_toAgent
  con <- dbConnect(RSQLite::SQLite(), database)
  resultset = dbGetQuery(con, "select distinct description from agent where isExternalAgent = 0")
  dbDisconnect(con)
  updateSelectInput(session, "proc_ig_selectInput_toAgent", choices = resultset$description,
                    selected = NULL)
  
  

  # update datawarehouse_tb_selectInput_table
  con <- dbConnect(RSQLite::SQLite(), database)
  resultset <- dbListTables(con)
  dbDisconnect(con)
  updateSelectInput(session, "datawarehouse_tb_selectInput_table", choices = resultset,
                    selected = NULL)
  
  
  # Observe Preview-Button
  observeEvent(input$proc_ig_actionButton_preview, {

    con <- dbConnect(RSQLite::SQLite(), database)
    resultset = dbGetQuery(con, paste0("select distinct pricePerUnit from material where description like '",input$proc_ig_selectInput_material,"'"))
    dbDisconnect(con)
    
    output$proc_ig_verbatimTextOutput_preview <-  renderText(resultset$pricePerUnit[1])

    ###draw REA graph
    output$proc_ig_grVizOutput_graph <- renderGrViz({
      ndf <- create_node_df(n = 2, label = c(input$proc_ig_selectInput_toAgent, input$proc_ig_selectInput_fromAgent),
                            shape = c("circle"))
      # Create an edge data frame (edf)
      edf <- create_edge_df(from = c(1, 2),
                            to = c(2, 1),
                            rel = c("a", "b"),
                            label = c(resultset$pricePerUnit[1], input$proc_ig_selectInput_material))
      # Create a graph with the ndf and edf
      graph <- create_graph(nodes_df = ndf,
                            edges_df = edf,
                            attr_theme = NULL)
      render_graph(graph)
    })
  })
  
  #observe button datawarehouse_tb_actionButton_go
  observeEvent(input$datawarehouse_tb_actionButton_go, {
    
    con <- dbConnect(RSQLite::SQLite(), database)
    resultset = dbGetQuery(con, paste0("select * from ",input$datawarehouse_tb_selectInput_table))
    dbDisconnect(con)
    #write to datatable
  
    output$datawarehouse_tb_dataTable_table <- renderDataTable({
      resultset
    })
    
    #output$proc_ig_verbatimTextOutput_preview <-  renderText(resultset$pricePerUnit[1])
  
    })
}

shinyApp(ui, server)