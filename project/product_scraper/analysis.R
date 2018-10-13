
# Import Libraries
library(stringi)
library(dplyr)
library(tidyr)

char_lengths <- prods %>% 
    gather() %>% 
    mutate(char_length = stri_length(value)) %>% 
    group_by(key) %>% 
    summarise(length = max(char_length))

double_products <- prods %>%
    group_by(product_name, brand) %>% 
    summarise(count = n()) %>% 
    filter(count > 1)

category_groups <- prods %>% 
    select(category, sub_category) %>% 
    group_by(category) %>% 
    summarise(num_subcategories = length(unique(sub_category)))
