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
library(plyr)

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
emptyId = which(mat == "")
mat = t(matrix(mat[-emptyId]))

totalSegment = data.frame()
needChar = c("噓","推","爆","屌","拍")

for( i in 1:length(mat[1,]) )
{
  result = segment(as.character(mat[1,i]), jiebar=mixseg)
  cid = length(result)
  delId = vector()
  print(result)
  for( j in 1:cid )
  {
    if( nchar(result[j]) < 2 && 
        is.element(result[j], needChar) == FALSE )
    {
      delId = rbind(delId, j)
      print(j)
    }
  }
  print(delId)
  result = result[-delId]
  totalSegment = rbind(totalSegment, data.frame(result))
}
reducedSegment = data.frame()
reducedSegment = rbind(reducedSegment,data.frame(totalSegment$result[nchar(as.vector(totalSegment[,1]))>=2]))
names(reducedSegment) = c("result")

reduceDiff = count(reducedSegment$result)
totaldiff = count(totalSegment$result)
totaldiff$freq = totaldiff$freq / sum(totaldiff$freq)

wordcloud(totaldiff$x, totaldiff$freq, min.freq = 1, random.order = F, ordered.colors = T, 
          colors = rainbow(length(totaldiff$x)))