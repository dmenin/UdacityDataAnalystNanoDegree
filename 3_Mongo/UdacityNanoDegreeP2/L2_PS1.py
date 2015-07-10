#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Please note that the function 'make_request' is provided for your reference only.
# You will not be able to to actually use it from within the Udacity web UI
# All your changes should be in the 'extract_carrier' function
# Also note that the html file is a stripped down version of what is actually on the website.

# Your task in this exercise is to get a list of all airlines. Exclude all of the combination
# values, like "All U.S. Carriers" from the data that you return.
# You should return a list of codes for the carriers.

from bs4 import BeautifulSoup
html_page = "C:\\git\\nanodegree\\Mongo\\UdacityNanoDegreeP2\\data\\options.html"


def extract_carriers(page):
    data = []

    with open(page, "r") as html:
        # do something here to find the necessary values
        soup = BeautifulSoup(html)
        for carrier in soup.find(id="CarrierList").find_all("option"):
            if len(carrier['value']) == 2:
                data.append(carrier['value'])

    return data

def test():
    data = extract_carriers(html_page)
    print data
    #assert len(data) == 16
    #assert "FL" in data
    #assert "NK" in data

test()