rm(list=ls(all=TRUE))
library("quantmod")

getSymbols("AAPL",src="yahoo")
barChart(AAPL)
chartSeries(AAPL,theme="white")
chartSeries(AAPL["2007-05::2014-05"],theme="white")
write.csv(AAPL, "AAPL.csv")

ma_20<-runMean(AAPL[,4],n=20)
addTA(ma_20,on=1,col="blue")
ma_60<-runMean(AAPL[,4],n=60)
addTA(ma_60,on=1,col="red")

p<-Lag(ifelse(ma_20<ma_60, 1,0))
return<-ROC(AAPL[,4])*p
return<-return['2007-05-31/2014-05-31']
return<-exp(cumsum(return))
plot(return)