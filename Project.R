library(tidyverse)
install.packages("rvest")
library(rvest)

nft_page <- read_html("https://opensea.io/collection/degenerate-regenerate")

number_of_items <- nft_page %>% html_element(".gjwKJf") %>% html_text()

 K_in_number <- function(number) {
  if(grepl("K$", number)) {
    number <- gsub("K$", "00", number) %>% gsub("\\.", "", .) 
  }
  return(as.numeric(number))
}

K_in_number("5.8K")

prices <- nft_page %>% 
  html_elements(".AssetCardFooter--price-amout") %>%
  html_text()