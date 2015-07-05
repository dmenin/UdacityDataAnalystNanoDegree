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
