import sys
import pickle
import pprint
import pandas as pd
from tabulate import tabulate
from class_vis import prettyPicture, output_image
from collections import Counter

sys.path.append("../tools/")

#may need to replace this line:
from MiniProjects.tools.feature_format import featureFormat, targetFeatureSplit

#for this one on the submission:
#from feature_format import featureFormat, targetFeatureSplit

from tester import test_classifier, dump_classifier_and_data

### Task 1: Select what features you'll use.
#Auxuliar function for outlier detection:
""" For each column of a data frame, checks the values that are considered outliers based on the IQR rule
    Parameters:
        df: data frame
        g: g-value for interquartile calcularion
        debug: print messages as the function runs
        ignore_zeroes_on_calc: do not use the zero values on the IQR calculation
        ignore_zeroes_on_print: do not print "outliers" that are zero
        NOTE: the last two parameters are specific for one particular situation, thats the reason the default is 0
            first column is assumed to be the "outcome", so it is ignored
        OUTPUT: Dictionary where the key is the column and the value is a list of suggestions
"""
def suggest_outliers(df, g = 2.2, debug = 0, ignore_zeroes_on_calc = 0, ignore_zeroes_on_print = 0):
    possible_outliers = {}
    if ignore_zeroes_on_calc == 1:
        ignore_zeroes_on_print =1

    for column in df.columns[1:]:
        key = column
        #print df[df[column] >0] [column]

        if ignore_zeroes_on_calc:
            Q1 =  (df[df[column] !=0].ix[:,column]).quantile(0.25)
            Q3 =  (df[df[column] !=0].ix[:,column]).quantile(0.75)
        else:
            Q1 =  (df.ix[:,column]).quantile(0.25)
            Q3 =  (df.ix[:,column]).quantile(0.75)


        limit = (Q3 - Q1) * g

        lower_limit = Q1 - limit
        upper_limit = Q3 + limit

        if ignore_zeroes_on_print:
            l = df[(df[column] >0 ) & ((df[column] <  lower_limit) | (df[column] >  upper_limit))].index.tolist()
        else:
            l = df[(df[column] <  lower_limit) | (df[column] >  upper_limit)].index.tolist()

        if debug:
            print 'Column Name: %s, Lower Limit: %s, Upper Limit: %s' % (column, lower_limit, upper_limit)
            print '            Number of suggested outliers (ignoring 0s):',  len(l), 'Indices:', l

        possible_outliers[key] = l

    return possible_outliers

#Joins N list into one list of unique values
def union(a,b):
    for e in b:
        if e not in a:
            a.append(e)

#Runs the suggest outlier function. Needs to be called AFTER the dataset with the features is created
def suggest_outlier(df):
    possible_outliers = suggest_outliers(df, 2.2, 0, 1, 1)

    merged = []
    for key in possible_outliers:
        for item in possible_outliers[key]:
            if item not in merged:
                merged.append(item)

    for key in possible_outliers:
        l = possible_outliers[key]
        print 'Column:',key, '- Number of suggested outliers (ignoring 0s):',  len(l), 'Indices:', l

    print 'Unique Suggestions:', merged

#pretty print top N rows of a data frame
def pprint_df(df, n):
    print tabulate(df.head(n), headers='keys', tablefmt='psql', floatfmt=".1f")



all_features = ['poi'
                 ,'bonus'
                 ,'deferral_payments'
                 ,'deferred_income','director_fees','exercised_stock_options'
                 ,'expenses', 'from_messages','loan_advances'
                 ,'long_term_incentive','other','restricted_stock','restricted_stock_deferred','salary'
                 ,'to_messages','total_payments', 'total_stock_value'
                ]

features_list = ['poi'
                 ,'bonus'
                 ,'deferral_payments'
                 ,'deferred_income'
                 ,'director_fees'
                 ,'exercised_stock_options'
                 ,'expenses'
                 , 'from_messages'
                 ,'long_term_incentive','other','restricted_stock','restricted_stock_deferred','salary'
                 ,'to_messages','total_payments', 'total_stock_value'
                ]









### Load the dictionary containing the dataset
data_dict = pickle.load(open("final_project_dataset.pkl", "r") )
#print pprint.pprint(data_dict)

