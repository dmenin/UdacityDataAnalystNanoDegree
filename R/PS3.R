#diamonds
qplot(x = price, data=diamonds, binwidth = 500) + scale_x_continuous(limit=c(0,20000), breaks=seq(0, 20000,5000))

# Explore the largest peak in the
# price histogram you created earlier.
qplot(x = price, data=diamonds, binwidth = 5) + scale_x_continuous(limit=c(300,2000), breaks=seq(300, 2000,100))


# Break out the histogram of diamond prices by cut.

# You should have five histograms in separate
# panels on your resulting plot.
qplot(x = price, data=diamonds, binwidth = 500) + scale_x_continuous(limit=c(0,20000), breaks=seq(0, 20000,5000)) + 
  facet_wrap(~cut, ncol=5)


by(diamonds$price, diamonds$cut,summary)
by(diamonds$price, diamonds$cut,max)


#Scales and Multiple Histograms
qplot(x = price, data = diamonds) + facet_wrap(~cut)
qplot(x = price, data = diamonds) + facet_wrap(~cut, scales="free_y")


# Price per Carat by Cut
qplot(x = price, y=carat,data = diamonds) + facet_wrap(~cut, scales="free_y")
qplot(x = log10(price), y=carat,data = diamonds, binwidth=500) + facet_wrap(~cut, scales="free_y")

ggplot(data = diamonds, aes(x = price/carat)) +
  geom_histogram(binwidth = 0.01) +
  scale_x_log10() +
  facet_wrap(~cut, scales = "free_y")


# Price Box Plots
qplot(x=color, y=price, data=diamonds, geom='boxplot') + coord_cartesian(ylim=c(0, 10000))

#Interquartile Range - IQR
by(diamonds$price, diamonds$color, summary)
IQR(subset(diamonds, color == 'D')$price)


#Price per Carat Box Plots by Color
ggplot(data = diamonds, aes(x = color, y = price/carat)) + 
  geom_boxplot() +
  coord_cartesian(ylim=c(1000, 6000))


# Carat Frequency Polygon
ggplot(data = diamonds, aes(x = carat)) +
  geom_freqpoly(binwidth=0.01) + 
  scale_x_continuous(breaks=seq(0,5,0.1))


###############
setwd('C:/git/UdacityDataAnalystNanoDegree/R/data')

df<-read.csv('indicator_t 15-24 employ.csv', header = T, row.names = 1, check.names = F)
dfi<-df['Ireland',]
#dfi<-df
dfi<-t(dfi)
year<-row.names(dfi)
dfi<-cbind(dfi,year)
rownames(dfi) <- NULL
dfi<-as.data.frame(dfi)

dfi

qplot(x=year, y=Ireland, data=dfi)

#####friends birthdates:

https://www.facebook.com/tech4IT/posts/388421131250404




