library(tidyverse)
library(rvest)

nft_page <- read_html("https://opensea.io/collection/degenerate-regenerate")

number_of_items <- nft_page %>% html_elements(".gjwKJf") %>% html_text()

 K_in_number <- function(number) {
  if(grepl("K$", number)) {
    number <- gsub("K$", "00", number) %>% gsub("\\.", "", .) 
  }
  return(as.numeric(number))
}

prices <- nft_page %>% html_elements(".AssetCardFooter--price-amout") %>% html_text()
number_of_items

header <- tibble(
  items = K_in_number(number_of_items[1]),
  owners = K_in_number(number_of_items[2]),
  floor_price = number_of_items[3],
  volume_traded = number_of_items[4]
)
