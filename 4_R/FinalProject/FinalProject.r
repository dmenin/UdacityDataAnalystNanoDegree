#install.packages("RColorBrewer")
#install.packages("sfsmisc")
#install.packages ("corrplot")
library (corrplot)

setwd("C:/git/UdacityDataAnalystNanoDegree/4_R/FinalProject/")
df<-read.csv("wineQualityWhites.csv")

df$rating <- ifelse(df$quality <= 5, 'Bad', 
                    ifelse(df$quality <= 7, 'Average', 
                           ifelse(df$quality<=8,'Good', 
                                  'Excellent'
                           )
                    )
)

df$rating <- ordered(df$rating,levels = c('Bad', 'Average', 'Good', 'Excellent'))

df$quality <- as.factor(df$quality)

###########################################histogram
ggplot(data=df,aes(x=quality))+
  geom_bar(aes(y = (..count..)),fill="orange")+
  geom_text(aes(y = (..count..),label =   ifelse((..count..)==0,"",scales::percent((..count..)/sum(..count..)))), stat="bin",colour="darkgreen")

#names(df)


##########################################multiple box plots
?findCorrelation
#head(df)
library(plyr)
library(dplyr)
library(sfsmisc)
library(reshape2 )
library(ggplot2)
library(gridExtra)
library(sfsmisc)
library (corrplot)

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

w.matrix <- head(df)[2:13])

mcor <- cor(w.matrix)

mcor <-round(mcor, digits=2)

?corrplot
corrplot(a, method="shade",
         shade.col=NA, 
         tl.col="black", 
         tl.srt=45)



a<-cor(select(df, -quality))
a2 <-round(a, digits=2)
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









library(plyr)
library(dplyr)
library(sfsmisc)
library(reshape2 )
library(ggplot2)
library(gridExtra)
library (corrplot)
library(caret)
library(RColorBrewer)
library(tree)

df<-read.csv("wineQualityWhites.csv")
df$rating <- ifelse(df$quality <= 5, 'Bad', 
                    ifelse(df$quality <= 7, 'Average', 
                           ifelse(df$quality<=8,'Good', 
                                  'Excellent'
                           )
                    )
)

df$rating <- ordered(df$rating,levels = c('Bad', 'Average', 'Good', 'Excellent'))





df<- df[!df$X == 2782, ]
df[,c("X")] <- list(NULL)

df$quality <- as.factor(df$quality)

#3 varialbe analisys
#alcohol, volatile.acidity, free.sulfur.dioxide, chlorides, pH
df2 <- subset(df, rating != 'Average')
df2[df2$rating == 'Excellent',]$rating <- 'Good'

p1<-ggplot(data = df2, aes(x = alcohol, y = volatile.acidity,color = rating)) +  geom_point() 
p2<-ggplot(data = df2, aes(x = alcohol, y = free.sulfur.dioxide,color = rating)) +  geom_point()  
p3<-ggplot(data = df2, aes(x = alcohol, y = chlorides,color = rating)) +  geom_point()  
p4<-ggplot(data = df2, aes(x = alcohol, y = pH,color = rating)) +  geom_point()  

p5<-ggplot(data = df2, aes(x = volatile.acidity, y = free.sulfur.dioxide, color = rating)) +  geom_point() 
p6<-ggplot(data = df2, aes(x = volatile.acidity, y = chlorides, color = rating)) +  geom_point()
p7<-ggplot(data = df2, aes(x = volatile.acidity, y = pH, color = rating)) +  geom_point()



p8<-ggplot(data = df2, aes(x = free.sulfur.dioxide, y = chlorides, color = rating)) +  geom_point()
p9<-ggplot(data = df2, aes(x = free.sulfur.dioxide, y = pH, color = rating)) +  geom_point()


p10<-ggplot(data = df2, aes(x = chlorides, y = pH, color = rating)) +  geom_point()

grid.arrange(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,ncol=2)




df2$pHbucket <- cut(df2$pH, c(2.7, 3.0, 3.3, 3.6, 3.9))
summary(df2$volatile.acidity)

