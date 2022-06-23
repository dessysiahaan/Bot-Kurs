library(rvest)
library(stringr)

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

user <- Sys.getenv("MONGO_DB_USER")
pass <- Sys.getenv("MONGO_DB_PASSWORD")
cluster <- Sys.getenv("MONGO_DB_CLUSTER")
code <- Sys.getenv("MONGO_DB_CODE")

connection_string <- paste0('mongodb+srv://', user, ":" pass, "@", cluster, ".", code, '.mongodb.net/?retryWrites=true&w=majority')
kurs_bi = mongo(collection=Sys.getenv("MONGO_DB_COLLECTION"),
                db         = Sys.getenv("MONGO_DB_NAME"),
                url=connection_string)


#Insert Data to MongoDB

kurs_bi$insert(newdate)
