######################################################################
### SubWin_Samplers.Forward_Samplor
######################################################################

SubWin_Samplers.Forward_Samplor = function (x.xts, SubWin_Size = 20, Events_Dates = NULL, normailize = TRUE, 
                                            BasePrice_Gen = NULL) 
{
  if (class(Events_Dates) == "character") 
    Events_Dates <- as.Date(Events_Dates)
  
  XTS_Dates = rownames(as.matrix(x.xts))
  if (is.null(Events_Dates)) {
    SubWins_Dates_Index = 1:length(XTS_Dates)
    SubWins_Dates = XTS_Dates
  }
  else {
    SubWins_Dates_Index = which(XTS_Dates %in% Events_Dates)
    SubWins_Dates = XTS_Dates[SubWins_Dates_Index]
  }
  XTS_Length = length(XTS_Dates)
  if (SubWin_Size > 0) {
    SubWins_Dates_Index = SubWins_Dates_Index[which((XTS_Length - 
                                                       SubWins_Dates_Index) > SubWin_Size)]
    SubWins_Dates = XTS_Dates[SubWins_Dates_Index]
    SubWins_Index = cbind(SubWins_Dates, XTS_Dates[SubWins_Dates_Index + 
                                                     SubWin_Size])
    SubWins_Index = apply(SubWins_Index, 1, function(xx) paste(xx[1], 
                                                               xx[2], sep = "::"))
  }
  else {
    SubWins_Index = paste(SubWins_Dates, "::", sep = "")
  }
  if (normailize) {
    SubWins = lapply(SubWins_Index, function(xx) {
      SubWin_XTS = x.xts[xx, ]
      BasePrice = ifelse(test = is.null(BasePrice_Gen), 
                         yes = as.numeric(SubWin_XTS[1, 1]), no = BasePrice_Gen(SubWin_XTS))
      SubWin_XTS = (SubWin_XTS - BasePrice)/BasePrice
      return(list(BasePrice = BasePrice, ReturnSubWin = SubWin_XTS))
    })
    return(SubWins)
  }
  else {
    SubWins = lapply(SubWins_Index, function(xx) {
      SubWin_XTS = x.xts[xx, ]
      return(list(ReturnSubWin = SubWin_XTS))
    })
    return(SubWins)
  }
}

######################################################################
### try SubWin_Samplers.Forward_Samplor
######################################################################

Xt = getSymbols("^SOX",from="2001-01-01",auto.assign = F)

WinSize = 20
sampleData = SubWin_Samplers.Forward_Samplor(x.xts=Cl(Xt),SubWin_Size=WinSize)
head(sampleData)

######################################################################
### PCA 
######################################################################

rawData = do.call(rbind,lapply(sampleData,function(xx) as.numeric(xx$ReturnSubWin)))
model = princomp(rawData)
model$center

eigen_vecs = t(model$loadings)

drawFirstN = 5
par(mar=c(1,1))
plot(1:(WinSize+1),eigen_vecs[1,],type="l",ylim=c(-0.3,0.3))
for (i in 2:drawFirstN){
  points(1:(WinSize+1),eigen_vecs[i,],type="l",col=i)
}