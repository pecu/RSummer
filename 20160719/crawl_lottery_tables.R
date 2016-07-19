library(httr)
library(rvest)
library(stringr)

url = "http://www.nfd.com.tw/lottery/49-year/49-2015.htm"
tables = read_html(url) %>% html_table()
dataTable = tables[[1]][-1,]
colnames(dataTable) <- c("year","monthDay","YN","x1","x2","x3","x4","x5","x6","s","TN")

# View(dataTable)

getLotteryDf = function(url){
  tables = read_html(url) %>% html_table()
  dataTable = tables[[1]][-1,]
  colnames(dataTable) <- c("year","monthDay","YN","x1","x2","x3","x4","x5","x6","s","TN")
  return(dataTable)
}

urls = sprintf("http://www.nfd.com.tw/lottery/49-year/49-%s.htm",2004:2016)

lottoryHistDf = do.call(rbind, lapply(urls,getLotteryDf))

# View(lottoryHistDf)

lottoryHistDf$x1 = str_replace_all(lottoryHistDf$x1," |[\r]|[\n]|[\t]|[$,\xe3\x80\x80]|[$,\xc2\xa0]","")
lottoryHistDf$monthDay = str_replace_all(lottoryHistDf$monthDay," |[\r]|[\n]|[\t]","")
monthDay = do.call(rbind,str_extract_all(lottoryHistDf$monthDay,pattern = "[0-9]+"))
lottoryHistDf$month = monthDay[,1]
lottoryHistDf$day = monthDay[,2]
lottoryHistDf$id = 1:dim(lottoryHistDf)[1]

save(lottoryHistDf,file = "data/lottoryHistDf.RData")