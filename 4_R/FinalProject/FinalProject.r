#install.packages("sfsmisc")


setwd("C:/git/UdacityDataAnalystNanoDegree/4_R/FinalProject/")
df<-read.csv("wineQualityWhites.csv")

df$rating <- ifelse(df$quality <= 5, 'Bad', 
                    ifelse(df$quality <= 7, 'Average', 
                           ifelse(df$quality<=8,'Good', 
                                  'Excelent'
                           )
                    )
)

df$rating <- ordered(df$rating,levels = c('Bad', 'Average', 'Good', 'Excelent'))

df$quality <- as.factor(df$quality)

###########################################histogram
ggplot(data=df,aes(x=quality))+
  geom_bar(aes(y = (..count..)),fill="orange")+
  geom_text(aes(y = (..count..),label =   ifelse((..count..)==0,"",scales::percent((..count..)/sum(..count..)))), stat="bin",colour="darkgreen")

#names(df)


##########################################multiple box plots

#head(df)
library(plyr)
library(dplyr)
library(sfsmisc)
library(reshape2 )
library(ggplot2)
library(gridExtra)
library(sfsmisc)

melt_data <- melt(df,id.vars=c("X","quality"))
head(melt_data)


plots <- dlply(melt_data,.(variable),function(chunk)
{
  ggplot(data=chunk, aes(x=factor(quality), y = value)) + geom_boxplot()+  stat_summary(fun.y=mean,geom = 'point', shape = 4) +  labs(y=unique(chunk$variable))
})

do.call(grid.arrange,c(plots,ncol=2))

df<- df[!df$X == 2782, ]


##########################################multiple GRIDS
plots <- dlply(melt_data,.(variable),function(chunk)
{
  ggplot(data= chunk) +  aes(x = factor(quality), y = value)+
    stat_summary(aes(fill = factor(quality)), fun.y=mean, geom="bar")+
    stat_summary(aes(label=round(..y..,4)), fun.y=mean, geom="text", size=6, vjust = 1)  +  
    labs(y=unique(chunk$variable)) + theme(legend.position="none") +
    geom_smooth(method = "lm", se=FALSE, color="black", type='dotted', aes(group=1), size =1,lty = 2)
    
})
do.call(grid.arrange,c(plots,ncol=2))

# ggplot(data= subset(df, X != 775)) +  aes(x = factor(quality), y = fixed.acidity)+
#   stat_summary(aes(fill = factor(quality)), fun.y=mean, geom="bar")+
#   stat_summary(aes(label=round(..y..,4)), fun.y=mean, geom="text", size=6, vjust = 1)  +  
#   labs(y=unique(df$variable)) + theme(legend.position="none") +
#   geom_smooth(method = "lm", se=F,aes(group=1), color="black", size =1,lty = 2)



head(df)
#remove index
df[,c("X")] <- list(NULL)




fit_model <- function(variable, data, name)
{
  model.lm <- lm(variable ~ quality, data = data) #run the regression
  s<-summary(model.lm)
  x<-as.data.frame(round(s$coefficients[,1],4)) #get the coeficients from the summary
  names(x) <- name # name the column
  rsq <- round(summary(model.lm)$r.squared,4) #get r-squared
  x<-rbind(x,rsq)  #and add it to the data frame
  rownames(x)[8] <-"r-squared"  #name the row
  x
}

grid <- NULL
i = 1
for(n in names(df))
{  
  if (n != 'quality') {
    if (is.null(grid)){
      grid<-fit_model(df[,i], df, n)
    } else {
      grid<-cbind(grid,fit_model(df[,i], df, n) )
    }
    i = i+1  
  }
}

grid



---



#---------------------------------------------------------------


#corrs?
a<-cor(select(df, -quality))
write.csv(a, "a.csv")
pairs(select(df, -quality))

#plotting the 99th percentile to remove one big outlier

lesscorrelated<- ggplot(aes(x = free.sulfur.dioxide, y = pH), data=df) + 
                  geom_point()+
                  geom_smooth(method = 'auto', color = 'red')+
                  xlim(0, quantile(df$free.sulfur.dioxide,0.99)) 
  

morecorrelated<- ggplot(aes(x = residual.sugar, y = density), data=df) + 
                geom_point()+ geom_smooth(, color = 'red') +
                xlim(0, quantile(df$residual.sugar,0.99)) 

grid.arrange(lesscorrelated, morecorrelated, ncol=2)




--------------------

#alcohol and residual.sugar: -0.459462363
#alcohol and chlorides: -0.360538622
#alcohol and total.sulfur.dioxide: -0.449046773
#alcohol and density: -0.801887063

p1<-ggplot(aes(x =  log10(alcohol), y =log10(residual.sugar) ), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'red')

p2<-ggplot(aes(x =  log10(alcohol), y =log10(chlorides) ), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'blue')  

p3<-ggplot(aes(x =  log10(alcohol), y =log10(density) ), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'orange')  

p4<-ggplot(aes(x =  log10(alcohol), y =log10(total.sulfur.dioxide) ), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'violet')  

grid.arrange(p1,p2,p3,p4, ncol=2)
  
  

#total.sulfur.dioxide and residual.sugar: 0.405959945
#total.sulfur.dioxide and free.sulfur.dioxide: 0.615846431
#total.sulfur.dioxide and density: 0.540959086
#total.sulfur.dioxide and alcohol: -0.449046773

  
p1<-ggplot(aes(x =  log10(total.sulfur.dioxide), y =log10(residual.sugar) ), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'red')

