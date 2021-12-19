#load Packages
library(tidyverse)
library(rvest)
library(stringr)
library(RSelenium)

#open Selenium Browser
rD <- rsDriver(browser="firefox", port=4548L, verbose=F)
remDr <- rD[["client"]]

#rD[["server"]]$stop()

list_of_collections <- c(
  "deafbeef",
  "rekt-news-hacks-hopium",
  "illuvium",
  "pop-wonder-world"
)


#Functions
K_in_number <- function(number) {
  if(grepl("K$", number)) {
    number <- gsub("K$", "00", number) %>% gsub("\\.", "", .) 
  }
  return(as.numeric(number))
}

views_extractor <- function(string) {
  extracted_view <- string %>% str_extract("[0-9]+")
  return(as.numeric(extracted_view))
}

price_extractor <- function(string) {
  extracted_price <- string %>% str_extract("[0-9,.]+") %>% gsub(",", "", .) %>% as.numeric()
  return(as.numeric(extracted_price))
}

#Funktion um einzelne NFT Seite zu scannen

get_single_nft <- function(link){
  single_nft_page <- read_html(paste0("https://opensea.io", link))
  
  views <- single_nft_page %>% html_elements(".gdHQWX") %>% html_text()
  title <- single_nft_page %>% html_elements(".item--title") %>% html_text()
  fiat <- single_nft_page %>% html_elements(".Price--fiat-amount-secondary") %>% html_text()
  price <- single_nft_page %>% html_elements(".Price--amount") %>% html_text()
  
  single_nft <- tibble(
    Title = title[1],
    Views = views_extractor(views[1]),
    Favourites = views_extractor(views[2]),
    Price_ETH = price[1],
    Price_in_dollar = price_extractor(fiat[1]),
    Link = link
  )
  
  return(single_nft)
}

get_list_of_nfts <- function(collection, remDr) {
  cat("initialisiere Server\n")
  collection_link <- paste0("https://opensea.io/collection/", collection)
  remDr$navigate(collection_link)
  page_source <- remDr$getPageSource()    
  nft_page <- read_html(page_source[[1]])
  
    #load NFT-collection DATA
    number_of_items <- nft_page %>% html_nodes(".gjwKJf") %>% html_text()
    
    cat("Komprimiere Package Information\n")
    packages <- tibble(
      items = K_in_number(number_of_items[1]),
      owners = K_in_number(number_of_items[2]),
      floor_price = number_of_items[3],
      volume_traded = number_of_items[4],
      collection = collection
    )
  
    #click button for small NFT view
    cat("Clicke Button für kleine Ansicht\n")
    small_view <- remDr$findElement(using = 'css selector', '.bnWGYU')
    small_view$clickElement()
    
    i <- 0
    links <- c()
    item_names <- c()
    likes <- c()
    
    old_links <- "platzhalter"
    old_item_names <- "platzhalter"
    old_likes <- "platzhalter"
    
    cat("Schrolle durch die NFTs\n")
    
    while(TRUE){
      remDr$executeScript(paste("scroll(0,",i*1500,");"))
      Sys.sleep(4)
      page_source<-remDr$getPageSource()
      nft_page <- read_html(page_source[[1]])
      
      new_links <- nft_page %>% html_elements(".ekTmzq.Asset--anchor") %>% html_attr("href")
      new_item_names <- nft_page %>% html_elements(".AssetCardFooter--name") %>% html_text()
      new_likes <- nft_page %>% html_elements(".kDRydb") %>% html_text()
      
      if(all(new_links == old_links)) {break()}
        links <- c(links, new_links)
        item_names <- c(item_names, new_item_names)
        likes <- c(likes, new_likes)
        
        old_item_names <- new_item_names
        old_likes <- new_likes
        old_links <- new_links
        i <- i +1
    } 
    
  cat("Komprimiere Liste der NFTs aus Collection Ansicht\n")  
  nfts_package <- tibble(
      id = item_names,
      Likes = likes,
      Link = links,
    ) %>% distinct
    
    
  
  cat("Erstelle Liste der NFT's aus single NFT View\n")
  all_nfts <- map_df(links, get_single_nft)
  
  cat("Füge Listen zusammen\n")
  ultimate_nft_list <- full_join(nfts_package, all_nfts, by = "Link") %>% distinct() %>% mutate(collection = collection)
  
  cat("Fertig\n")
  return(list(package = packages, nfts = ultimate_nft_list, a = nfts_package, b = all_nfts))
}

x <- get_list_of_nfts(list_of_collections[2], remDr = remDr)

data <- map(list_of_collections, safely(get_list_of_nfts), remDr = remDr)

dat <- map(data, "result")
nfts <- map_df(dat, "nfts")
packages <- map_df(dat, "package")

write_csv(packages, "packages.csv")
write_csv(nfts, "nfts.csv")
