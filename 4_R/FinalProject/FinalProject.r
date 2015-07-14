install.packages("sfsmisc")
library(sfsmisc)

setwd("C:/git/UdacityDataAnalystNanoDegree/4_R/FinalProject/")
df<-read.csv("wineQualityWhites.csv")

df$quality <- as.factor(df$quality)
head(df)

###########################################histogram
ggplot(data=df,aes(x=quality))+
  geom_bar(aes(y = (..count..)),fill="orange")+
  geom_text(aes(y = (..count..),label =   ifelse((..count..)==0,"",scales::percent((..count..)/sum(..count..)))), stat="bin",colour="darkgreen")

#names(df)


##########################################multiple box plots
#head(df)
library(reshape2 )
library(dplyr)
library(ggplot2)
library(gridExtra)
library(plyr)
melt_data <- melt(df,id.vars=c("X","quality"))
head(melt_data)


plots <- dlply(melt_data,.(variable),function(chunk)
{
  ggplot(data=chunk, aes(x=factor(quality), y = value)) + geom_boxplot()+  stat_summary(fun.y=mean,geom = 'point', shape = 4) +  labs(y=unique(chunk$variable))
})

do.call(grid.arrange,c(plots,ncol=3))


##########################################multiple GRIDS
plots <- dlply(melt_data,.(variable),function(chunk)
{
  ggplot(data= chunk) +  aes(x = factor(quality), y = value)+
    stat_summary(aes(fill = factor(quality)), fun.y=mean, geom="bar")+
    stat_summary(aes(label=round(..y..,4)), fun.y=mean, geom="text", size=6, vjust = 1)  +  
    labs(y=unique(chunk$variable)) + theme(legend.position="none") +
    geom_smooth(method = "lm", se=FALSE, color="black", type='dotted', aes(group=1), size =1)
    
})
do.call(grid.arrange,c(plots,ncol=2))






head(df)
#remove index
df[,c("X")] <- list(NULL)



#corrs?
cor(select(df, -quality))
pairs(select(df, -quality))

cor(df$free.sulfur.dioxide, df$total.sulfur.dioxide)




ggplot(data= df) +  aes(x = factor(quality), y = fixed.acidity)+
  stat_summary(aes(fill = factor(quality)), fun.y=mean, geom="bar")+
  stat_summary(aes(label=round(..y..,2)), fun.y=mean, geom="text", size=6, vjust = -0.5)+
  geom_smooth(method = "lm", se=FALSE, color="black", aes(group=1), size =2)


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





