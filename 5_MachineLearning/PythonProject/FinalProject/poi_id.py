#!/usr/bin/python

import sys
import pickle
import pprint
import pandas as pd
from tabulate import tabulate
from class_vis import prettyPicture, output_image

sys.path.append("../tools/")

from MiniProjects.tools.feature_format import featureFormat, targetFeatureSplit
from tester import test_classifier, dump_classifier_and_data

### Task 1: Select what features you'll use.
### features_list is a list of strings, each of which is a feature name.
### The first feature must be "poi".
#features_list = ['poi','salary'] # You will need to use more features

features_list = ['poi', 'bonus','deferral_payments','deferred_income','director_fees','exercised_stock_options',
                 'expenses', 'from_messages','loan_advances',
                 'long_term_incentive','other','restricted_stock','restricted_stock_deferred','salary',
                 'to_messages','total_payments', 'total_stock_value']
#removed 'email_address' feature
#removed: from_poi_to_this_person, from_this_person_to_poi, shared_receipt_with_poi

def pprint_df(df, n):
    print tabulate(df.head(n), headers='keys', tablefmt='psql', floatfmt=".1f")


### Load the dictionary containing the dataset
data_dict = pickle.load(open("final_project_dataset.pkl", "r") )

#print pprint.pprint(data_dict)


### Task 2: Remove outliers
### Task 3: Create new feature(s)

### Store to my_dataset for easy export below.
my_dataset = data_dict

### Extract features and labels from dataset for local testing
data = featureFormat(my_dataset, features_list, sort_keys = True)
#print data[0:2,]
df = pd.DataFrame(data, columns=features_list)
print ""
print ""
print ""


pprint_df(df,16)

labels = df['poi']
print type(labels)
features = df[features_list[1:]] # all expect for poi


#collist = ['from_poi_to_this_person', 'from_this_person_to_poi']
#features = df[collist]
#features = df[1:]
#print tabulate(features, headers='keys', tablefmt='psql', floatfmt=".1f")





from sklearn import tree
from sklearn.naive_bayes import GaussianNB
from sklearn import svm
from sklearn.metrics import accuracy_score

clf = tree.DecisionTreeClassifier(min_samples_split = 4)
clf.fit(features, labels)
pred = clf.predict(features)
acc = accuracy_score(pred, labels)
print type(pred)

df['result'] = pred
#prettyPicture(clf, features, labels)
pprint_df(df[['poi', 'result']],999)

# clf = GaussianNB()
# clf.fit(features, labels)
# pred = clf.predict(features)
# acc = accuracy_score(pred, labels)
# print acc


# clf = svm.SVC(kernel='rbf', C=10000)
# clf.fit(features, labels)
# pred = clf.predict(features)
# acc = accuracy_score(pred, labels)
# print acc


#output_image("test.png", "png", open("test.png", "rb").read())







#labels, features = targetFeatureSplit(data)


#print features

### Task 4: Try a varity of classifiers
### Please name your classifier clf for easy export below.
### Note that if you want to do PCA or other multi-stage operations,
### you'll need to use Pipelines. For more info:
### http://scikit-learn.org/stable/modules/pipeline.html

#from sklearn.naive_bayes import GaussianNB
#clf = GaussianNB()    # Provided to give you a starting point. Try a varity of classifiers.

### Task 5: Tune your classifier to achieve better than .3 precision and recall
### using our testing script.
### Because of the small size of the dataset, the script uses stratified
### shuffle split cross validation. For more info:
### http://scikit-learn.org/stable/modules/generated/sklearn.cross_validation.StratifiedShuffleSplit.html

#test_classifier(clf, my_dataset, features_list)

### Dump your classifier, dataset, and features_list so
### anyone can run/check your results.

dump_classifier_and_data(clf, my_dataset, features_list)
