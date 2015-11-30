combi <- read.csv("train.csv")



combi$Embarked[c(62,830)] = "S"
combi$Embarked <- factor(combi$Embarked)

# Passenger on row 1044 has an NA Fare value. Let's replace it with the median fare value.
combi$Fare[1044] <- median(combi$Fare, na.rm=TRUE)

library("rpart")
library("rpart.plot")  
#library("rattle")
# How to fill in missing Age values?
# We make a prediction of a passengers Age using the other variables and a decision tree model. 
# This time you give method="anova" since you are predicting a continuous variable.

combi$family_size <- combi$SibSp + combi$Parch 

predicted_age <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked +  family_size,
                       data=combi[!is.na(combi$Age),], method="anova")
combi$Age[is.na(combi$Age)] <- predict(predicted_age, combi[is.na(combi$Age),])

train_new <- combi


# Find Cabin Class 
train_new$Cabin <- substr(train_new$Cabin,1,1)

train_new$Cabin <- factor(train_new$Cabin)




# train_new and test_new are available in the workspace
str(train_new)


# Create a new model `my_tree_five`
# Age - Cabin ???
my_tree <- rpart(Survived ~ Pclass + Sex +  Embarked +  family_size, data = train_new, method = "class", control=rpart.control(cp=0.0001))

# Visualize your new decision tree
#fancyRpartPlot(my_tree)
prp(my_tree, type = 4, extra = 100)






cols <- ifelse(fit$frame$yval == 1, "red", "green4")

prp(my_tree,     
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




