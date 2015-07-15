##################################################################feature selection
#http://machinelearningmastery.com/feature-selection-with-the-caret-r-package/
#http://stats.stackexchange.com/questions/56092/feature-selection-packages-in-r
1)
head(df[,1:11])
correlationMatrix <- cor(df[,1:11])
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.8, verbose = FALSE)
print (highlyCorrelated)
#8 - remove denstity
#head(df[,7:8])  #total.sulfur.dioxide density

library(mlbench)
library(caret)

----------------
# c <- trainControl(method="repeatedcv", number=10, repeats=3)
# m <- train(diabetes~., data=PimaIndiansDiabetes, method="lvq", preProcess="scale", trControl=c)
# i <- varImp(m, scale=FALSE)
# print(i)
# plot(i)


2)
control <- trainControl(method="repeatedcv", number=10, repeats=3)
# train the model
model <- train(quality~., data=df, method="lvq", preProcess="scale", trControl=control)
# estimate variable importance
importance <- varImp(model, scale=FALSE)
# summarize importance
print(importance)
# plot importance
plot(importance)

# as.data.frame(importance)
# i <- as.data.frame(importance$importance)


------------------------
3)
head(df[,1:11])
# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
results <- rfe(df[,1:11], df[,12], rfeControl=control)
# summarize the results
print(results)

# plot the results
plot(results, type=c("g", "o"))







