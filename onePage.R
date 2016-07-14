rm(list=ls(all=TRUE))
# get html data
library(XML)
library(bitops)
library(RCurl)
library(NLP)
library(httr)
library(jiebaRD)
library(jiebaR)       # 斷詞利器
library(NLP)
library(tm)           # 文字詞彙矩陣運算
library(slam)         # 稀疏矩陣運算
library(RColorBrewer)
library(wordcloud)    # 文字雲
library(topicmodels)  # 主題模型

Sys.setlocale("LC_ALL", "cht")

pttURL = 'https://www.ptt.cc/bbs/movie/M.1468393456.A.0B2.html'
html = getURL(pttURL, ssl.verifypeer = FALSE, encoding='UTF-8')
xml = htmlParse(html, encoding='UTF-8')
text = xpathSApply(xml, "//div[@id='main-content']", xmlValue)
name = './onepage/ctest.txt'
write(text, name)

text = Corpus(DirSource('./onepage/'), list(language = NA))
text <- tm_map(text, removePunctuation)
text <- tm_map(text, removeNumbers)
text <- tm_map(text, function(word)
{ gsub("[A-Za-z0-9]", "", word) })

mixseg = worker()
mat <- matrix( unlist(text), nrow=length(text) )
totalSegment = data.frame()
for( i in 1:length(mat[1,]) )
{
  result = segment(as.character(mat[1,i]), jiebar=mixseg)
  print(result)
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

names(countMat) = c("diff", "freq")
countMat$freq = countMat$freq / sum(countMat$freq)

wordcloud(countMat$diff, countMat$freq, min.freq = 1, random.order = F, ordered.colors = T, 
          colors = rainbow(length(totaldiff)))