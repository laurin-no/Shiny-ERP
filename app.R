library(shiny)
library(shinydashboard)
library(ggplot2)
library(RSQLite)
library(shinyjs)
library(xts)
library(dygraphs)
library(V8)


ui <- dashboardPage(
  dashboardHeader(title = "Shiny-ERP for Slottie AG", titleWidth = 350),
  dashboardSidebar(
    width = 350,
    
    #good icons: balance-scale, line-chart, calendar, code-branch, sitemap
    #https://fontawesome.com/icons?d=gallery
    
    sidebarMenu(
      menuItem("Home", tabName = "tab_home", icon = icon("home")),
      # Operations
      menuItem(
        "Operations",
        tabName = "tab_operations",
        icon = icon("industry"),
        menuItem(
          "Procurement",
          tabName = 'tab_procurement',
          icon = icon('shopping-basket')
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
      # Data Warehouse
      menuItem(
        "Data warehouse",
        tabName = "tab_datawarehouse",
        icon = icon("database"),
        menuSubItem(
          'Table Explorer (SQLITE)',
          tabName = 'tab_tableexplorer',
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
    tabItem(
      tabName = "tab_home",
      
      # Boxes need to be put in a row (or column)
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
      ),
      
      fluidRow(box(plotOutput("plot1", height = 250)),
               box(
                 title = "Controls",
                 sliderInput("slider", "Number of observations:", 1, 100, 50)
               ))
    )
  ))
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)