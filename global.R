library(shiny)
library(tidyverse)
library(ggplot2)
library(shinydashboard)

nfts <- read_csv(file = 'nfts.csv') 
packages <- read_csv(file = "packages.csv")


wechselkurs <- nfts %>% head(1) %>% mutate(wechselkurs = Price_in_dollar / Price_ETH) %>% pull(wechselkurs)
durchschnittspreis <- mean(nfts$Price_in_dollar, na.rm = TRUE)

