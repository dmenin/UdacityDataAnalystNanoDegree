setwd('C:/git/UdacityDataAnalystNanoDegree/R/data')
pf <- read.csv('pseudo_facebook.tsv', sep='\t')
library(ggplot2)

ggplot(aes(x=gender, y = age), data = subset(pf, !is.na(gender))) + geom_boxplot()+
  stat_summary(fun.y=mean,geom = 'point', shape = 4)


ggplot(aes(x=age, y = friend_count), data = subset(pf, !is.na(gender))) + 
  geom_line( aes(color=gender) , stat='summary', fun.y = median)

library(dplyr)

pf.fc_by_age_gender <- pf %.%
  filter(!is.na(gender)) %.%
  group_by(age, gender) %.% 
  summarise(mean_friend_count = mean(friend_count),
            median_friend_count = median(friend_count) * 1,
            n = n()) %.% 
  ungroup()%.% 
  arrange(age)


#Plotting Conditional Summaries
ggplot( aes(x=age, y =median_friend_count), data = pf.fc_by_age_gender) + geom_line(aes(color = gender))


####################################Reshaping Data
#install.packages('reshape2')
#library(reshape2)
pf.fc_by_age_gender.wide <- dcast (pf.fc_by_age_gender,
                                   age ~ gender, value.var = 'median_friend_count')


#Ratio Plot
ggplot(aes(x=age, y = female/male), data=pf.fc_by_age_gender.wide) + 
  geom_line() +
  geom_hline(yintercept = 1, alpha = 0.3, linetype = 2)


#Third Quantitative Variable
pf$year_joined <- floor(2014 - (pf$tenure / 365))
  

