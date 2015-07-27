__author__ = 'dmenin'

import pickle
import pprint
enron_data = pickle.load(open("../Data/final_project_dataset.pkl", "r"))

#number of people
#print len(enron_data.keys())
#or
#k = [k for (k, v) in enron_data.iteritems()]
#print len(k)

#features per person
#k1 =  enron_data.keys()[0]
#print len(enron_data[k1])

#pprint.pprint(enron_data)

#Persons of interest on the dataset:
# i = 0;
# for key, value in enron_data.iteritems():
#     print key
#     print type(value)
#     for key2, value2 in value.iteritems():
#          if key2 == "poi":
#              if value2:
#                  i+=1
#
# print i

# i=0
# for key in enron_data:
#     if enron_data[key]["poi"]:
#         i+= 1
# print i


####################What is the total value of the stock belonging to James Prentice?
# for key in enron_data:
#     print key
#print enron_data["PRENTICE JAMES"]["total_stock_value"]


##############How many email messages do we have from Wesley Colwell to persons of interest?
#pprint.pprint(enron_data["COLWELL WESLEY"]["from_this_person_to_poi"])


#####Whats the value of stock options exercised by Jeffrey Skilling?
#pprint.pprint(enron_data["SKILLING JEFFREY K"]["exercised_stock_options"])

#Of these three individuals (Lay, Skilling and Fastow), who took home the most money (largest value of "total_payments" feature)?
#Kenneth Lay - chairman
#Jeffrey Skilling - CEO
#Andrew Fastow - CFO
#print enron_data["LAY KENNETH L"]["total_payments"]
#print enron_data["SKILLING JEFFREY K"]["total_payments"]
#print enron_data["FASTOW ANDREW S"]["total_payments"]


#pprint.pprint(enron_data)
###########How many folks in this dataset have a quantified salary? What about a known email address?
i=0
for key in enron_data:
    if  enron_data[key]["poi"] :
         i+= 1
print i