#####Text Analysis -- Workshop #2
###Camila Lívio 

### from previous workshop: tokenization & stopwords
### today's lesson: *meaning*: concordances (KWIC) and sentiment analysis

###install.packages("package")

library(readr)
library(tidyverse)
library(tidytext)
library(dplyr)
library(stringr)

netflix <- read_csv(file.choose())


net_tokenized <- netflix %>% 
  unnest_tokens(word, description)

net_tokenized %>% 
  count(word)

net_tokenized %>% 
  count(word, sort = TRUE) 

stop_words ###included in the package "tidytext"
head(stop_words, 20)

clean_net <- net_tokenized %>%
  anti_join(stop_words)

clean_net

clean_net %>%
  count(word, sort = TRUE) 

###more packages 
## Quanteda for KWIC 
install.packages("quanteda")
install.packages("tidyverse")
install.packages("gutenbergr")
install.packages("flextable")
install.packages("plyr")

options(stringsAsFactors = F)          # no automatic data transformation
options("scipen" = 100, "digits" = 12) # suppress math annotation
library(quanteda)
library(tidyverse)
library(flextable)


net_text <- netflix$description %>%
  # collapse lines into a single  text
  paste0(collapse = " ") %>%
  # remove superfluous white spaces
  str_squish()

kwic_netflix <- kwic(
  net_text, 
  pattern = "fun")

kwic_netflix

token_netflix <- quanteda::kwic(
  # define and tokenize text
  quanteda::tokens(net_text), 
  # define search pattern
  pattern = "fun")

token_netflix

nrow(kwic_netflix)
length(kwic_netflix$keyword)
table(kwic_netflix$keyword)

kwic_netflix_longer <- kwic(
  # define text
  net_text, 
  # define search pattern
  pattern = "cool", 
  # define context window size
  window = 10)

kwic_netflix_longer

#########
###check out this resource to use regular expressions: https://ladal.edu.au/kwics.html
########

###################################Your turn:
## (1) Look for the word "get" in the corpus 
## (2) How many times does it appear?
## (3) Given the corpus, what can we say about the use of this word?

token_netflix_get <- quanteda::kwic(
  # define and tokenize text
  quanteda::tokens(net_text), 
  # define search pattern
  pattern = "get")

token_netflix_get
nrow(token_netflix_get)
length(token_netflix_get$keyword)
table(token_netflix_get$keyword)
####################################



#####sentiment analysis (or opinion mining)
##"When human readers approach a text, we use our understanding of the emotional intent of words 
##to infer whether a section of text is positive or negative, or perhaps characterized by some 
##other more nuanced emotion like surprise or disgust". (Silge and Robinson 2017)

#install.library("textdata")
library(textdata)
get_sentiments("nrc") %>% 
  head(20)

nrc_joy <- get_sentiments("nrc") %>% 
  filter(sentiment == "joy") ### words that are related to the field of "joy"

#####overall sentiment of joy 
clean_net %>%
  inner_join(nrc_joy) %>%
  count(word, sort = TRUE)

#####words that contribute to sentiment value attribution
bing_word_counts <- clean_net %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, type, sort = TRUE) %>%
  ungroup()

bing_word_counts %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>% 
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~type, scales = "free_y") +
  labs(x = "Contribution to sentiment",
       y = NULL)

bing_word_counts


##### two types of wordclouds
#install.packages("wordcloud")
library(wordcloud)

clean_net %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 75))

#install.packages("reshape2")
library(reshape2)

clean_net %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("gray20", "gray80"),
                   max.words = 75)


###Acknowlegements:
#Schweinberger, Martin. 2022. 
#Concordancing with R. Brisbane: The University of Queensland. url: https://slcladal.github.io/kwics.html (Version 2022.09.13).

#https://www.tidytextmining.com/sentiment.html

#https://adrianapicoral.com




