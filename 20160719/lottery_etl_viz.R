## load Data ##
load("data/lottoryHistDf.RData")

library(reshape2)
library(dplyr)
library(ggplot2)

View(lot)

## choosing what you want ##
lot <- lottoryHistDf %>% select(-c(monthDay, YN, TN, id))

### 2016 ###
lot %>% filter(year =="2016") %>% 
  melt(id.vars = c("year", "month", "day")) %>% 
  filter( variable != "s") %>% group_by(year, value) %>% 
  summarise(count = n()) %>% ggplot(aes(x = value,y = count)) + geom_bar(stat = "identity")

### 2015 ####
p <- lot %>% filter(year =="2015") %>% 
  melt(id.vars = c("year", "month", "day")) %>% 
  filter( variable != "s") %>% group_by(year, value) %>% 
  summarise(count = n()) %>% ggplot(aes(x = value,y = count)) + geom_bar(stat = "identity")

## try choosing 2015 , get range ##
lot %>% filter(year =="2015") %>% 
  melt(id.vars = c("year", "month", "day")) %>% 
  filter( variable != "s") %>% group_by(year, value) %>% 
  summarise(count = n()) %>% filter(count == max(count) | count == min(count))

## exercise ##
lot %>% filter(year !="2016") %>% 
  melt(id.vars = c("year", "month", "day")) %>% 
  filter( variable != "s") %>% group_by(year, value) %>% 
  summarise(count = n()) %>% select(year, count) %>% group_by(year) %>% 
  summarise(min = min(count), max = max(count)) %>% 
  View()


#### Q: believe pattern ? ####
lot.long <- lot %>% melt(id.vars = c("year", "month", "day"))
lot.long %>% filter(variable != "s") %>% group_by(year, value) %>% 
  summarise(count = n()) %>% arrange(desc(count))  %>% 
  select(year, value) %>% group_by(year) %>% summarise(count = n()) %>% 
  View()


library(plotly)
plot_ly(p)
