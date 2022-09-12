##### Fall into Research 2022
#### R for Data Science 
#### Dr. Katie Ireland & Camila Lívio 

getwd()

##DATA
### Kaggle: Data Science Job Salaries 
#https://www.kaggle.com

###PACKAGES: Packages are collections of R functions, data, and compiled code.
###There are 10,000+ user contributed packages and growing.
# == It means that a lot of the very complicated work was done and it's shared with you!

#install.packages("readr")
#install.packages("tidyverse")
#install.packages("dplyr")
library(readr)
library(tidyverse)
library(dplyr)

job_sal <- read_csv("/Users/camilalivio/Desktop/Digi_Workshops/ds_salaries.csv") #for Mac users 
job_sal <- read_csv("C:\\Users\\camilalivio\\Desktop\\Digi_Workshops\\ds_salaries.csv") #for Windows users

##Mac users should use single forward slashes
##Windows users have to use double back slashes

### the data is in! 
### how do we know that?

#### get an idea of what the data looks like 

glimpse(job_sal)
#607 rows 
#12 cols 

summary(job_sal)

### what are the variables in this data set?
colnames(job_sal)

unique(job_sal$salary_in_usd)
unique(job_sal$experience_level)
##hard to make sense of the numbers 

range(job_sal$salary_in_usd)
##much better 

## a little bit of data types!
##which variables are numerical and which are categorical?

## hint: glimpse() it!
glimpse(job_sal)

####################### EXPLORING THE DATA ###########################
### the relationships between these numbers and variables 
### example:
### How does the *experience level* relate with the variable *salary*? 
### Are remote employees making more/less money than in-house employers? 

#Note: "HARK-ing (or hypothesizing after results are known)" (Gawne and Styles 2022: 17)

### Getting the know these relationships will give us knowledge about the data set 
### + generate hypothesis and questions that will/may lead to forecasts about it 

##"The goal of data exploration is to generate many promising leads 
## that you can later explore in more depth." (Wickham and Grolemund 2017)

job_sal %>% 
  summary()

### introducing the pipe: %>%!!!!
# mac users: shift + command + m
# windows users: ctrl + shift + m
### It allows us to apply multiple functions (do things!) to a data set at the same time 

job_sal %>% 
  count(job_title)

## Hypothesis 1: the more experienced the employer, the higher the salary
job_sal %>% 
  count(salary_in_usd)

job_sal %>% 
  count(salary_in_usd, experience_level)

##What happened here?

job_sal %>% 
  group_by(experience_level, salary) %>% 
  count()

##very nice! but we can't really see much or make sense of it...

##################### Data Viz ######################
install.packages("ggplot2")
library(ggplot2)

ggplot(data = job_sal) + 
  geom_point(mapping = aes(x =experience_level, y = salary_in_usd ))

##What do y'all think? 

ggplot(data = job_sal) + 
  geom_point(mapping = aes(x = experience_level, y = salary_in_usd, color = experience_level))

####################################################################################################
###combining the numbers and the viz

job_sal %>%
  ggplot(aes(x = salary_in_usd, y = employment_type,
             color = company_size,
             group = company_size)) +
  geom_jitter() 

### Some ***excellent*** resources:
#https://r4ds.had.co.nz (R for Data Science)
#https://d1b10bmlvqabco.cloudfront.net/attach/ighbo26t3ua52t/igp9099yy4v10/igz7vp4w5su9/OReilly_HandsOn_Programming_with_R_2014.pdf
#https://adrianapicoral.com (Dr. Adriana Picoral)
#https://joeystanley.com (Dr. Joey Stanley)



