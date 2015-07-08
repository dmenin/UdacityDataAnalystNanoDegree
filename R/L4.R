library(dplyr)
library(ggplot2)
setwd('C:/git/UdacityDataAnalystNanoDegree/R/data')
pf <- read.csv('pseudo_facebook.tsv', sep='\t')


#Group by - option 1
age_groups <- group_by(pf,age)
pf.fc_by_age <- summarise(age_groups,
                          friend_count_mean = mean(friend_count),
                          friend_count_median = median(friend_count),
                          n = n())

pf.fc_by_age <- arrange (pf.fc_by_age, age)

#Group by - option 2
head(pf)
pf.fc_by_age <- pf %>% 
                group_by(age) %>% 
                summarise(friend_count_mean = mean(friend_count),
                          friend_count_median = median(friend_count),
                          n = n()) %>% 
                arrange(age)
#PLOT SUMMARY
ggplot (aes(age, friend_count_mean), data = pf.fc_by_age) +geom_line()


ggplot(aes(x=age, y=friend_count), data = pf) + 
  #xlim(33,90)+
  coord_cartesian(xlim = c(13, 90) , ylim=c(0,1000)) +
  geom_point(alpha = 0.05,
             position = position_jitter(h=0),
             color = 'orange') +
  #coord_trans(y = 'sqrt') +
  geom_line(stat = 'summary', fun.y = 'mean') +
  geom_line(stat = 'summary', fun.y = quantile, probs = .1, linetype = 2, color = 'blue') +
  geom_line(stat = 'summary', fun.y = quantile, probs = .5, color = 'blue') +  
  geom_line(stat = 'summary', fun.y = quantile, probs = .9, linetype = 2, color = 'blue')  




#correlation
cor(pf$age, pf$friend_count)
with (pf, cor.test(age, friend_count, method='pearson'))

with (subset(pf, age<=70), cor.test(age, friend_count, method='pearson'))



#Create Scatterplots
names(pf)

ggplot( aes(x = www_likes_received, y = likes_received), data=pf) + 
  geom_point()+
  xlim(0, quantile(pf$www_likes_received,0.95)) +
  ylim(0, quantile(pf$likes_received,0.95))  +
  geom_smooth(method = 'lm', color = 'red')


with (pf, cor.test(www_likes_received, likes_received, method='pearson'))



## More Caution with Correlation
#install.packages('alr3')
library(alr3)

ggplot( aes(x = Month, y = Temp), data=Mitchell) + geom_point()
with (Mitchell, cor.test(Month, Temp, method='pearson'))



ggplot( aes(x = Month, y = Temp), data=Mitchell) + geom_point() + scale_x_discrete(breaks = seq(0,203,12))

#age with months
pf$age_with_months <- pf$age + (1 - pf$dob_month / 12) 

pf.fc_by_age_months  <- pf %>% 
                        group_by(age_with_months) %>% 
                        summarise(friend_count_mean = mean(friend_count),
                        friend_count_median = median(friend_count),
                        n = n()) %>% 
                        arrange(age_with_months)
#age with months plot
ggplot (aes(age_with_months, friend_count_mean), data = subset(pf.fc_by_age_months, age_with_months<71)) +geom_line()


p1 <- ggplot (aes(age, friend_count_mean), data = subset(pf.fc_by_age, age <71)) +geom_line() +geom_smooth()
p2 <- ggplot (aes(age_with_months, friend_count_mean), data = subset(pf.fc_by_age_months, age_with_months<71)) +geom_line() +geom_smooth()
p3 <-   ggplot (aes(x = round(age / 5) * 5, y=friend_count), 
          data=subset(pf, age<71)) +
  geom_line(stat='summary', fun.y = mean) 

#install.packages("gridExtra")
#library(gridExtra)

grid.arrange(p2,p1, p3, ncol=1)
