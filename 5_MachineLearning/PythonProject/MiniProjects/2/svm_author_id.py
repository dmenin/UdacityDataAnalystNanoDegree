#Support Vector Machines
import sys
from time import time
from MiniProjects.tools.email_preprocess import preprocess

features_train, features_test, labels_train, labels_test = preprocess()

#features_train = features_train[:len(features_train)/100]
#labels_train = labels_train[:len(labels_train)/100]

from sklearn import svm

clf = svm.SVC(kernel='rbf', C=10000)
t0 = time()
clf.fit(features_train, labels_train)
print "training time:", round(time()-t0, 3), "s"


t0 = time()
pred = clf.predict(features_test)
print "pred time:", round(time()-t0, 3), "s"

print sum(pred)



from sklearn.metrics import accuracy_score
acc = accuracy_score(pred, labels_test)
print acc

