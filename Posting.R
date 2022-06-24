library(rtweet)
library(mongolite)


#Connect Mongo DB

connection_string <- Sys.getenv("MONGO_DB_CONNECTION")
kurs_bi = mongo(collection=Sys.getenv("MONGO_DB_COLLECTION"),
                db         = Sys.getenv("MONGO_DB_NAME"),
                url=connection_string)



#Connect Twitter

bot <- rtweet::create_token(
  app = "MDSBOT",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"), 
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"), 
  access_token =    Sys.getenv("TWITTER_CONSUMER_ACCESS_TOKEN"), 
  access_secret =   Sys.getenv("TWITTER_CONSUMER_TOKEN_SECRET")
)

#Get Data from DB
df_latest <- kurs_bi$find()
df_latest <- tail(df_latest,1)

#Tweet
tweetskurs <- paste0("Kurs Hari Ini: ", df_latest$Date,  df_latest$Rates)

hashtag <- c("Kurs", "Uang", "Rupiah", "USD", "MongoDB", "ManajemenDataStatistika", "BOT", "JISDOR", "Chart", "ggplot")
samp_word <- sample(hashtag, 3)


#Publish
rtweet::post_tweet(
  status = tweetskurs,
  token = bot
)


