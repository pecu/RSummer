rm(list=ls(all=TRUE))
# install.packages("jiebaR")
# install.packages("tm")
# install.packages("slam")
#install.packages("RColorBrewer")
# install.packages("wordcloud")
# install.packages("topicmodels")
# install.packages("igraph")

library(jiebaRD)
library(jiebaR)       # 斷詞利器
library(NLP)
library(tm)           # 文字詞彙矩陣運算
library(slam)         # 稀疏矩陣運算
library(RColorBrewer)
library(wordcloud)    # 文字雲
library(topicmodels)  # 主題模型

Sys.setlocale("LC_ALL", "cht")

orgPath = "./subText"
text = Corpus(DirSource(orgPath), list(language = NA))
text <- tm_map(text, removePunctuation)
text <- tm_map(text, removeNumbers)
text <- tm_map(text, function(word)
{ gsub("[A-Za-z0-9]", "", word) })

# 進行中文斷詞
mixseg = worker()
mat <- matrix( unlist(text), nrow=length(text) )
totalSegment = data.frame()
for( j in 1:length(text) )
{
  for( i in 1:length(mat[j,]) )
  {
    result = segment(as.character(mat[j,i]), jiebar=mixseg)
  }
  totalSegment = rbind(totalSegment, data.frame(result))
}

totaldiff = levels(totalSegment$result)
countMat = data.frame(totaldiff, c(rep(0, length(totaldiff))))
for( i in 1:length(totalSegment$result) )
{
  for( j in 1:length(totaldiff) )
  {
    if( nchar(totaldiff[j]) >= 2 &&
        totaldiff[j] == as.character(totalSegment$result[i]) )
    {
      countMat[j,2] = countMat[j,2] + 1
    }
  }
}

names(countMat) = c("totaldiff", "freq")
countMat[,2] = countMat[,2] / sum(countMat[,2])

wordcloud(countMat$totaldiff, countMat$freq, min.freq = 1, random.order = F, ordered.colors = T, 
          colors = rainbow(length(totaldiff)))
