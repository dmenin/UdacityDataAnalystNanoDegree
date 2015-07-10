setwd('C:/git/nanodegree/R')
library(ggplot2)



pf<-read.delim('data/pseudo_facebook.tsv') 

qplot(x = friend_count, data=pf, xlim = c(0,1000)) 

qplot(x = friend_count, data= subset(pf, !is.na(gender)), binwidth = 25)  + 
  scale_x_continuous(limits = c(0,1000), breaks = seq(0, 1000, 50)) +
  facet_wrap(~gender)

table(pf$gender)
by(pf$friend_count, pf$gender, summary)

##---------------------------------tenure
#day
qplot (x = tenure, data = pf, binwidth = 30, color = I('black'), fill = I('#099DD9'))

#year
qplot (x = tenure/365, data = pf, 
       xlab = 'Number of years using Facebook',  
       ylab = 'Number of users in sample',
       binwidth = .25, color = I('black'), fill = I('#F79420')
      ) +
      scale_x_continuous(breaks = seq (1,7,1), limits = c(0,7)) 
  


##------------------------------AGE
qplot (x = age, data = pf, 
       binwidth = 1, color = I('black'), fill = I('#5760AB')
) +
  scale_x_continuous(breaks = seq (10,100,5), limits = c(10,100)) 




---------------------------
  # why use a log scale rather than a linear scale?
  #http://www.r-statistics.com/2013/05/log-transformations-for-skewed-and-wide-distributions-from-practical-data-science-with-r/
  
  
summary(pf$friend_count)
summary(log10(pf$friend_count+1))
summary(sqrt(pf$friend_count))


summary((pf$friend_count-mean(pf$friend_count))/sd(pf$friend_count))

#install.packages("gridExtra")
#library(gridExtra)

#option1: x axis labeled as the result of the fucntion
p1 = qplot(x=friend_count, data = pf)
p2 = qplot(x=log10(pf$friend_count+1), data = pf)
p3 = qplot(x=sqrt(pf$friend_count+1), data = pf)
p4 = qplot(x= (pf$friend_count-mean(pf$friend_count))/sd(pf$friend_count), data = pf)
grid.arrange(p1, p2, p3, p4,  ncol=1)


#option 2: x axis labeld in friend counts
p1 <- ggplot(aes(x = friend_count), data=pf) + geom_histogram()
p2 <- p1 + scale_x_log10()
p3 <- p1 + scale_x_sqrt()
grid.arrange(p1, p2, p3,  ncol=1)




###-------------------- frequency polygon

qplot(x = friend_count, y = ..count../sum(..count..),
      xlab = 'Friend Count', 
      ylab = 'Percentage of users with that friend count',
      data= subset(pf, !is.na(gender)), 
      binwidth = 10, geom = 'freqpoly', color = gender)  + 
  scale_x_continuous(limits = c(0,1000), breaks = seq(0, 1000, 50)) 


qplot(x = www_likes, data= subset(pf, !is.na(gender)), 
      geom = 'freqpoly', color = gender)  + scale_x_continuous()  +scale_x_log10()




by(pf$www_likes, pf$gender, sum)

#Ylim like this, removes data points from the calculations
qplot(x=gender , y=friend_count,
      data= subset(pf, !is.na(gender)), geom='boxplot' , ylim = c(0,1000) )

#coord_cartesian does not remove the values from the calculations
qplot(x=gender , y=friend_count,
      data= subset(pf, !is.na(gender)), geom='boxplot') +
      coord_cartesian(ylim = c(0,1000))



qplot(x=gender , y=friendships_initiated,
      data= subset(pf, !is.na(gender)), geom='boxplot') +
  coord_cartesian(ylim = c(0,150))

by(pf$friendships_initiated, pf$gender, summary)


#-----------------------------
summary(pf$mobile_likes)
summary(pf$mobile_likes > 0)

pf$mobile_check_in <- NA
pf$mobile_check_in <- ifelse(pf$mobile_likes>0,1,0)
pf$mobile_check_in <- factor(pf$mobile_check_in)

summary(pf$mobile_check_in)
sum(pf$mobile_check_in==1)/length(pf$mobile_check_in)