#tried to analise the variables by pH bucket. no relahsionship found
# df2$pHbucket <- cut(df2$pH, c(2.7, 3.0, 3.3, 3.6, 3.9))
# ggplot(aes(y = alcohol, x = volatile.acidity, color = pHbucket), data = df2) + geom_point() + facet_wrap(~rating)
# ggplot(aes(y = alcohol, x = free.sulfur.dioxide, color = pHbucket), data = df2) + geom_point()+ facet_wrap(~rating)
# ggplot(aes(y = alcohol, x = chlorides, color = pHbucket), data = df2) + geom_point()+ facet_wrap(~rating)
# 
# ggplot(aes(y = volatile.acidity, x =  free.sulfur.dioxide, color = pHbucket), data = df2) + geom_point() + facet_wrap(~rating)
# ggplot(aes(y = volatile.acidity, x = chlorides, color = pHbucket), data = df2) + geom_point() + facet_wrap(~rating)
# 
# 
# ggplot(aes(y = free.sulfur.dioxide, x = chlorides, color = pHbucket), data = df2) + geom_point() +xlim(c(0,0.2)) + facet_wrap(~rating)



#alcohol, volatile.acidity, free.sulfur.dioxide, chlorides, pH

df2$volatilebucket <- cut(df2$volatile.acidity, c(0.1, 0.4, 0.7, 1.1))
ggplot(aes(y = alcohol, x = free.sulfur.dioxide, color = volatilebucket), data = df2) + geom_point()+ facet_wrap(~rating)
ggplot(aes(y = alcohol, x = chlorides, color = volatilebucket), data = df2) + geom_point()+ facet_wrap(~rating)
ggplot(aes(y = alcohol, x = pH, color = volatilebucket), data = df2) + geom_point() + facet_wrap(~rating)

ggplot(aes(y = volatile.acidity, x =  free.sulfur.dioxide, color = volatilebucket), data = df2) + geom_point() + facet_wrap(~rating)
ggplot(aes(y = volatile.acidity, x = chlorides, color = volatilebucket), data = df2) + geom_point() + facet_wrap(~rating)
 
ggplot(aes(y = free.sulfur.dioxide, x = chlorides, color = volatilebucket), data = df2) + geom_point() +xlim(c(0,0.2)) + facet_wrap(~rating)



df$alcoholbucket <- cut(df$alcohol, c(8, 10, 12, 14.2))
df$pHbucket <- cut(df$pH, c(2.7, 3.0, 3.3, 3.6, 3.9))
df$free.sulfur.dioxidebucket <- cut(df$free.sulfur.dioxide, c(2, 23, 34, 46, 289))

ggplot(aes(x = density, y = residual.sugar, color = alcoholbucket), data = df) +
  geom_point() +
  geom_smooth(aes(group = 1), method = 'loess', formula = y ~ x, size = 0.5) +
  ggtitle("Relashionship between Density and Residual Sugar Colored By amount of alcohol") +
  theme(plot.title = element_text(face = "bold")) +
  xlim(c(0.9871, 1.001)) +
  xlab("Density (g / cm^3)") +  
  ylim(c(0.6, 25)) +  
  ylab("Residual Sugar (g / dm^3)") +
  scale_color_brewer(palette = "Set2", name = "Alcohol Bucket (% by volume)")

summary(df$residual.sugar)
summary(df$density)
summary(df$alcohol)
summary(df$free.sulfur.dioxide)
summary(df$volatile.acidity)



ggplot(df2, aes(alcohol,volatile.acidity)) +
  geom_point(aes(color=factor(rating))) + 
  stat_smooth(method = "lm", se=F, aes(color=factor(rating),group=rating), alpha=1) +
  ggtitle("Quality Trend Lines over volatile.acidity and alcohol for Good and Bad Wines")+
  theme(plot.title = element_text(face = "bold")) +
  xlab("Alcohol (% by volume)") +  
  ylab("Density (g / cm^3)") 





ggplot(df,aes(x=quality,y=volatile.acidity,))+
  theme(panel.background = element_blank(),
        legend.position="top",
        panel.grid.major = element_line(color='gray'))+
  xlab("Average Wine Rating")+
  ylab("Tartaric Acid Density (g/L)")+
  ggtitle("Fixed Acidity vs Average Rating for Red Wines")+
  geom_line(stat='summary',fun.y=mean,color="#990000",size=1.2)+
  geom_line(stat='summary',fun.y=quantile,prob=0.25,linetype=2,color="#990000",size=1)+
  geom_line(stat='summary',fun.y=quantile,prob=0.75,linetype=2,color="#990000",size=1)+
  geom_line(stat='summary',fun.y=quantile,prob=0.1,linetype=3,color="#990000")+
  geom_line(stat='summary',fun.y=quantile,prob=0.9,linetype=3,color="#990000")







