__author__ = 'dmenin'
import pandas as pd
import matplotlib.pyplot as plt
from ggplot import *

def get_db(db_name):
    from pymongo import MongoClient
    client = MongoClient('localhost:27017')
    db = client[db_name]
    return db

def make_pipeline():
    # Which Region in India has the largest number of cities with longitude between 75 and 80?
    pipeline = [ ]
#    pipeline.append( { "$group" :  {"_id" : "$isPartOf","count" : { "$sum" : 1 }}})

    pipeline.append( { "$group": { "_id": "$created.user", "total": { "$sum": 1 } } } )
    pipeline.append( { "$sort": { "total": -1 } } )
    pipeline.append( { "$limit": 4}  )
    return pipeline

def aggregate(db, pipeline):
    result = db.dublin.aggregate(pipeline)
    return result

if __name__ == '__main__':
    db = get_db('project')
    pipeline = make_pipeline()
    result = aggregate(db, pipeline)


    k = []
    v = []

    i = 1
    for r in result:
        k.append(r["_id"])
        #k.append(i)
        v.append(r["total"])
        i+=1



    #df = pd.DataFrame({"x":[1,2,3,4], "y":[1,3,4,2]})
    df = pd.DataFrame({"name":k, "value":v})
    print df

    print ggplot(aes(x="name", y="value"), df)  + geom_bar(stat='bar', fill='blue') + theme(axis_text_x  = element_text(angle = 90, hjust = 1)) + ylab("Count") + xlab("User")


    #print df
    #df.to_csv("foo.csv", sep=',', encoding='utf-8')
    #print ggplot(aes(x="name", weight="value"), df) + geom_bar()














