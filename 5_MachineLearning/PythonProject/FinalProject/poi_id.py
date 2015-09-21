import sys
import pickle
import pprint
import pandas as pd
from sklearn.grid_search import GridSearchCV
from sklearn.svm import SVC
from tabulate import tabulate
from class_vis import prettyPicture, output_image
from collections import Counter
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
import math
from sklearn.feature_selection import SelectKBest
import itertools
from sklearn import tree
from sklearn.neighbors import KNeighborsClassifier


sys.path.append("../tools/")

#may need to replace this line:
from MiniProjects.tools.feature_format import featureFormat, targetFeatureSplit

#for this one on the submission:
#from feature_format import featureFormat, targetFeatureSplit

from tester import test_classifier, dump_classifier_and_data


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
def get_outliers_by_feature(df, g = 2.2, debug = 0, ignore_zeroes_on_calc = 0, ignore_zeroes_on_print = 0):
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

#######################################################Joins N list into one list of unique values
def union(a,b):
    for e in b:
        if e not in a:
            a.append(e)


#######################################################Runs the suggest outlier function.
# Needs to be called AFTER the dataset with the features is created
def get_unique_outliers(df):
    possible_outliers = get_outliers_by_feature(df, 2.2, 0, 1, 1)

    merged = []
    for key in possible_outliers:
        for item in possible_outliers[key]:
            if item not in merged:
                merged.append(item)

    for key in possible_outliers:
        l = possible_outliers[key]
        print 'Column:',key, '- Number of suggested outliers (ignoring 0s):',  len(l), 'Indices:', l

    print 'Unique Suggestions:', merged


#######################################################pretty print top N rows of a data frame
def pprint_df(df, n):
    print tabulate(df.head(n), headers='keys', tablefmt='psql', floatfmt=".1f")


#######################################################SelectKBest
def SelectKBestFeatures(features, labels, k, debug=False):
    k_best = SelectKBest(k='all')# score all features
    k_best.fit(features, labels)

    scores = k_best.scores_
    unsorted_pairs = zip(features_list[1:], scores)# joins the labels with the values
    sorted_pairs = list(reversed(sorted(unsorted_pairs, key=lambda x: x[1])))

    k_best_features = dict(sorted_pairs[:k])
    if debug:
        print sorted_pairs
        print "{0} best features: {1}\n".format(k, k_best_features.keys())

    return k_best_features

################################################################Attempt 1: simple tree with each individual measure
def one_feature_predict(features_list, my_dataset):
    all = []
    for i in features_list:
        if i != 'poi':
            l = []
            l.append('poi')
            l.append(i)
            all.append(l)
    #print all
    mycolumns = ['feature_list', 'accuracy', 'precision', 'recall', 'f1', 'f2']
    resultdf = pd.DataFrame(columns=mycolumns)
    for item in all:
        data = featureFormat(my_dataset, item, sort_keys = True)
        labels, features = targetFeatureSplit(data)

        clf = tree.DecisionTreeClassifier(min_samples_split = 4)
        clf.fit(features, labels)
        resultdf.loc[len(resultdf)] =  (test_classifier(clf, my_dataset, item))
    return resultdf




### Task 1: Select what features you'll use.
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
                 ,'from_messages'
                 ,'long_term_incentive'
                 ,'other','restricted_stock'
                 ,'restricted_stock_deferred'
                 ,'salary'
                 ,'to_messages'
                 ,'total_payments'
                 ,'total_stock_value'
                ]



### Load the dictionary containing the dataset
data_dict = pickle.load(open("final_project_dataset.pkl", "r") )

### Task 2: Remove outliers
#No need to run this code. See project description for details.
#df = pd.DataFrame(data, columns=features_list)
#labels = df['poi']
#features = df[features_list[1:]] # all expect for poi
#get_unique_outliers(df)
data_dict.pop('TOTAL') # 129
data_dict.pop('THE TRAVEL AGENCY IN THE PARK') #126


