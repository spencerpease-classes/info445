# -*- coding: utf-8 -*-
import scrapy
import json


class ReiProductsSpider(scrapy.Spider):
    
    name = 'rei_products'
    
    def __init__(self, *args, **kwargs):
        
        super(ReiProductsSpider, self).__init__(*args, **kwargs)
        
        self.allowed_domains = ['rei.com']
        
        base_url = 'https://www.rei.com'
        self.start_urls = [base_url + '/categories']
        self.api_url = base_url + '/rest/search/results?r=category%3A{}&pagesize=90&page={}'   


    def parse(self, response):
        
        superCats = response.css('li.box')
        
        for superCat in superCats:
            
            subCats = superCat.css('div > ul.itemList > li > a::attr(href)')[:-1]
            
            for subCat in subCats:
            
                self.cat = subCat.extract()[3:]
                self.page = 1
                nextURL = self.api_url.format(self.cat, self.page) 
                
                yield scrapy.Request(
                        url = nextURL, 
                        callback = self.parse_product_page
                        )
    
    def parse_product_page(self, response):
        
        data = json.loads(response.text)
        
        category = data["categoryPath"][0]["value"]
        subCategory = data["supplementalAnalyticsData"]["latestCategorySelection"]
        
        for product in data["results"]:
            
            productName = product["cleanTitle"]
            brand = product["brand"]
            price = product["displayPrice"]["max"]
            description = product["description"].encode("utf-8")
            
            item = {
                    "product_name": productName,
                    "category": category,
                    "sub_category": subCategory,
                    "brand": brand,
                    "price": price,
                    "description": description
                        }
            
            yield item
        
        if self.page < data["pagination"]["totalPages"]:
            
            self.page += 1
            nextURL = self.api_url.format(self.cat, self.page)
            
            yield scrapy.Request(
                        url = nextURL, 
                        callback = self.parse_product_page
                        )
        
        
        
        


