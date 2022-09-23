#######Intro to Text Analysis -- The Basics 
###Camila Lívio 

#"Analysts are often trained to handle tabular or rectangular data that is mostly numeric,
#but much of the data proliferating today is unstructured and text-heavy. 
#Many of us who work in analytical fields are not trained in even simple interpretation of
#natural language" (Silge and Robinson 2017)

###What are we doing today? 
#Learning about the basics of text analysis with R
#Use text as data frames (individual words) and manipulate, summarize, 
#and visualize 

## Focus: (1) Loading the data; (2) tokenization and (3) stopwords 

sessionInfo()
getwd()

### We'll need to install (or simply load) some packages
#install.library("readr")
#install.library("tidyverse")
#install.library("tidyr")
#install.library("tidytext")
#install.library("ggpplot2")

library(readr)
library(tidyverse)
library(tidyr)
library(tidytext) #Julia Silge's package
library(ggplot2)

###uploading the data 
###storing the data in a new object that we'll call netflix
netflix <- read_csv(file.choose()) 
netflix

### inspecting the data -- What does its structure look like?
nrow(netflix)
ncol(netflix)

glimpse(netflix)
show(netflix)

### what kind and how many different types of shows are there?
netflix %>%
  count(type)

###countries?
netflix %>%
  count(country)

### how about directors?
netflix %>%
  count(director, sort = TRUE) 

### from which years? 
range(netflix$release_year) 

#### Text Analysis: tokenization and stopwords
## we're now going to zoom in the "description" part of the data set 
## predictions: what kinds of words are we going to encounter?
## tokenization: splitting the text into individual words, one per row
## tidytext is great because it does the transformations for us: strips punctuation and converts all the characters to lower case 
## the default splits the text into words (they can be split into n-grams, bigrams...)
glimpse(netflix)

net_tokenized <- netflix %>% 
  unnest_tokens(word, description)

net_tokenized %>% 
  count(word)

net_tokenized %>% 
  count(word, sort = TRUE) 

###What can we learn about our data?
#very frequent words are functional words 
#they frequently do not matter in computational text analysis

### on to stopwords

### Cleaning stopwords
stop_words ###included in the package "tidytext"

clean_net <- net_tokenized %>%
  anti_join(stop_words)

clean_net

clean_net %>%
  count(word, sort = TRUE) 
##inspect the output. What changed there?

#--------------------------------------------------
##what if you work on languages other English? 
## %>% 
## anti_join(get_stopwords(language= "pt"))
#--------------------------------------------------

clean_net %>%
  count(word, sort = TRUE) %>%
  mutate(word = reorder(word, n)) %>%
  top_n(20) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)

###now we'll observe how the *words* and their "type" (tv show & movies) are related 

clean_net %>%
  count(word, type) %>%
  arrange(-n) %>%
  head()

word_frequency_per_type <- clean_net %>%
  count(word, type)

word_frequency_per_type %>%
  group_by(type) %>%
  top_n(20) %>%
  ggplot(aes(x = n, 
             y = reorder_within(word, n, type))) +
  geom_col() +
  facet_wrap(~type, scales = "free_y") +
  scale_y_reordered() +
  labs(y = "")

### (1) Loading our data, (2) tokenization, (3) stopwords == these steps are essential for our next workshop!

#############
#############
##extra
#############
#############

##bigrams
net_bigrams <- netflix %>%
  unnest_tokens(ngram, description, token = "ngrams", n = 2)

net_bigrams %>% 
  head()

net_bigrams$ngram

##trigrams?
net_trigrams <- netflix %>%
  unnest_tokens(ngram, description, token = "ngrams", n = 3)

net_trigrams %>% 
  head()

net_trigrams$ngram


#### Acknowledgments
# https://www.tidytextmining.com/index.html
# https://adrianapicoral.com







