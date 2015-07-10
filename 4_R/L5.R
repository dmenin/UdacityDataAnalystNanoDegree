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

summary(pf$year_joined)
table(pf$year_joined)  

pf$year_joined.bucket <- cut(pf$year_joined, c(2004, 2009, 2011,2012,2014))


table (pf$year_joined.bucket)
ggplot(aes(x=age, y = friend_count), data = subset(pf, !is.na(year_joined.bucket))) + 
  geom_line( aes(color=year_joined.bucket) , stat='summary', fun.y = median)


#Plot the Grand Mean
ggplot(aes(x=age, y = friend_count), data = subset(pf, !is.na(year_joined.bucket))) + 
  geom_line( aes(color=year_joined.bucket) , stat='summary', fun.y = mean) +
  geom_line(stat = 'summary', fun.y=mean, linetype = 2)


#Friending Rate
#friends for each day since they started using fb
(with (subset(pf, tenure>0), summary(friend_count / tenure)))



#Friendships Initiated

ggplot( aes(x=tenure, y=friendships_initiated/tenure), data = subset(pf, tenure>0)) + geom_line(aes(color = year_joined.bucket))




#Bias Variance Trade off Revisited
ggplot(aes(x = 7 * round(tenure / 7), y = friendships_initiated / tenure),
       data = subset(pf, tenure > 0)) +
  geom_line(aes(color = year_joined.bucket),
            stat = "summary",
            fun.y = mean)

ggplot(aes(x = 7 * round(tenure / 7), y = friendships_initiated / tenure),
       data = subset(pf, tenure > 0)) +
  geom_smooth(aes(color = year_joined.bucket))






#yogurt
yo<-read.csv('yogurt.csv')
str(yo)
yo$id <-factor(yo$id)

names(yo)
qplot(data = yo, x=price, fill=I('#F79420'))
#> Number of Purchases

yo <- transform(yo, all.purchases =  strawberry + blueberry + pina.colada + plain +mixed.berry)

qplot(data = yo, binwidth = 1, x=all.purchases, fill=I('#F79420'))


#> Prices Over Time
ggplot(aes(x=time, y=price), data=yo)+geom_jitter(alpha = 1/4, shape=21, fill=I('#F79420'))



set.seed(4230)
sample.ids <- sample(levels(yo$id), 16)

ggplot(aes(x=time, y= price),
       data=subset(yo, id %in% sample.ids)) +
  facet_wrap(~id) + geom_line() + geom_point(aes(size = all.purchases), pch = 1)


# Scatterplot Matrices
install.packages("GGally")
library(GGally)

theme_set(theme_minimal(20))


set.seed(1836)
pf_subset <- pf[,c(2:15)]
names(pf_subset)
ggpairs(pf_subset[sample.int(nrow(pf_subset),1000),])

set.seed(1836)
foo<-pf_subset[sample.int(nrow(pf_subset),1000),]

cor(foo$friendships_initiated, foo$friend_count)
cor(foo$age, foo$mobile_likes)

