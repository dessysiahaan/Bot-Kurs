library(rtweet)
library(mongolite)
library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(lubridate)

#Connect Mongo DB

connection_string = Sys.getenv("MONGO_DB_CONNECTION")
kurs_bi = mongo(collection=Sys.getenv("MONGO_DB_COLLECTION"),
                db=Sys.getenv("MONGO_DB_NAME"),
                url=connection_string)



#Connect Twitter

bot <- rtweet::create_token(
  app = Sys.getenv("TWITTER_APPS"),
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"), 
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"), 
  access_token =    Sys.getenv("TWITTER_CONSUMER_ACCESS_TOKEN"), 
  access_secret =   Sys.getenv("TWITTER_CONSUMER_TOKEN_SECRET")
)

#Get Data from DB
df <- kurs_bi$find()
df <- tail(df,10)
df_latest <- kurs_bi$find()
df_latest <- tail(df_latest,1)

#Tweet
hashtag <- c("Kurs", "Uang", "Rupiah", "USD", "MongoDB", "ManajemenDataStatistika", "BOT", "JISDOR", "Chart", "ggplot")
samp_word <- sample(hashtag, 3)
tweetskurs <- paste0("Hi Peeps! \n", 
                     "Kurs Hari Ini (", df_latest$Date, "): ",df_latest$Rates, "\n",
                     "Berikut Trend 10 Hari terakhir: \n"
                     "#", samp_word[1], " #", samp_word[2], " #", samp_word[3])
#timeseries
time = df$Date
time = dmy(time)
df$Date = time

#as numeric
df$Rate <- gsub("Rp","",df$Rates)
df$Rate <- gsub(".00","",df$Rate)
df$Rate <- gsub(",", "", df$Rate)
df$Rate <- as.numeric(df$Rate)

#plot
pic <- df %>%
  ggplot( aes(x=Date, y=Rate)) +
  geom_line(color="#69b3a2") +
  ylab("Rates") +
  theme_ipsum()

pic_file <- tempfile( fileext = ".png")
ggsave(pic_file, plot=pic, device="png", dpi=144, width = 8, height = 8, units = 'in')


#Publish
rtweet::post_tweet(
  status = tweetskurs,
  media = pic_file,
  token = bot
)
