library(GA)

# our goal is to find the following function
f <- function(x)
{
  25-x*x
}

GAresult <- ga(type = "real-valued", 
               f,
               min=0,
               max=100,
               popSize = 50, 
               pcrossover = 0.8,
               pmutation = 0.1, 
               elitism = 10, 
               maxiter = 100)

plot(GAresult)
