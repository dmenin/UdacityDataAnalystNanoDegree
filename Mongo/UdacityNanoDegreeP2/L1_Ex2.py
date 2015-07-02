import os
import pprint
import csv

DATADIR = ""
DATAFILE = "C:\\git\\nanodegree\\Mongo\\UdacityNanoDegreeP2\\data\\beatles-diskography.csv"

def parse_file(datafile):
    data = [] #list
    n=0

    with open(datafile, "rb") as sd:
        r = csv.DictReader(sd)
        for line in r:
            data.append(line)

    return data

def test():
    datafile = os.path.join(DATADIR, DATAFILE)
    d = parse_file(datafile)
    pprint.pprint(d)


test()