p2<-ggplot(aes(x =  log10(total.sulfur.dioxide), y =log10(free.sulfur.dioxide) ), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'blue')  

p3<-ggplot(aes(x =  log10(total.sulfur.dioxide), y =log10(density) ), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'violet')  

p4<-ggplot(aes(x =  log10(total.sulfur.dioxide), y =log10(alcohol) ), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'orange')  

grid.arrange(p1,p2,p3,p4, ncol=2)


density and residual.sugar: 0.833969102
ggplot(aes(x =  log10(residual.sugar), y = log10(density)), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'red')  



pH and fixed.acidity:  -0.426296256
ggplot(aes(x =  log10(pH), y = log10(fixed.acidity)), data=df) + 
  geom_point() +
  geom_smooth(method = 'auto', color = 'red')  











#3 varialbe analisys



summary(df$density)
ggplot(data = df, aes(x = density , y = residual.sugar)) +
  facet_wrap(~rating) +
  xlim(0.9871, 1) +
  geom_point( color = df$quality)




ggplot(data = df,
       aes(x = citric.acid, y = volatile.acidity)) +
  geom_point(aes(color = factor(quality))) +
  facet_wrap(~rating) 



#Multivariate Plots Section
#alcohol, total.sulfur.dioxide, residual.sugar , density



#Lets combine all these 4 varialbes in 6 plots
#we can see bins
p1<-ggplot(data = subset(df, rating != 'Average'), aes(x = alcohol, y = total.sulfur.dioxide,color = rating)) +  geom_point()
p2<-ggplot(data = subset(df, rating != 'Average'), aes(x = alcohol, y = residual.sugar,color = rating)) +  geom_point() + ylim (0,40)
p3<-ggplot(data = subset(df, rating != 'Average'), aes(x = alcohol, y = density,color = rating)) +  geom_point()
p4<-ggplot(data = subset(df, rating != 'Average'), aes(x = total.sulfur.dioxide, y = residual.sugar,color = rating)) +  geom_point()
p5<-ggplot(data = subset(df, rating != 'Average'), aes(x = total.sulfur.dioxide, y = density,color = rating)) +  geom_point()
p6<-ggplot(data = subset(df, rating != 'Average'), aes(x = residual.sugar, y = density,color = rating)) +  geom_point()
grid.arrange(p1,p2,p3,p4,p5,p6,ncol=3)


cor.test(df$alcohol, df$quality)






#melhor esses buckets
df$alcohol.bucket <- cut(df$alcohol, c(0, 9.5, 10.4, 10.51, 11.4, 15))
df$total.sulfur.dioxide.bucket <- cut(df$total.sulfur.dioxide, c(0,108,134,138.4,167,440))



ggplot(aes(y = residual.sugar, x = alcohol), data = df) +
  geom_point(alpha = 1/2) +
  facet_wrap(~total.sulfur.dioxide.bucket) +
  geom_smooth(method = 'loess', formula = y ~ x, size = 0.5) 








ggplot(aes(x = alcohol, y = total.sulfur.dioxide , color = rating), data = df)        + geom_point() 
ggplot(aes(x = alcohol, y = residual.sugar , color = rating), data =  df)             + geom_point()   + ylim (0,40) 
ggplot(aes(x = alcohol, y = density , color = rating), data = df)                     + geom_point() 
ggplot(aes(x = total.sulfur.dioxide, y = residual.sugar , color = rating), data = df) + geom_point() 
ggplot(aes(x = total.sulfur.dioxide, y = density , color = rating), data = df)        + geom_point() 
ggplot(aes(x = residual.sugar, y = density , color = rating), data = df)              + geom_point() 







summary(df$total.sulfur.dioxide)

ggplot(df,aes(x=quality,y=volatile.acidity,))+
  geom_line(stat='summary',fun.y=mean,color="#990000",size=1.2)+
  geom_line(stat='summary',fun.y=quantile,prob=0.25,linetype=2,color="#990000",size=1)+
  geom_line(stat='summary',fun.y=quantile,prob=0.75,linetype=2,color="#990000",size=1)+
  geom_line(stat='summary',fun.y=quantile,prob=0.1,linetype=3,color="#990000")+
  geom_line(stat='summary',fun.y=quantile,prob=0.9,linetype=3,color="#990000")



ggplot(aes(y = free.sulfur.dioxide, x = total.sulfur.dioxide, color = quality), data = df) +
  geom_point(alpha = 1/2) +
  coord_cartesian(xlim = c(0,300), ylim = c(0,150)) 
  #scale_colour_gradientn(colours=c("white", "dodgerblue")) +
  #theme(panel.background = element_rect(fill = '#FFB606', colour = 'black')) +
  #ggtitle("Fig. 28a")


ggplot(aes(y = free.sulfur.dioxide, x = total.sulfur.dioxide, 
           color = pH.bucket), data = df) +
  geom_point(alpha = 1/2) +
  coord_cartesian(xlim = c(0,300), ylim = c(0,150)) +
  scale_color_brewer(palette = "Blues", "Binned pH") +
  theme(panel.background = element_rect(fill = '#FFB606', colour = 'black')) +
  ggtitle("Fig. 28b")











