__author__ = 'dim'
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
In this problem set you work with cities infobox data, audit it, come up with a cleaning idea and then
clean it up. In the first exercise we want you to audit the datatypes that can be found in some
particular fields in the dataset.
The possible types of values can be:
- NoneType if the value is a string "NULL" or an empty string ""
- list, if the value starts with "{"
- int, if the value can be cast to int
- float, if the value can be cast to float, but CANNOT be cast to int.
   For example, '3.23e+07' should be considered a float because it can be cast
   as float but int('3.23e+07') will throw a ValueError
- 'str', for all other values

The audit_file function should return a dictionary containing fieldnames and a SET of the types
that can be found in the field. e.g.
{"field1: set([float, int, str]),
 "field2: set([str]),
  ....
}

All the data initially is a string, so you have to do some checks on the values first.

"""
import codecs
import csv
import json
import pprint

CITIES = 'C:\\git\\nanodegree\\Mongo\\UdacityNanoDegreeP2\\data\\cities.csv'

FIELDS = ["name", "timeZone_label", "utcOffset", "homepage", "governmentType_label", "isPartOf_label", "areaCode", "populationTotal",
          "elevation", "maximumElevation", "minimumElevation", "populationDensity", "wgs84_pos#lat", "wgs84_pos#long",
          "areaLand", "areaMetro", "areaUrban"]


def audit_file(filename, fields):
    fieldtypes = {}

    for field in fields:
        fieldtypes[field] = set()

    tn = type(None)
    tl = type([])  #list
    ti = type(0)   #int
    tf = type(0.1) #float
    ts = type('')  #string

    with open(filename, 'r') as input:
        reader = csv.DictReader(input)

        for row in reader:
             #eliminate the first 3 columns - seems to be dirty data
             if row['URI'].find('dbpedia') > -1:

                 for field in fields:
                     if row[field] == "NULL" or row[field] == "":
                         fieldtypes[field].add(tn)
                     elif row[field][0] == "{":
                         fieldtypes[field].add(tl)
                     elif check_int(row[field]):
                         fieldtypes[field].add(ti)
                     elif check_float(row[field]):
                         fieldtypes[field].add(tf)
                     else:
                         fieldtypes[field].add(ts)

    return fieldtypes

def check_int(value):
    try:
        int(value)
        return True
    except:
        return False

def check_float(value):
    try:
        float(value)
        return True
    except:
        return False


def test():
    fieldtypes = audit_file(CITIES, FIELDS)

    pprint.pprint(fieldtypes)


if __name__ == "__main__":
    test()
