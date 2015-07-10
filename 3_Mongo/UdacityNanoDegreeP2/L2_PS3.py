#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Let's assume that you combined the code from the previous 2 exercises
# with code from the lesson on how to build requests, and downloaded all the data locally.

# The files are in a directory "data", named after the carrier and airport:
# "{}-{}.html".format(carrier, airport), for example "FL-ATL.html".

# The table with flight info has a table class="dataTDRight".
# There are couple of helper functions to deal with the data files.
# Please do not change them for grading purposes.
# All your changes should be in the 'process_file' function
# This is example of the datastructure you should return
# Each item in the list should be a dictionary containing all the relevant data
# Note - year, month, and the flight data should be integers
# You should skip the rows that contain the TOTAL data for a year
# data = [{"courier": "FL",
#         "airport": "ATL",
#         "year": 2012,
#         "month": 12,
#         "flights": {"domestic": 100,
#                     "international": 100}
#         },
#         {"courier": "..."}
# ]
from bs4 import BeautifulSoup
from zipfile import ZipFile
import os

datadir = "c_a"


def open_zip(datadir):
    with ZipFile('{0}.zip'.format(datadir), 'r') as myzip:
        myzip.extractall()


def process_all(datadir):
    files = os.listdir(datadir)
    return files


def process_file(f):
    """This is example of the data structure you should return.
    Each item in the list should be a dictionary containing all the relevant data
    from each row in each file. Note - year, month, and the flight data should be 
    integers. You should skip the rows that contain the TOTAL data for a year
    data = [{"courier": "FL",
            "airport": "ATL",
            "year": 2012,
            "month": 12,
            "flights": {"domestic": 100,
                        "international": 100}
            },
            {"courier": "..."}
    ]
    """
    data = []
    info = {}
    info["courier"], info["airport"] = f[:6].split("-")
    
    with open("{}/{}".format(datadir, f), "r") as html:

        soup = BeautifulSoup(html)

        for row in soup.find('table', class_='dataTDRight').find_all('tr', class_='dataTDRight'):
            cols = row.find_all('td')
            if cols[1].text.lower().find('total') == -1:
                info = {}
                _int = cols[3].text.replace(',', '')
                _dom = cols[2].text.replace(',', '')
                if _int.strip() == "":
                    _int = 0
                if _dom.strip() == "":
                    _dom = 0
                info["year"] = int(cols[0].text)
                info["month"] = int(cols[1].text)
                info["flights"] = {"domestic" : _dom, "international" : _int}
                data.append(info)

    return data


def test():
    print "Running a simple test..."
    #open_zip(datadir)
    #files = process_all(datadir)
    #data = []
    #for f in files:
        #data += process_file(f)
    f = "FL-ATL.html"
    #f = "US-DYS.html"#one
    #f = "B6-AMA.html"#two
    #f = "UA-BIS.html"#three
    data = process_file(f)
    print data

#    assert len(data) == 399  # Total number of rows
#    for entry in data[:3]:
#        assert type(entry["year"]) == int
#        assert type(entry["month"]) == int
#        assert type(entry["flights"]["domestic"]) == int
#        assert len(entry["airport"]) == 3
#        assert len(entry["courier"]) == 2
#    assert data[-1]["airport"] == "ATL"
#    assert data[-1]["flights"] == {'international': 108289, 'domestic': 701425}
    
    print "... success!"

if __name__ == "__main__":
    test()