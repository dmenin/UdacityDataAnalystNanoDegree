#library("party")
#?ctree

control<-ctree_control(teststat = c("quad", "max"), 
              testtype = c("Teststatistic"), 
              mincriterion = 0.95, minsplit = 2, minbucket =2 , 
              stump = FALSE, maxsurrogate = 3, 
              mtry = 0, savesplitstats = TRUE, maxdepth = 4)



fit  <- ctree(rating ~ alcohol + volatile.acidity + free.sulfur.dioxide + chlorides +  pH, data=df2, controls = control)
#plot(fit, type= 'simple')
#?ctree_control
airct<- fit
plot(airct,           # no terminal plots

     inner_panel=node_inner(airct,
                            pval = FALSE, 
                            abbreviate = FALSE, 
                            id = FALSE)

     
     #,terminal_panel = node_boxplot(airct, col = "blue")     

)



install.packages("rattle")
library(rpart)
library(rattle)  

library(rpart.plot)



# plot(fit)
# text(fit)
# plot(fit, main="Conditional Inference Tree for Kyphosis")
# prp(fit)  				# Will plot the tree
# prp(fit,varlen=3)				# Shorten variable names
# fancyRpartPlot(fit)  			# A fancy plot from rattle
# 
?rpart.control

?prp

c<-rpart.control(minsplit = 20, minbucket = 7, cp = 0.01, 
                  usesurrogate = 2, xval = 10,
                 surrogatestyle = 0, maxdepth = 30)

#fit  <- rpart(rating ~ alcohol + volatile.acidity + free.sulfur.dioxide + chlorides +  pH, data=df2, control=c)

#df[,c("quality")] <- list(NULL)

table(df2$rating)
df2$rating <- ordered(df2$rating,levels = c('Bad', 'Good'))

fit  <- rpart(rating ~ ., data=df2, control=c)

cols <- ifelse(fit$frame$yval == 1, "darkred", "green4")

prp(fit, main="Decision Tree on Wine Quality",
    extra=1,             #  the probability of the fitted class.
    branch=.5,           # change angle of branch lines
    faclen=0,            # do not abbreviate factor levels
    shadow.col="gray",   # shadows under the leaves
    branch.lty=3,        # draw branches using dotted lines    
    split.cex=1.2,       # make the split text larger than the node text
    split.prefix="is ",  # put "is " before split text
    split.suffix="?",    # put "?" after split text
    
    col=cols, border.col=cols,   # green if Good
    split.box.col="lightgray",   # lightgray split boxes (default is white)
    split.border.col="darkgray", # darkgray border on split boxes
    split.round=.5)  