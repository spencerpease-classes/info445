#######################################
# Clean scraped product data from REI #
#######################################

# Import libraries
library(jsonlite)
library(xml2)
library(tibble)
library(readr)
library(dplyr)


# Read in data
raw_prods <- 
    fromJSON("product_data.json") %>% 
    as_tibble()

# Remove null brands
prods <- raw_prods %>% 
    mutate(brand = ifelse(is.na(brand), "None", brand))

# Write clean data
write_csv(prods, "products_clean.csv")

    