### Task 2: Remove outliers
#df = pd.DataFrame(data, columns=features_list)
#labels = df['poi']
#features = df[features_list[1:]] # all expect for poi
#suggest_outlier(df)
data_dict.pop('TOTAL') # 129
data_dict.pop('THE TRAVEL AGENCY IN THE PARK') #126


### Task 3: Create new feature(s)
my_dataset = data_dict
#print pprint.pprint(my_dataset)



### Extract features and labels from dataset for local testing
data = featureFormat(my_dataset, features_list, sort_keys = True)
labels, features = targetFeatureSplit(data)

from sklearn.feature_selection import SelectKBest
k = 5
k_best = SelectKBest(k=k)
k_best.fit(features, labels)

scores = k_best.scores_
unsorted_pairs = zip(features_list[1:], scores)
sorted_pairs = list(reversed(sorted(unsorted_pairs, key=lambda x: x[1])))
k_best_features = dict(sorted_pairs[:k])
print "{0} best features: {1}\n".format(k, k_best_features.keys())
print ""
print (k_best_features.keys())


#new_list = features_list[1:]
new_list = k_best_features.keys()
all = []
import itertools
for i in range(len(new_list)):
    all.extend([sorted(l) for l in itertools.combinations(new_list, i+1)])

for item in all:
    poi ='poi'
    item.insert(0, poi)
#print (all)

from sklearn import tree
mycolumns = ['feature_list', 'accuracy', 'precision', 'recall', 'f1', 'f2']
resultdf = pd.DataFrame(columns=mycolumns)
print len(resultdf)

for item in all:
    data = featureFormat(my_dataset, item, sort_keys = True)
    labels, features = targetFeatureSplit(data)

    clf = tree.DecisionTreeClassifier(min_samples_split = 4)
    clf.fit(features, labels)
    resultdf.loc[len(resultdf)] =  (test_classifier(clf, my_dataset, item))

print  tabulate(resultdf, headers='keys', tablefmt='psql', floatfmt=".4f")




def one_term_predict():
    all = []
    for i in features_list:
        if i != 'poi':
            l = []
            l.append('poi')
            l.append(i)
            all.append(l)
    #print all

    for item in all:
        data = featureFormat(my_dataset, item, sort_keys = True)
        labels, features = targetFeatureSplit(data)

        clf = tree.DecisionTreeClassifier(min_samples_split = 4)
        clf.fit(features, labels)
        test_classifier(clf, my_dataset, item)





from sklearn.naive_bayes import GaussianNB
from sklearn import svm
from sklearn.metrics import accuracy_score

#clf = tree.DecisionTreeClassifier(min_samples_split = 4)
#clf.fit(features, labels)

#pred = clf.predict(features)
#acc = accuracy_score(pred, labels)
#print acc
#df['result'] = pred
#pprint_df(df[['poi', 'result']],999)

#test_classifier(clf, my_dataset, features_list)



from sklearn.cluster import KMeans
##data2 = featureFormat(data_dict, features_list )
##poi, finance_features = targetFeatureSplit( data2 )
#clf = KMeans(n_clusters=2).fit(features, labels) #Accuracy: 0.83560	Precision: 0.21860	Recall: 0.09050	F1: 0.12801	F2: 0.10251
#test_classifier(clf, my_dataset, features_list)
##pred = clf.fit_predict( features )



#from sklearn.preprocessing import MinMaxScaler
#scaler = MinMaxScaler()
#finance_features = scaler.fit_transform(finance_features)
#print scaler.transform([200000., 1000000.])





#clf = GaussianNB()
#clf.fit(features, labels)
#test_classifier(clf, my_dataset, features_list)
## pred = clf.predict(features)
## acc = accuracy_score(pred, labels)
## print acc


#clf = svm.SVC(kernel='rbf', C=10000)
#clf.fit(features, labels)
#test_classifier(clf, my_dataset, features_list)
## pred = clf.predict(features)
## acc = accuracy_score(pred, labels)
## print acc


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

#dump_classifier_and_data(clf, my_dataset, features_list)


#https://www.youtube.com/watch?v=2HmopqF6V6w