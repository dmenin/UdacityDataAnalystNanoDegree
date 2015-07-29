#!/usr/bin/python

import pickle
import sys
import matplotlib.pyplot
sys.path.append("../tools/")
from MiniProjects.tools.feature_format  import featureFormat, targetFeatureSplit


### read in data dictionary, convert to numpy array
data_dict = pickle.load( open("../../data/final_project_dataset.pkl", "r") )
data_dict .pop( 'TOTAL', 0 )
print data_dict
features = ["salary", "bonus"]
data = featureFormat(data_dict, features)

print(type(data))
a = sorted(data, key = lambda tup: tup[0], reverse=True)
print a



#LAVORATO, JOHN J                     339,288             8,000,000
#LAY, KENNETH L                    1,072,321              7,000,000
#
# for point in data:
#     salary = point[0]
#     bonus = point[1]
#     matplotlib.pyplot.scatter( salary, bonus)
#
# matplotlib.pyplot.xlabel("salary")
# matplotlib.pyplot.ylabel("bonus")
# matplotlib.pyplot.show()
#

#SKILLING, JEFFREY K - 1,111,258
#LAY, KENNETH L  - 1,072,321
#FREVERT, MARK A - 1,060,932