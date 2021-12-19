library(shiny)
library(shinydashboard)

sidebar <- dashboardSidebar(
    selectInput(inputId = "collection",
                label = "choose a NFT package:",
                choices = unique(packages$collection)
                )
)

body <-  dashboardBody(
    # infoBoxes with fill=FALSE
    fluidRow(
        infoBoxOutput("info_floorprice"),
        infoBoxOutput("info_volume_traded")
    ),
    fluidRow(
        infoBoxOutput("info_owners"),
        infoBoxOutput("info_items")
    )
)

ui <- dashboardPage(
    dashboardHeader(title = "Ultimate dashboard"),
    dashboardSidebar(sidebar),
    dashboardBody(body)
)