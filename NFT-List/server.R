# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    packages_reac <- reactive({
        packages %>% 
            filter(collection == input$collection)
    })
    
    output$info_floorprice <- renderInfoBox({
        data <- packages_reac()
        infoBox(
            "floor_price",
            paste0("Der Floor price in ETH ist ", data$floor_price), 
            icon = icon("list"),
            color = "purple",
            fill = TRUE
        )
    })
    
    output$info_volume_traded <- renderInfoBox({
        data <- packages_reac()
        infoBox(
            "volume traded",
            paste0("Das getradete Volumen ist ", data$volume_traded), 
            icon = icon("list"),
            color = "green",
            fill = TRUE
        )
    })
    
    output$info_owners <- renderInfoBox({
        data <- packages_reac()
        infoBox(
            "owners",
            paste0("Die Anzahl der Owner ist ", data$owners), 
            icon = icon("list"),
            color = "blue",
            fill = TRUE
        )
    })
    
    
    output$info_items <- renderInfoBox({
        data <- packages_reac()
        infoBox(
            "items",
            paste0("Die Anzahl der Items ist ", data$items), 
            icon = icon("list"),
            color = "orange",
            fill = TRUE
        )
    })

})
