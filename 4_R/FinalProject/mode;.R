setwd('C:\\git\\UdacityDataAnalystNanoDegree\\6_D3js\\FinalProject2')


d <- read.csv("train.csv")


head(d)
d["PassengerId"] <-  list(NULL)
d["Name"] <-  list(NULL)
d["Ticket"] <-  list(NULL)
d["Cabin"] <-  list(NULL)
d["Fare"] <-  list(NULL)

d$family = d$SibSp + d$Parch
d$Pclass <- factor(d$Pclass)

d["Age"] <-  list(NULL)
head(d)

library(rpart)
library(rpart.plot)

fit  <- rpart(Survived ~ ., method="class", data=d)



cols <- ifelse(fit$frame$yval == 1, "red", "green4")

prp(fit,     
    digits=6,
    extra=1,             
    branch=.5,           
    faclen=0,            
    shadow.col="gray",   
    branch.lty=3,        
    split.cex=1.2,       
    split.prefix="is ",  
    split.suffix="?",    
    col=cols, border.col=cols,
    split.box.col="lightgray",
    split.border.col="darkgray"
)  


newd <-subset (d, !( d$Sex=="female" & (Pclass==2 | Pclass==1)))



fit2  <- rpart(Survived ~ ., method="class", data=newd)



cols <- ifelse(fit2$frame$yval == 1, "red", "green4")

prp(fit2,     
    digits=6,
    extra=1,             
    branch=.5,           
    faclen=0,            
    shadow.col="gray",   
    branch.lty=3,        
    split.cex=1.2,       
    split.prefix="is ",  
    split.suffix="?",    
    col=cols, border.col=cols,
    split.box.col="lightgray",
    split.border.col="darkgray"
)  



dmales <- read.csv("train.csv")


head(dmales)
dmales["PassengerId"] <-  list(NULL)
dmales["Name"] <-  list(NULL)
dmales["Ticket"] <-  list(NULL)
dmales["Cabin"] <-  list(NULL)
dmales["Fare"] <-  round(dmales["Fare"])

dmales$family = d$SibSp + d$Parch
dmales$Pclass <- factor(d$Pclass)

dmales["Age"] <-  list(NULL)
head(dmales)





dmales <-subset (dmales, ( dmales$Sex=="male"))
nrow(dmales)




fit3  <- rpart(Survived ~ ., method="class", data=dmales)



cols <- ifelse(fit3$frame$yval == 1, "red", "green4")

prp(fit3,     
    digits=6,
    extra=1,             
    branch=.5,           
    faclen=0,            
    shadow.col="gray",   
    branch.lty=3,        
    split.cex=1.2,       
    split.prefix="is ",  
    split.suffix="?",    
    col=cols, border.col=cols,
    split.box.col="lightgray",
    split.border.col="darkgray"
)  

