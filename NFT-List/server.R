# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    packages_reac <- reactive({
        packages %>% 
            filter(collection == input$collection)
    })
    
    nfts_reac <- reactive({
        nfts %>% 
            filter(collection == input$collection) %>% 
            select(-Link, -id, -Favourites)
        
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
    
    output$avg_price <- renderInfoBox({
        data <- nfts_reac()
        infoBox(
            "avg_price",
            paste0("Der durchschnittspreis in USD ist ", mean(data$Price_in_dollar, na.rm = TRUE))
        )
    })
    
    output$avg_likes <- renderInfoBox({
        data <- nfts_reac()
        infoBox(
            "avg_likes",
            paste0("Die durchschnittliche Anzahl an Likes ist ", mean(data$Likes, na.rm = TRUE))
        )
    })
    
    output$like_price_cor <- renderInfoBox({
        data <- nfts_reac()
        infoBox(
            "lp_cor", paste0("Der Korrelationskoeffizient ist ", 
                   cor(data$Likes, data$Price_in_dollar, use="complete.obs")))
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
    
    

    output$table <- renderTable(nfts_reac())
        
})

