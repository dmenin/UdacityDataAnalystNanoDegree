#Price Histograms with Facet and Color
# Create a histogram of diamond prices.# Facet the histogram by diamond color # and use cut to color the histogram bars.

ggplot(aes(x = price, fill = cut), data=diamonds) + geom_histogram() + facet_wrap(~color) +
  scale_fill_brewer(type = 'qual')

# Price vs. Table Colored by Cut
# Create a scatterplot of diamond price vs.# table and color the points by the cut of# the diamond.
ggplot(aes(x = table, y = price, color = cut), data=diamonds) + geom_point() + scale_color_brewer(type = 'qual')


# Price vs. Volume and Diamond Clarity
# Create a scatterplot of diamond price vs.# volume (x * y * z) and color the points by
# the clarity of diamonds. Use scale on the y-axis # to take the log10 of price. 
#You should also# omit the top 1% of diamond volumes from the plot.

# price vs. volume
diamonds$volume <- with(diamonds, x*y*z)

#added  volume > 0
ggplot(aes(x=volume, y=price, color = clarity), data=subset(diamonds, volume > 0 & volume < quantile(diamonds$volume, 0.9))) +
  geom_point() +   scale_y_log10() + scale_color_brewer(type = 'div')


# Proportion of Friendships Initiated

setwd('C:/git/UdacityDataAnalystNanoDegree/R/data')
pf <- read.csv('pseudo_facebook.tsv', sep='\t')
pf$prop_initiated <- with (pf, friendships_initiated/ friend_count)


#prop_initiated vs. tenure
# Create a line graph of the median proportion of friendships initiated ('prop_initiated') vs.
# tenure and color the line segment by  year_joined.bucket.
pf$year_joined <- floor(2014 - pf$tenure/365)

pf$year_joined.bucket <- cut(pf$year_joined, breaks = c(2004, 2009, 2011, 2012, 2014))

ggplot(aes(x = tenure, y = prop_initiated),  data = subset(pf, !is.na(prop_initiated))) +
  geom_line(aes(color = year_joined.bucket), stat = 'summary', fun.y = median)



#Smoothing prop_initiated vs. tenure
# Smooth the last plot you created of
# of prop_initiated vs tenure colored by
# year_joined.bucket. You can use larger
# bins for tenure or add a smoother to the plot.


ggplot(aes(x = tenure, y = prop_initiated),  data = subset(pf, !is.na(prop_initiated))) +
  geom_line(aes(color = year_joined.bucket), stat = 'summary', fun.y = median) +geom_smooth()


ggplot(aes(x = tenure, y = prop_initiated),  data = subset(pf, !is.na(prop_initiated))) +
  geom_smooth(aes(color = year_joined.bucket))

#Largest Group Mean prop_initiated
summary(with(subset(pf, year_joined.bucket == "(2012,2014]"), prop_initiated))



#Price/Carat Binned, Faceted, & Colored
# Create a scatter plot of the price/carat ratio
# of diamonds. The variable x should be
# assigned to cut. The points should be colored
# by diamond color, and the plot should be
# faceted by clarity.

ggplot(aes(x = cut, y = price/carat, color = color), data = diamonds) + geom_jitter() + facet_wrap(~clarity) +
  scale_color_brewer(type = 'div')

