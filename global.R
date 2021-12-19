library(shiny)
library(tidyverse)
library(ggplot2)
library(shinydashboard)

nfts <- read_csv(file = 'nfts.csv')
packages <- read_csv(file = "packages.csv")

