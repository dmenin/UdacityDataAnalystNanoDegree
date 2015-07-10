__author__ = 'dmenin'

from sklearn import tree
X = [[0, 0], [1, 1]]
Y = [0, 1]
clf = tree.DecisionTreeClassifier()
clf = clf.fit(X, Y)


print clf.predict([[2., 2.]])


prettyPicture(clf, features_test, labels_test)
output_image("test.png", "png", open("test.png", "rb").read())