### Task 3: Create new feature(s)
my_dataset = data_dict

for key in data_dict:
    if math.isnan(float(my_dataset[key]['bonus'])) or (math.isnan(float(my_dataset[key]['salary']))):
        my_dataset[key]['bonus_salary_ratio'] = 0
    else:
        my_dataset[key]['bonus_salary_ratio'] = round(float(my_dataset[key]['bonus']) /float(my_dataset[key]['salary']),2)
features_list.append('bonus_salary_ratio')



### Extract features and labels from dataset for local testing
data = featureFormat(my_dataset, features_list, sort_keys = True)
labels, features = targetFeatureSplit(data)

k_best_features = SelectKBestFeatures(features, labels, 5, True)


#uncomment for Step 1:
#resultdf1 = one_feature_predict(features_list, my_dataset)
#print  tabulate(resultdf1.sort(['recall','accuracy', 'precision'], ascending = [0,0,0]) , headers='keys', tablefmt='psql', floatfmt=".4f")
#######################################################################



def df_to_dict(features_df=None, labels_df=None):
    features_df.insert(0, 'poi', labels_df)

    data_dict = features_df.T.to_dict()
    del features_df
    return data_dict


################################################################Attempt 2:
def topk_feature_predict(k_best_features, my_dataset, normalize_data = False):
    new_list = k_best_features.keys()
    all = []
    #for i in range(len(new_list)):
    #    if i !=0: #already looked at individual features on step 1. Start by 2X2
    #        all.extend([sorted(l) for l in itertools.combinations(new_list, i+1)])

    #use this to select only combinations of 4
    all.extend([sorted(l) for l in itertools.combinations(new_list, 4)])

    for item in all: #add 'poi' in the beginning to all combinations
        poi ='poi'
        item.insert(0, poi)


    mycolumns = ['feature_list', 'accuracy', 'precision', 'recall', 'f1', 'f2']
    resultdf2 = pd.DataFrame(columns=mycolumns)


    for item in all:
        data = featureFormat(my_dataset, item, sort_keys = True)


        if normalize_data:
            df = pd.DataFrame(data, columns=item)
            for column in df.columns[1:]:
                df[column] = (df[column] - df[column].mean()) / (df[column].std())
            labels = df['poi']
            features = df[item[1:]] # all expect for poi
        else:
            labels, features = targetFeatureSplit(data)


        #Attempt2 -  Tree with 5 best:
        #clf = tree.DecisionTreeClassifier(min_samples_split = 4)

        #Attempt3 -  KNeighborsClassifier with 5 best:
        #clf = KNeighborsClassifier(algorithm='auto', metric='minkowski', metric_params=None, n_neighbors=5, p=2, weights='distance')
        #clf = KNeighborsClassifier(algorithm='auto', metric='minkowski', metric_params=None, n_neighbors=6, p=2, weights='distance')
        clf = KNeighborsClassifier(algorithm='auto', metric='manhattan', metric_params=None, n_neighbors=6, p=2, weights='distance') # best


        #Attempt4 - Logistic regression:
        #clf = LogisticRegression(C=1000,penalty='l1',random_state=42,tol=-1000,class_weight='auto')

        #clf = RandomForestClassifier(n_estimators=10, min_samples_split = 4, n_jobs = -1, max_features = 0.5)
        #clf = LogisticRegression( C=1,penalty='l1',random_state=42,tol=10**-10,class_weight='auto')


        clf.fit(features, labels)


        #only have to transform back to dictionary if I had to make it a data frame to normalize
        if normalize_data:
            new_dataset = df_to_dict(features_df=features, labels_df=labels)
        else:
            new_dataset = my_dataset
        resultdf2.loc[len(resultdf2)]= (test_classifier(clf, new_dataset, item))

    return resultdf2

