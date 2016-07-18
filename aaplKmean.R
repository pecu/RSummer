AAPL = read.csv("AAPL.csv")
K = 3
id = c(2,6)
X = AAPL[,id]
for( i in 1:length(X[1,]))
{
  X[,i] = (X[,i] - mean(X[,i])) / sd(X[,i])
}

centers = X[1:K,]
result = kmeans(X, centers, algorithm = "MacQueen")
print(result$centers)

mat = data.frame()
mat = cbind(X, result$cluster)
for( i in 1:K )
{
  id = which(mat$`result$cluster`==i)
  plot(X$AAPL.Volume[id], X$AAPL.Open[id], col = i, 
       xlim=c(min(X$AAPL.Volume),max(X$AAPL.Volume)),
       ylim=c(min(X$AAPL.Open),max(X$AAPL.Open)))
  par(new=T)
}
points(result$centers, col="blue", pch = 8)