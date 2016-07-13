rm(list=ls(all=TRUE))
library('e1071')
AAPL = read.csv('AAPL.csv')
index = 1:nrow(AAPL)
AAPL[,2:5] = log(AAPL[,2:5])
np = ceiling(0.1 * nrow(AAPL))

return = AAPL[2:nrow(AAPL), 5] - AAPL[1:(nrow(AAPL)-1), 5]
return = append(return, 0, after=0)
label = ifelse(return > 0, 1, 0)
AAPL = cbind(AAPL, return, label)

test.index = sample(1:nrow(AAPL), np)
test.index = 1:np

AAPL.test = AAPL[test.index, ]
AAPL.train = AAPL[-test.index, ]

tuned = tune.svm(label ~ ., data = AAPL.train, gamma = 10^(-3:-1), cost = 10^(-1:1))
summary(tuned)

# 部分屬性
APPLsub.train = AAPL.train[,c(2,4,5,9)]
svm.model = svm(label ~ ., data = APPLsub.train, kernal='radial', type = 'C-classification', cost = 10, gamma = 0.1)
# 全部屬性
# svm.model = svm(label ~ ., data = AAPL.train, kernal='radial', type = 'C-classification', cost = 10, gamma = 0.1)

# 部分屬性
APPLsub.test = AAPL.test[, c(2,4,5,9)]
svm.pred = predict(svm.model, APPLsub.test[, -9])
# 全部屬性
# svm.pred = predict(svm.model, AAPL.test[, -9])

table.svm.test = table(pred = svm.pred, true = AAPL.test[, 9])
correct.svm = sum(diag(table.svm.test) / sum(table.svm.test)) * 100

AAPL.test = cbind(AAPL.test[2:np,], AAPL.test[2:np,5] - AAPL.test[1:(np-1),5])
label = as.numeric(svm.pred)-1
BuyAPPL = cbind(AAPL.test[,10], label[1:(np-1)])
return = exp(cumsum(BuyAPPL[,1] * BuyAPPL[,2]))
plot(return)