#This code loops trought all the carriers and airports and does the POST
import requests
import string
from bs4 import BeautifulSoup


html_page = "C:\\git\\nanodegree\\Mongo\\UdacityNanoDegreeP2\\data\\options.html"


def extract_airports(html):
    data = []

    with open(html, "r") as html:

      soup = BeautifulSoup(html)

      for airport in soup.find(id="AirportList").find_all("option"):
        if string.find(airport['value'].lower(), 'all') != 0:
          data.append(airport['value'])

    return data

def extract_carriers(page):
    data = []

    with open(page, "r") as html:
        # do something here to find the necessary values
        soup = BeautifulSoup(html)
        for carrier in soup.find(id="CarrierList").find_all("option"):
            if len(carrier['value']) == 2:
                data.append(carrier['value'])

    return data



def get_session():
    s = requests.session()
    r = s.get("http://www.transtats.bts.gov/Data_Elements.aspx?Data=2")
    soup = BeautifulSoup(r.text)
    viewstate_element = soup.find(id="__VIEWSTATE")
    viewstate=viewstate_element["value"]
    eventvalidation_element = soup.find(id="__EVENTVALIDATION")
    eventvalidation=eventvalidation_element["value"]

    return  s, viewstate, eventvalidation

def make_request(s,viewstate,eventvalidation,airport,carrier):
    r = s.post("http://www.transtats.bts.gov/Data_Elements.aspx?Data=2",
                    data={'AirportList': airport,
                          'CarrierList': carrier,
                          'Submit': 'Submit',
                          "__EVENTTARGET": "",
                          "__EVENTARGUMENT": "",
                          "__EVENTVALIDATION": eventvalidation,
                          "__VIEWSTATE": viewstate
                    })

    return r


def test():
    carriers = extract_carriers(html_page)
    airport = extract_airports(html_page)

    s,vs,ev = get_session()
    #r = make_request(s,vs,ev,"BOS","VX")


    for a in airport:
        for c in carriers:
            r = make_request(s,vs,ev,a,c)
            file_name = c+"-"+a+".html"
            f = open("c_a\\"+file_name, "w")
            f.write(r.text)



#"FL-ATL.html"
    #f = open("foo.html", "w")
    #f.write(r.text)


test()



