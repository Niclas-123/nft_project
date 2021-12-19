library(shiny)
library(shinydashboard)

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Collections", icon = icon("th"), tabName = "widgets")
         ),
        selectInput(inputId = "collection",
                    label = "choose a NFT package:",
                    choices = unique(packages$collection)
        )
    )

body <-  dashboardBody(
    
    tabItems(
        
        tabItem(tabName = "dashboard",
            infoBox(
                "Wechselkurs",
                paste0("Der Wechselkurs ist ", wechselkurs), 
                icon = icon("list"),
                color = "purple",
                fill = TRUE
            ),
            infoBox(
                "Durchschnittspreis",
                paste0("Der Durchschnittspreis in USD ist ", durchschnittspreis), 
                icon = icon("list"),
                color = "blue",
                fill = TRUE
            ),
        ),
        
        tabItem(tabName = "widgets",
            fluidRow(
                infoBoxOutput("info_floorprice"),
                infoBoxOutput("info_volume_traded")
            ),
            fluidRow(
                infoBoxOutput("info_owners"),
                infoBoxOutput("info_items")
            ),
            fluidRow(
                infoBoxOutput("avg_price"),
                infoBoxOutput("avg_likes")
            ),
            fluidRow(
                tableOutput('table')
            )
        )
    )
)

ui <- dashboardPage(
    dashboardHeader(title = "Ultimate dashboard"),
    dashboardSidebar(sidebar),
    dashboardBody(body)
)