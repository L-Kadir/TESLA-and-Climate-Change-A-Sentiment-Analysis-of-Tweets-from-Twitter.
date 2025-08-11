#load libraries
library(tidytext)
library(dplyr)
library(tidyr)
library(ggraph)
library(igraph)
library(textdata)
library(naniar)
library(wordcloud)

#######################################################################################
## Load and filter the data for Tweets about Tesla 
#######################################################################################
## Load the data
tweets <- readRDS("tweet_150k_sample.rds")


## Filter the tweets that focused on "Tesla"
hashtag_tweets<- tweets[grep("Tesla",tweets$msg,fixed = FALSE, ignore.case = TRUE), ]


#######################################################################################
## ETL
#######################################################################################
dim(tweets)
str(hashtag_tweets)
summary(hashtag_tweets) 
head(hashtag_tweets, 3)
tail(hashtag_tweets, 3)
any_na(hashtag_tweets)

#Getting rid of empty columns(i.e., time_zone and source)
empty_cells <- function(data) {
  sapply(names(data), 
         function(col) sum(data[[col]] == "", na.rm = TRUE))
}

empty_cells(hashtag_tweets) ## "time_zone" and "source" are completely empty colums
hashtag_tweets <- hashtag_tweets [,-c(6:7)] ## delete "time_zone" and "source" columns

## replace the 3954 empty cells in "hastags" column with "unknown".
hashtag_tweets$hashtags<- sub("^$", "unknown", hashtag_tweets$hashtags)


#######################################################################################
## More preprocessing
#######################################################################################
## create a new column to capture the row numbers
hashtag_tweets_new <- hashtag_tweets |>
  mutate (h_number = row_number())

## using "unnest_tokens" to break the sentences into individual words and
## convert everthing into lower case
hashtag_tweets_clean <- hashtag_tweets_new |>
  unnest_tokens(word, msg)

## checking the top 20 words (i.e., in terms of frequency of appearance)
hashtag_tweets_clean |> 
  count(word, sort = TRUE) |>
  slice_max(n, n=20)
  
## removing stop words like "a", "in", "to", "i","of", "is", "at", etc.
head(stop_words, 30) # check some of the stop words
hashtag_tweets_clean <- hashtag_tweets_clean |>
  anti_join(stop_words)

## checking the top 20 words again
hashtag_tweets_clean |>
  count(word, sort = TRUE) |>
  slice_max(n, n=20)

## Now, checking the sentiment of our words using three lexicons:
## namely, "nrc", "bing", and "afinn".
hashtag_tweets_clean |> 
  select(word) |> 
  inner_join(get_sentiments("nrc")) |> 
  count(word, sort = TRUE) |> 
  top_n(20)

hashtag_tweets_clean |> 
  select(word) |> 
  inner_join(get_sentiments("bing")) |> 
  count(word, sort = TRUE) |> 
  top_n(20)

hashtag_tweets_clean |>
  inner_join(get_sentiments("afinn")) |>
  select(word) |>
  count(word, sort = TRUE) |> 
  top_n(20)


#######################################################################################
## Now, lets generate the word cloud and save the picture as .png
#######################################################################################
## counting the frequency of the words
tweets_WordCount <- hashtag_tweets_clean |>
  count(word, sort=TRUE) |> 
  top_n(20) |>
  mutate(word = reorder(word,n)) 

wordcount <- tweets_WordCount |> ggplot(aes(x=word, y=n)) +
                    geom_bar(stat="identity", fill = "#708090") + 
                    coord_flip() + 
                    labs(x="Word",y="word Count",title="Word Frequency") +
                    theme_minimal(base_size = 14) +
                    theme(
                    panel.grid.major = element_blank(),
                    panel.grid.minor = element_blank()
               )
wordcount 
ggsave("word_frequency.png", 
       plot = wordcount, 
       width = 8, 
       height = 6)

       
## The word cloud
tweets_wordcloud <- hashtag_tweets_clean |>
  count(word, sort=TRUE)  |>
  top_n(300)

wordcloud(tweets_wordcloud$word, 
                  tweets_wordcloud$n, 
                  random.order=FALSE, 
                  colors=brewer.pal(8,"Dark2"))

## checking the number of retweets "i.e., rt"
tweets_wordcloud |>
  filter(word == "rt") ## 2600 retweets

### Now, creating a network diagram based on bi-grams
tweetsBigram <- hashtag_tweets_new |>
  unnest_tokens(bigram, msg, token = "ngrams", n = 2)

tweetsBigram |>
  count(bigram,sort=TRUE) |>
  top_n(20) ## checking the first 20 "bi-gram" that shows up often

tweetsBigramCount <- tweetsBigram |>
  separate(bigram, c("word1", "word2"), sep = " ") |>
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) |>
  count(word1, word2, sort = TRUE) ## getting rid of the common words(since they are not important)

## plot the bi-gram
tweetsBigramCount %>%  filter(n>=100) %>%
  graph_from_data_frame() %>% ggraph(layout = "fr") +
  geom_edge_link(aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "darkslategray4", size = 3) +
  geom_node_text(aes(label = name), vjust = 1.8, size = 3) +
  labs(title = "Word Network: tweets",
       subtitle = "Text mining ",
       x = "", y = "") +
  theme_void()

####################################################################
## Removing the "garbage" words and generate all three graphs again
####################################################################
## first, make a custom list of "stop words" to be removed 
## and then using an "anti-join" to remove them.
custom_stop_list <- tibble(
  word = c("rt","yg4jonxoir","3","https","bvnrcxew2o","kavita_tewari",
           "tco","praveg", "ppathole", "tesla", "24","2009", "qu"))
tweets_clean <- hashtag_tweets_clean |>
  anti_join(custom_stop_list)

## Now, let create a bar plot this time
tweetsWordCount <- tweets_clean |>
  count(word, sort=TRUE) |>
  top_n(20) |>
  mutate(word = reorder(word,n)) 

wordcount_new <- tweetsWordCount |> ggplot(aes(x=word, y=n)) +
     geom_bar(stat="identity", fill = "#708090") + 
     coord_flip() + 
     labs(x="Word",y="word Count",title="Word Frequency") +
     theme_minimal(base_size = 14) +
     theme(
       panel.grid.major = element_blank(),
       panel.grid.minor = element_blank()
     )    ## new plot
wordcount_new  

ggsave("word_frequency_new.png", 
       plot = wordcount, 
       width = 8, 
       height = 6)


## New wordcloud after removing the "manually-created" stop words:
tweets_wordcloud_new <- tweets_clean |>
  count(word, sort=TRUE)  |>
  top_n(300) ## we got 310 because "ties" are included.

##  New word cloud
wordcloud(tweets_wordcloud_new$word, 
          tweets_wordcloud$n, 
          random.order=FALSE, 
          colors=brewer.pal(8,"Dark2"))









