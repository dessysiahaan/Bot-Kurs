library(rtweet)
library(mongolite)


#Connect Mongo DB

connection_string = 'mongodb+srv://dbmds001:sta562mds@stamds.kuzgp.mongodb.net/?retryWrites=true&w=majority'
kurs_bi = mongo(collection="kurs",
                db="jisdor",
                url=connection_string)



#Connect Twitter

bot <- rtweet::create_token(
  app = "MDSBOT",
  consumer_key =    "cgxbRmb3r38XJNLefU920r45L", 
  consumer_secret = "8PRNIgwNPosYupacmtgf3YBQXAizlfC6PLgMbMPy6MYuYHNn1B", 
  access_token =    "1539481739701018624-O1h02p8UezdrB05SrpcY0MclNg2CdT", 
  access_secret =   "0CfGGhL05vOthgin8IqAKbCFToEZS3tX5D9Ui5s7gTQkS"
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


