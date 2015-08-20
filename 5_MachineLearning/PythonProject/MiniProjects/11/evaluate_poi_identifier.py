#!/usr/bin/python


"""
    starter code for the evaluation mini-project
    start by copying your trained/tested POI identifier from
    that you built in the validation mini-project

    the second step toward building your POI identifier!

    start by loading/formatting the data

"""

import pickle
import sys
sys.path.append("../tools/")
from MiniProjects.tools.feature_format  import featureFormat, targetFeatureSplit

data_dict = pickle.load(open("../../Data/final_project_dataset.pkl", "r") )
### add more features to features_list!
features_list = ["poi", "salary"]

data = featureFormat(data_dict, features_list)
labels, features = targetFeatureSplit(data)




from sklearn import tree
clf = tree.DecisionTreeClassifier()

from sklearn.cross_validation import train_test_split
features_train, features_test, labels_train, labels_test = train_test_split(features,labels, test_size=0.30, random_state=42)

from sklearn.metrics import accuracy_score
clf.fit(features_train, labels_train)
pred = clf.predict(features_test)
accuracy = accuracy_score(pred, labels_test)
print labels_test
print pred


from sklearn.metrics import precision_score
print precision_score(labels_test, pred, average='binary')
from sklearn.metrics import recall_score
print recall_score(labels_test, pred, average='binary')