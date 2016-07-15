rm(list=ls(all=TRUE))
library('e1071')
AAPL = read.csv('AAPL.csv')
totalnp = length(AAPL$X)
np = totalnp * 0.9
return = AAPL$AAPL.Close[2:totalnp] - AAPL$AAPL.Close[1:(totalnp-1)]
Y = return / abs(return)
X = AAPL[1:(totalnp-1),]

index = 1:np
TrainY = data.frame(Y[index])
names(TrainY) = c("label")
TrainX = X[index,]
TrainData = cbind(TrainY, TrainX)

TestData = X[-index,]

svm.model = svm( label ~ ., TrainData, kernal='radial', type = 'C-classification', cost = 10, gamma = 0.1)
svm.pred = predict(svm.model, TestData)

svm.test = table(svm.pred, Y[-index])
correct = sum(diag(svm.test) / sum(svm.test)) * 100
