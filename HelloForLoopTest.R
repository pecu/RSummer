rm(list=ls(all=TRUE))
library("quantmod")
getSymbols("AAPL",src="yahoo")
barChart(AAPL)
chartSeries(AAPL,theme="white")
chartSeries(AAPL["2007-05::2014-05"],theme="white")
write.csv(AAPL, "AAPL.csv")


ma_20<-runMean(AAPL[,4],n=10)
addTA(ma_20,on=1,col="blue")
ma_60<-runMean(AAPL[,4],n=20)
addTA(ma_60,on=1,col="red")

allDateNumber = length(ma_20)
return = as.vector( c(1:allDateNumber) )
p = as.vector( c(1:allDateNumber) )
for (dateidx in 1:allDateNumber)
{
  if( dateidx < 60 )
  {
    return[dateidx] = 0
  }
  else
  {
    prePrice = as.numeric(AAPL[dateidx-1, 4])
    nowPrice = as.numeric(AAPL[dateidx, 4])
    return[dateidx] = (prePrice - nowPrice) / prePrice
    if( ma_20[dateidx, 1] < ma_60[dateidx, 1] )
    {
      p[dateidx] = -1
    }
    else if( ma_20[dateidx, 1] > ma_60[dateidx, 1] )
    {
      p[dateidx] = 1
    }
    else
    {
      p[dateidx] = 0
    }
    return[dateidx] = return[dateidx] * p[dateidx]
  }
}

portfolio = cumsum(return)
plot(portfolio)