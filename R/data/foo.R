setwd('C:/git/nanodegree/R')

statesInfo <- read.csv('data/stateData.csv')
statesInfo


subset(statesInfo, state.region==1)
statesInfo[statesInfo$state.region==1,]
################

reddit <- read.csv('data/reddit.csv')

str(reddit)
table(reddit$employment.status)
summary(reddit)


levels(reddit$children)

plot(reddit$age.range)
library(ggplot2)
qplot(data = reddit, x = age.range)


str(reddit)
