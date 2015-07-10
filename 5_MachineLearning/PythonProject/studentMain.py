"""
    The objective of this exercise is to recreate the decision 
    boundary found in the lesson video, and make a plot that
    visually shows the decision boundary """
#import numpy as np
#import pylab as pl


from prep_terrain_data import makeTerrainData
from class_vis import prettyPicture, output_image

def classifyNB(features_train, labels_train):
    from sklearn.naive_bayes import GaussianNB
    clf = GaussianNB()
    return clf.fit(features_train, labels_train)

def classifySVM(features_train, labels_train):
    from sklearn import svm
    clf = svm.SVC(kernel='rbf', C=10000)
    return clf.fit(features_train, labels_train)

def classifyDT(features_train, labels_train):

    from sklearn import tree
    clf = tree.DecisionTreeClassifier()
    clf = clf.fit(features_train, labels_train)
    return clf



features_train, labels_train, features_test, labels_test = makeTerrainData()

### the training data (features_train, labels_train) have both "fast" and "slow" points mixed
### in together--separate them so we can give them different colors in the scatterplot,
### and visually identify them
grade_fast = [features_train[ii][0] for ii in range(0, len(features_train)) if labels_train[ii]==0]
bumpy_fast = [features_train[ii][1]  for ii in range(0, len(features_train)) if labels_train[ii]==0]
grade_slow = [features_train[ii][0] for ii in range(0, len(features_train)) if labels_train[ii]==1]
bumpy_slow = [features_train[ii][1] for ii in range(0, len(features_train)) if labels_train[ii]==1]


#clf = classifyNB(features_train, labels_train)
clf = classifyDT(features_train, labels_train)

prettyPicture(clf, features_test, labels_test)
output_image("test.png", "png", open("test.png", "rb").read())




