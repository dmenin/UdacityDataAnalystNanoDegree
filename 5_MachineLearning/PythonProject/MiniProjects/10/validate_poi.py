#!/usr/bin/python


"""
    starter code for the validation mini-project
    the first step toward building your POI identifier!

    start by loading/formatting the data

    after that, it's not our code anymore--it's yours!
"""

import pickle
import sys
#sys.path.append("../tools/")
from MiniProjects.tools.feature_format  import featureFormat, targetFeatureSplit

data_dict = pickle.load(open("../../Data/final_project_dataset.pkl", "r") )

### first element is our labels, any added elements are predictor
### features. Keep this the same for the mini-project, but you'll
### have a different feature list when you do the final project.
features_list = ["poi", "salary"]

data = featureFormat(data_dict, features_list)
labels, features = targetFeatureSplit(data)

#print data[1:5,]
#print labels[1:5]
#print features[1:5]

from sklearn import tree
clf = tree.DecisionTreeClassifier()

from sklearn.cross_validation import train_test_split
features_train, features_test, labels_train, labels_test = train_test_split(features,labels, test_size=0.30, random_state=42)


from sklearn.metrics import accuracy_score
clf.fit(features, labels)
pred = clf.predict(features)
accuracy = accuracy_score(pred, labels)
print 'bad Accuracy:', accuracy


clf.fit(features_train, labels_train)
pred = clf.predict(features_test)
accuracy = accuracy_score(pred, labels_test)
print accuracy
