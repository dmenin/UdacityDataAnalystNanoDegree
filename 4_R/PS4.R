install.packages("gridExtra")
diamonds
names(diamonds)
#price vs. x
ggplot(aes(x=x, y=price), data=diamonds) + geom_point()


cor(diamonds$price, diamonds$x)
cor(diamonds$price, diamonds$y)
cor(diamonds$price, diamonds$z)


# price vs. depth
ggplot(aes(x=depth, y=price), data=diamonds) + geom_point(alpha=1/100) + scale_x_continuous(breaks=seq(40,80,2))

cor(diamonds$price, diamonds$depth)





#price vs. carat
ggplot(aes(x=carat, y=price), data=diamonds) + geom_point()

ggplot(aes(x=carat, y=price), data=subset (diamonds, carat<=quantile(carat,0.99) & price<=quantile(price,0.99))) + geom_point()

# price vs. volume
diamonds$volume <- with(diamonds, x*y*z)
ggplot(aes(x=volume, y=price), data=diamonds) + geom_point()



# Adjustments - price vs. volume
ggplot(aes(x=volume, y=price), data=subset(diamonds, volume>0 & volume<800)) + geom_point(alpha = 0.01) +geom_smooth(method = "lm")

# Mean Price by Clarity
head(diamonds) 
diamondsByClarity <- diamonds %>% 
                      group_by(clarity) %>% 
                      summarise(mean_price = mean(price),
                                median_price = median(price) *1,
                                min_price = min(price),        
                                max_price = max(price),                                
                                n = n()) %>% 
                      arrange(clarity)

#Bar Charts of Mean Price

diamonds_by_clarity <- group_by(diamonds, clarity)
diamonds_mp_by_clarity <- summarise(diamonds_by_clarity, mean_price = mean(price))

diamonds_by_color <- group_by(diamonds, color)
diamonds_mp_by_color <- summarise(diamonds_by_color, mean_price = mean(price))

library(gridExtra)
p1 <- ggplot(aes(x = clarity, y = mean_price), data = diamonds_mp_by_clarity) +  geom_bar(stat = "identity")
p2 <- ggplot(aes(x = color, y = mean_price), data = diamonds_mp_by_color) +  geom_bar(stat = "identity")

grid.arrange(p1,p2)