#uncomment for Test 2
#resultdf2 = topk_feature_predict(k_best_features, my_dataset, False)
#print tabulate(resultdf2.sort(['f1','recall','accuracy', 'precision'], ascending = [0, 0,0,0]) , headers='keys', tablefmt='psql', floatfmt=".4f")

#sys.exit(0)

#new_list = k_best_features.keys()
#new_list.insert(0, 'poi')
#data = featureFormat(my_dataset, new_list, sort_keys = True)
#labels, features = targetFeatureSplit(data)
#clf = RandomForestClassifier(n_estimators=10, min_samples_split = 4, n_jobs = -1, max_features = 0.5)
#clf = AdaBoostClassifier(base_estimator=None, n_estimators=50, learning_rate=1.0, algorithm='SAMME.R', random_state=None)


# param_grid = {
# 'C': [1e3, 5e3, 1e4, 5e4, 1e5],
# 'gamma': [0.0001, 0.0005, 0.001, 0.005, 0.01, 0.1],
# }
# clf = GridSearchCV(SVC(kernel='rbf', class_weight='auto'), param_grid)
# clf = clf.fit(features, labels)

final_feature_list = ['poi', 'bonus', 'deferred_income', 'exercised_stock_options', 'salary']

data = featureFormat(my_dataset, final_feature_list , sort_keys = True)
labels, features = targetFeatureSplit(data)

###################################################KNeighborsClassifier
def getBestKNeighborsClassifier():
    neighbor_params = [{'n_neighbors' : range(1,10)
                           , 'algorithm': ['auto', 'ball_tree', 'kd_tree', 'brute']
                           , 'weights': ['uniform', 'distance']
                           , 'metric': ['minkowski', 'euclidean', 'manhattan']
                           , 'p' : range(1,10)
                       }]
    clf = GridSearchCV(KNeighborsClassifier(), neighbor_params)
    best = clf.fit(features, labels)
    print best.best_estimator_

clf = KNeighborsClassifier(algorithm='auto', metric='manhattan', metric_params=None, n_neighbors=6, p=2, weights='distance') # best
clf.fit(features, labels)

mycolumns = ['feature_list', 'accuracy', 'precision', 'recall', 'f1', 'f2']
resultdf = pd.DataFrame(columns=mycolumns)
resultdf.loc[0]= (test_classifier(clf, my_dataset, final_feature_list))
print tabulate(resultdf.sort(['f1','recall','accuracy', 'precision'], ascending = [0, 0,0,0]) , headers='keys', tablefmt='psql', floatfmt=".4f")



dump_classifier_and_data(clf, my_dataset, final_feature_list)



###################################################LogisticRegression
# param_grid = [{'C': [1, 10, 100, 1000]
#                 , 'penalty': ['l1', 'l2']
#                 #, 'dual': [True,False]
#                 , 'fit_intercept': [True,False]
#                 , 'max_iter': range(70,130, 10)
#                 , 'solver': ['newton-cg', 'lbfgs', 'liblinear']
#                 , 'tol':[1, 10, 100, 1000]
#                 #, 'multi_class ': ['ovr', 'multinomial']
#               }]
# clf = GridSearchCV(LogisticRegression(), param_grid)
# best = clf.fit(features, labels)
# print best.best_estimator_








# features_list = ['poi', 'bonus', 'exercised_stock_options', 'salary', 'total_stock_value']
#
# data = featureFormat(my_dataset, features_list, sort_keys = True)
# df = pd.DataFrame(data, columns=features_list)
# for column in df.columns[1:]:
#     df[column] = (df[column] - df[column].mean()) / (df[column].std())
# labels = df['poi']
# features = df[features_list[1:]] # all expect for poi
#
# clf = KNeighborsClassifier(algorithm='auto', leaf_size=30, metric='minkowski', metric_params=None, n_neighbors=5, p=2, weights='distance')
# clf.fit(features, labels)
#
# my_dataset = combine_to_dict(features_df=features, labels_df=labels)








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




#https://www.youtube.com/watch?v=2HmopqF6V6w


