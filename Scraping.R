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



today <- format(Sys.time(), "%d")
jisdor$Day <- unlist(lapply(str_split(jisdor$Date, " "), `[[`, 1))
newdate <- jisdor[which(jisdor$Day==today),]


#Connect to MongoDB

connection_string = 'mongodb+srv://dbmds001:sta562mds@stamds.kuzgp.mongodb.net/?retryWrites=true&w=majority'
kurs_bi <- mongo(collection="kurs_jisdor'
                db         = 'bot_kurs',
                url = connection_string,
                verbose = TRUE)


#Insert Data to MongoDB

kurs_bi$insert(newdate)