ggplot(data = df,
       aes(x = citric.acid, y = volatile.acidity)) +
  geom_point(aes(color = factor(quality))) +
  facet_wrap(~rating, ncol=2) 

summary(df$pH)



#Lets combine all these 4 varialbes in 6 plots
#we can see bins



#alcohol, volatile.acidity, free.sulfur.dioxide
summary(df$alcohol)
df$alcoholbucket <- cut(df$alcohol, c(8, 9,10,11,12,13,14.2))

ggplot(aes(x = free.sulfur.dioxide, y = volatile.acidity,
           color = factor(alcoholbucket)), data = df) +
  geom_point() +
  xlim(c(0,150))
  



  
  
  geom_smooth(aes(group = 1), method = 'loess', formula = y ~ x, size = 0.5) +
  geom_hline(yintercept = 50, color="red", alpha = 1/2) +
  #coord_cartesian(xlim = c(0, 300), ylim = c(0, 100)) +
  ggtitle("Total SO2 to Free SO2 Colored By Residual Sugar") +
  theme(plot.title = element_text(face = "bold")) +
  scale_x_continuous("total sulfur dioxide (mg / dm^3^)") +
  scale_y_continuous("free sulfur dioxide (mg / dm^3^)") +
  scale_color_brewer(palette = "RdYlBu", name = "residual sugar interval\n(g/dm^3)")







p1<-ggplot(data = df2, aes(x = alcohol, y = volatile.acidity,color = rating)) +  geom_point() + 
  xlim(min(df$alcohol), quantile(df$alcohol, 0.95)) + ylim(min(df$volatile.acidity), quantile(df$volatile.acidity, 0.95)) 

p2<-ggplot(data = df2, aes(x = alcohol, y = free.sulfur.dioxide,color = rating)) +  geom_point()  +
  xlim(min(df$alcohol), quantile(df$alcohol, 0.95)) + ylim(min(df$free.sulfur.dioxide), quantile(df$free.sulfur.dioxide, 0.95)) 

p3<-ggplot(data = df2, aes(x = volatile.acidity, y = free.sulfur.dioxide, color = rating)) +  geom_point() + 
  xlim(min(df$volatile.acidity), quantile(df$volatile.acidity, 0.95)) + ylim(min(df$free.sulfur.dioxide), quantile(df$free.sulfur.dioxide, 0.95)) 
grid.arrange(p1,p2,p3,ncol=2)





ggplot(df,aes(free.sulfur.dioxide,fill=quality,alpha=0.1))+geom_density()+facet_wrap(~quality)


# p1<-ggplot(data = df2, aes(x = alcohol, y = total.sulfur.dioxide,color = rating)) +  geom_point()
# p2<-ggplot(data = df2, aes(x = alcohol, y = residual.sugar,color = rating)) +  geom_point() + ylim (0,40)
# p3<-ggplot(data = df2, aes(x = alcohol, y = density,color = rating)) +  geom_point()
# p4<-ggplot(data = df2, aes(x = total.sulfur.dioxide, y = residual.sugar,color = rating)) +  geom_point()
# p5<-ggplot(data = df2, aes(x = total.sulfur.dioxide, y = density,color = rating)) +  geom_point()
# p6<-ggplot(data = df2, aes(x = residual.sugar, y = density,color = rating)) +  geom_point()
# grid.arrange(p1,p2,p3,p4,p5,p6,ncol=2)



w2 <- 
  head(df)
  head(df[c(11,2,6,5,9)])#alcohol, volatile.acidity, free.sulfur.dioxide, chlorides, pH

pairs(df[c(11,2,6,5,9)],
      panel = panel.smooth,
      main = "Matrix of Variables with the Highest Correlation to Wine Quality",
     # diag.panel = panel.hist,
      pch = 16,
      col = brewer.pal(6, "Pastel2"))

#alcohol, volatile.acidity, free.sulfur.dioxide,












ggplot(df,aes(x=quality,y=volatile.acidity,))+
  geom_line(stat='summary',fun.y=mean,color="#990000",size=1.2)+
  geom_line(stat='summary',fun.y=quantile,prob=0.25,linetype=2,color="#990000",size=1)+
  geom_line(stat='summary',fun.y=quantile,prob=0.75,linetype=2,color="#990000",size=1)+
  geom_line(stat='summary',fun.y=quantile,prob=0.1,linetype=3,color="#990000")+
  geom_line(stat='summary',fun.y=quantile,prob=0.9,linetype=3,color="#990000")















