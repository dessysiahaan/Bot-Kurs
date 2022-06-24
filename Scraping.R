library(rvest)
library(stringr)
library(mongolite)

#Scraping
  

url <- "https://www.bi.go.id/en/statistik/informasi-kurs/jisdor/Default.aspx"
html <- url %>% read_html



jisdor <- html %>%
  html_node(".table-lg") %>% #table-lg
  html_table

str(jisdor)
jisdor



#Connect to MongoDB

connection_string = 'mongodb+srv://dbmds001:sta562mds@stamds.kuzgp.mongodb.net/?retryWrites=true&w=majority'
kurs_bi <- mongo(collection='kurs'
                db         = 'jisdor',
                url = connection_string,
                verbose = TRUE)


#Insert Data to MongoDB

kurs_bi$insert(jisdor)
