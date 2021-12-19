#load Packages
library(tidyverse)
library(rvest)
library(stringr)
library(RSelenium)


rD <- rsDriver(browser="firefox", port=4541L, verbose=F)
remDr <- rD[["client"]]

links <- c()
old_links <- "platzhalter"


remDr$navigate("https://opensea.io/collection/getijde-by-bart-simons")
i <- 0
while(TRUE){
  remDr$executeScript(paste("scroll(0,",i*5000,");"))
  Sys.sleep(4)
  page_source<-remDr$getPageSource()
  nft_page <- read_html(page_source[[1]])
  new_links <- nft_page %>% html_elements(".ekTmzq.Asset--anchor") %>% html_attr("href")
  print(new_links)
  if(all(new_links == old_links)) {break()}
  links <- c(links, new_links)
  old_links <- new_links
  i <- i +1
}


read_html(page_source[[1]]) %>% html_nodes(".gjwKJf") %>% html_text()

#load Pages
nft_page <- read_html(page_source[[1]])
single_nft_page <- read_html(page_source[[1]])

#load NFT-collection DATA
number_of_items <- nft_page %>% html_elements(".gjwKJf") %>% html_text()

#load NFT-collection-Item DATA
item_name <- nft_page %>% html_elements(".AssetCardFooter--name") %>% html_text()
# collection_view_price <- nft_page %>% html_elements(".Price--amount") %>% html_text() %>% as.numeric
likes <- nft_page %>% html_elements(".kDRydb") %>% html_text()
link <- nft_page %>% html_elements(".ekTmzq.Asset--anchor") %>% html_attr("href")

#load single NFT view DATA
views <- single_nft_page %>% html_elements(".gdHQWX") %>% html_text()
title <- single_nft_page %>% html_elements(".item--title") %>% html_text()
fiat <- single_nft_page %>% html_elements(".Price--fiat-amount-secondary") %>% html_text()
price <- single_nft_page %>% html_elements(".Price--amount") %>% html_text()


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
   extracted_price <- string %>% str_extract("[0-9]+.[0-9]+")
   return(as.numeric(extracted_price))
 }

#Tables
packages <- tibble(
  items = K_in_number(number_of_items[1]),
  owners = K_in_number(number_of_items[2]),
  floor_price = number_of_items[3],
  volume_traded = number_of_items[4]
)


nfts_package <- tibble(
  id = item_name,
  Likes = likes,
  Link = link
) %>% separate(id, c("package", "ID"), sep = " #")


single_nft <- tibble(
  Title = title[1],
  Views = views_extractor(views[1]),
  Favourites = views_extractor(views[2]),
  Price_ETH = price[1],
  Price_in_dollar = price_extractor(fiat[1]),
) %>% separate(Title, c("package", "ID"), sep = " #")
