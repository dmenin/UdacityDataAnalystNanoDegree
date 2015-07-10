import json

DATAFILE = 'C:\\git\\nanodegree\\Mongo\\UdacityNanoDegreeP2\\data\\arachnid.json'

def insert_data(data, db):

    db.arachnid.insert(data)

    pass


if __name__ == "__main__":
    
    from pymongo import MongoClient
    client = MongoClient("mongodb://localhost:27017")
    db = client.examples

    with open(DATAFILE) as f:
        data = json.loads(f.read())


        insert_data(data, db)
        print db.arachnid.find_one()