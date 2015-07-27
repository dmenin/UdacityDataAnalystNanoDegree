# from sklearn.linear_model import LinearRegression
# clf = LinearRegression()
# clf.fit ([[0, 0], [1, 1], [2, 2]], [0, 1, 2])
#
# print clf.coef_
#
# print clf.predict([[2, 2]])


import numpy
import matplotlib.pyplot as plt

import numpy
import random

def ageNetWorthData():

    random.seed(42)
    numpy.random.seed(42)

    ages = []
    for ii in range(100):
        ages.append( random.randint(20,65) )
    net_worths = [ii * 6.25 + numpy.random.normal(scale=40.) for ii in ages]
    ### need massage list into a 2d numpy array to get it to work in LinearRegression
    ages       = numpy.reshape( numpy.array(ages), (len(ages), 1))
    net_worths = numpy.reshape( numpy.array(net_worths), (len(net_worths), 1))

    from sklearn.cross_validation import train_test_split
    ages_train, ages_test, net_worths_train, net_worths_test = train_test_split(ages, net_worths)

    return ages_train, ages_test, net_worths_train, net_worths_test



from sklearn.linear_model import LinearRegression
ages_train, ages_test, net_worths_train, net_worths_test = ageNetWorthData()

reg = LinearRegression()
reg.fit(ages_train, net_worths_train)

print reg.intercept_[0]

km_net_worth = reg.predict([[27]])
#print km_net_worth

#
#
# ### get the slope
# ### again, you'll get a 2-D array, so stick the [0][0] at the end
slope = reg.coef_[0] ### fill in the line of code to get the right value
#
# ### get the intercept
# ### here you get a 1-D array, so stick [0] on the end to access
# ### the info we want
intercept = reg.intercept_[0] ### fill in the line of code to get the right value
#
#
# ### get the score on test data
test_score = reg.score(ages_test, net_worths_test)
#
#
# ### get the score on the training data
training_score = reg.score(ages_train, net_worths_train)
#
#
#
# def submitFit():
#     return {"networth":km_net_worth,
#             "slope":slope,
#             "intercept":intercept,
#             "stats on test":test_score,
#             "stats on training": training_score}