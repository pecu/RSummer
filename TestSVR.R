rm(list=ls(all=TRUE))
library('e1071')
AAPL = read.csv('AAPL.csv')
totalnp = length(AAPL$X)
np = totalnp * 0.9
return = (AAPL$AAPL.Close[2:totalnp] - AAPL$AAPL.Close[1:(totalnp-1)]) / AAPL$AAPL.Close[1:(totalnp-1)]
Y = return
X = AAPL[1:(totalnp-1),]

index = 1:np
TrainY = data.frame(Y[index])
names(TrainY) = c("label")
TrainX = X[index,]
TrainData = cbind(TrainY, TrainX)

TestData = X[-index,]

svm.model = svm( label ~ ., TrainData, kernal='radial', type = 'eps-regression', cost=1, gamma=0.0001)
svm.pred = predict(svm.model, TestData)

RMSE = sqrt( mean( ((svm.pred - Y[-index])/Y[-index])^2 ) )