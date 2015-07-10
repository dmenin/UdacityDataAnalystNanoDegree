#rm(list=ls())
install.packages("memisc")
library(GGally)
library(ggplot2)
library(scales)
library(memisc)
library(lattice)
library(MASS)
library(car)
library(reshape)
library(plyr)
library(gridExtra)
setwd('C:/git/UdacityDataAnalystNanoDegree/R/data')
data(diamonds)


ggplot(diamonds, aes(x=carat, y = price)) + 
  scale_x_continuous(lim = c(0, quantile(diamonds$carat,0.99))) +
  scale_y_continuous(lim = c(0, quantile(diamonds$price,0.99))) + 
  geom_point(fill=I('#F79420'), color = I('black'), shape = 21)


ggplot(diamonds, aes(x=carat, y = price)) + 
  geom_point(color = I('#F79420'), alpha = 1/4) +
  scale_x_continuous(lim = c(0, quantile(diamonds$carat,0.99))) +
  scale_y_continuous(lim = c(0, quantile(diamonds$price,0.99))) + 
  stat_smooth(method = 'lm')


set.seed(20022012)

diamond_samp <- diamonds[sample(1:length(diamonds$price),1000),]
#ggpairs(diamond_samp, params = c(shape = I('.'), outlier.shape = I('.')))

#The Demand of Diamonds

plot1 <- qplot (data=diamonds, x=price, binwidth = 100, fill = I('#099DD9')) + ggtitle("Price")
plot2 <- qplot (data=diamonds, x=price, binwidth = 0.01, fill = I('#f79420')) + ggtitle("Price (log10)") + scale_x_log10()
grid.arrange(plot1, plot2, ncol=2)


#Scatterplot Transformation
qplot(carat, price, data = diamonds) +
  scale_y_continuous(trans = log10_trans()) +
  ggtitle('Price (log10) by carat')

cuberoot_trans = function() trans_new('cuberoot',
                                      transform = function(x)  x^(1/3),
                                      inverse = function (x) x^3)


ggplot(aes(carat, price), data= diamonds) + 
  geom_point() +
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2,3), breaks = c(0.2, 0.5,1,2,3)) +
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000), breaks = c(350, 1000, 5000, 10000, 15000)) +  
  ggtitle('Price (log10) by Cube-Root of Carat')


head(sort(table(diamonds$carat), decreasing = T))
head(sort(table(diamonds$price), decreasing = T))

ggplot(aes(carat, price), data = diamonds) + 
  geom_point(alpha = 0.5, size = 0.75, position= 'jitter') + 
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3),
                     breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000),
                     breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat')




ggplot(aes(x = carat, y = price, colour=clarity), data = diamonds) + 
  geom_point(alpha = 0.5, size = 1, position = 'jitter') +
  scale_color_brewer(type = 'div', guide = guide_legend(title = 'Clarity', reverse = T, override.aes = list(alpha = 1, size = 2))) +  
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3), breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000), breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat and Clarity')



ggplot(aes(x = carat, y = price, colour=cut), data = diamonds) + 
  geom_point(alpha = 0.5, size = 1, position = 'jitter') +
  scale_color_brewer(type = 'div', guide = guide_legend(title = 'Cut', reverse = T, override.aes = list(alpha = 1, size = 2))) +  
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3), breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000), breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat and Cut')



ggplot(aes(x = carat, y = price, colour=color), data = diamonds) + 
  geom_point(alpha = 0.5, size = 1, position = 'jitter') +
  scale_color_brewer(type = 'div', guide = guide_legend(title = 'Color', override.aes = list(alpha = 1, size = 2))) +  
  scale_x_continuous(trans = cuberoot_trans(), limits = c(0.2, 3), breaks = c(0.2, 0.5, 1, 2, 3)) + 
  scale_y_continuous(trans = log10_trans(), limits = c(350, 15000), breaks = c(350, 1000, 5000, 10000, 15000)) +
  ggtitle('Price (log10) by Cube-Root of Carat and Color')


#A Bigger, Better Data Set
load("BigDiamonds.rda")
diamondsbig$logprice = log (diamondsbig$price)


m1 <- lm(logprice ~ I(carat^(1/3)), data = diamondsbig[diamondsbig$price < 10000 & diamondsbig$cert =="GIA",])
m2 <-update(m1, ~ . + carat)
m3 <-update(m2, ~ . + cut)
m4 <-update(m3, ~ . + color)
m5 <-update(m4, ~ . + clarity)

mtable(m1, m2, m3, m4, m5)



thisDiamond <- data.frame(carat = 1.00, cut = "V.Good", color = "I", clarity="VS1")
modelEstimate = predict (m5, newdata = thisDiamond, interval = 'prediction', level = .95)
