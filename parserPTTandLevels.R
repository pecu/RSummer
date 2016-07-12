rm(list=ls(all=TRUE))
library(XML)
library(bitops)
library(RCurl)
library(httr)

orgURL = 'https://www.ptt.cc/bbs/movie/index'
#orgURL = 'https://www.ptt.cc/bbs/StupidClown/index.html'

startPage = 500
endPage = 600
alldata = data.frame()
for( i in startPage:endPage)
{
  pttURL <- paste(orgURL, i, '.html', sep='')
  urlExists = url.exists(pttURL)
  
  if(urlExists)
  {
    html = getURL(pttURL, ssl.verifypeer = FALSE)
    xml = htmlParse(html, encoding ='utf-8')
    title = xpathSApply(xml, "//div[@class='title']/a//text()", xmlValue)
    author = xpathSApply(xml, "//div[@class='author']", xmlValue)
    path = xpathSApply(xml, "//div[@class='title']/a//@href")
    date = xpathSApply(xml, "//div[@class='date']", xmlValue)
    response = xpathSApply(xml, "//div[@class='nrec']", xmlValue)
    tempdata = data.frame(title, author, path, date, response)
    alldata = rbind(alldata, tempdata)
  }
}

# write data to csv file
write.csv(alldata, 'alldata.csv')

currentDate = c(1)
currentVector = data.frame()
inputdata = data.frame()
currentPoint = 1
currentVector = rbind(currentVector, data.frame(alldata$date[1]))
names(currentVector) = c("diffdate")
for( i in 1:length(alldata$date) )
{
  currentDate = alldata[i,4]
  if( as.numeric(currentDate[1]) != as.numeric(currentVector[currentPoint,1]) )
  {
    inputdata = data.frame(currentDate[1])
    names(inputdata) = c("diffdate")
    currentVector = rbind(currentVector, inputdata)
    currentPoint = currentPoint + 1
  }
}

allDate = currentVector$diffdate
#allDate = levels(alldata$date)
res = hist(as.numeric(alldata$date), nclass=length(allDate), axes=F, labels=T) 
axis(1, at=1:length(allDate), labels=allDate)
axis(2, at=1:max(res$counts), labels=1:max(res$counts))