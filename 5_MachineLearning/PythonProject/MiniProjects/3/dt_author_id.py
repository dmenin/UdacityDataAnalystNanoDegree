#Decision Trees
from time import time
from MiniProjects.tools.email_preprocess import preprocess

features_train, features_test, labels_train, labels_test = preprocess()

#print len(features_train[0])
#print (features_train[0])
from sklearn import tree
clf = tree.DecisionTreeClassifier(min_samples_split = 40)
t0 = time()
clf.fit(features_train, labels_train)
print "training time:", round(time()-t0, 3), "s"



t0 = time()
pred = clf.predict(features_test)
print "pred time:", round(time()-t0, 3), "s"


from sklearn.metrics import accuracy_score
accuracy = accuracy_score(pred, labels_test)
print accuracy


