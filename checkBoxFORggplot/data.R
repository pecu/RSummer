library(plyr)
library(BBmisc)

allType = 1:9
df <- data.frame(x=rep(1:5, 9), val=sample(1:100, 45), 
                 variable=rep(paste0("category", 1:9), each=5))
allCategory =count(df$variable)
checkboxList = convertRowsToList(
  data.frame(as.factor(allType), allCategory$x))