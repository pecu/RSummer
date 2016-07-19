library("foreign")
library("ggplot2")
library("MASS")
library("Hmisc")
library("reshape2")

# Data Source: http://www.ats.ucla.edu/stat/r/dae/ologit.htm
dat <- read.csv("gpaData.csv")
head(dat)

lapply(dat[, c("apply", "pared", "public")], table)
ftable(xtabs(~ public + apply + pared, data = dat))
summary(dat$gpa)
sd(dat$gpa)
ggplot(dat, aes(x = apply, y = gpa)) +
geom_boxplot(size = .75) +
geom_jitter(alpha = .5) +
facet_grid(pared ~ public, margins = TRUE) +
theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

m <- polr(apply ~ pared + public + gpa, data = dat, Hess=TRUE)
summary(m)