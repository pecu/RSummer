rm(list=ls(all=TRUE))
library(XML)
library(bitops)
library(RCurl)
library(NLP)
library(httr)

Sys.setlocale("LC_ALL", "cht")

alldata = read.csv('alldata.csv')
orgURL = 'https://www.ptt.cc'
for( i in 1:length(alldata$X))
{
  pttURL <- paste(orgURL, alldata$path[i], sep='')
  urlExists = url.exists(pttURL)
  
  if(urlExists)
  {
    html = getURL(pttURL, ssl.verifypeer = FALSE, encoding='UTF-8')
    xml = htmlParse(html, encoding='UTF-8')
    text = xpathSApply(xml, "//div[@id='main-content']", xmlValue)
    name <- paste('./allText/c', i, '.txt', sep='')
    write(text, name)
  }
}