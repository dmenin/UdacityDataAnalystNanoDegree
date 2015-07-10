install.packages("sfsmisc")
library(sfsmisc)

setwd("C:/git/UdacityDataAnalystNanoDegree/4_R/FinalProject/")
df<-read.csv("wineQualityWhites.csv")
#remove index
df[,c("X")] <- list(NULL)
df$quality <- as.factor(df$quality)
head(df)

#histogram
ggplot(data=df,aes(x=quality))+
  geom_bar(aes(y = (..count..)),fill="orange")+
  geom_text(aes(y = (..count..),label =   ifelse((..count..)==0,"",scales::percent((..count..)/sum(..count..)))), stat="bin",colour="darkgreen")

names(df)

p1<- ggplot(aes(x=quality, y = alcohol), data = df) + geom_boxplot()+  stat_summary(fun.y=mean,geom = 'point', shape = 4)
p2<- ggplot(aes(x=quality, y = density), data = df) + geom_boxplot()+  stat_summary(fun.y=mean,geom = 'point', shape = 4)
grid.arrange(p1,p2, ncol=1)


ggplot(aes(x=quality, y = density), data = df) + geom_boxplot()+  stat_summary(fun.y=mean,geom = 'point', shape = 4)







library(dplyr)
select(df, -quality)


cor(select(df, -quality))
pairs(select(df, -quality))





#http://stats.stackexchange.com/questions/119835/correlation-between-a-nominal-iv-and-a-continuous-dv-variable/124618#124618
data.df <- data.frame(
  topic = c(rep(c("Gossip", "Sports", "Weather"), each = 4)),
  duration  = c(6:9, 2:5, 4:7)
)
print(data.df)
boxplot(duration ~ topic, data = data.df, ylab = "Duration of conversation")

model.lm <- lm(duration ~ topic, data = data.df)
summary(model.lm)


model.aov <- aov(alcohol ~ quality, data = df)





data <- data.frame(id=1:500, quality=sample(3:10,replace=TRUE,size=500))

for(i in 1:9){
  data[,paste0("outcome_",i)]<-rnorm(500)
}

library(dplyr)
library(ggplot2)
library(gridExtra)

library(reshape2 )
melt_data <- melt(data,id.vars=c("id","quality"))
head(melt_data)


plots <- dlply(melt_data,.(variable),function(chunk)
    {
      ggplot(data=chunk, aes(x=factor(quality), y = value)) + geom_boxplot()+  stat_summary(fun.y=mean,geom = 'point', shape = 4) +  labs(y=unique(chunk$variable)
    )
})


do.call(grid.arrange,c(plots,ncol=2))