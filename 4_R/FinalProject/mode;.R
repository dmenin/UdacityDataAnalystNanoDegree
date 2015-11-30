setwd('C:\\git\\UdacityDataAnalystNanoDegree\\6_D3js\\FinalProject2')


d <- read.csv("data.csv")


head(d)
d["PassengerId"] <-  list(NULL)
d["Name"] <-  list(NULL)
d["Ticket"] <-  list(NULL)
d["Cabin"] <-  list(NULL)
d["Fare"] <-  list(NULL)

d$family = d$SibSp + d$Parch

library(rpart)
library(rpart.plot)

fit  <- rpart(Survived ~ ., method="class", data=d)



cols <- ifelse(fit$frame$yval == 0, "red", "green4")

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

printcp(fit)
plotcp(fit)

rsq.rpart(fit)  
print(fit)	
summary(fit)	
plot(fit)	


