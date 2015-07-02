__author__ = 'dmenin'

import xml.etree.cElementTree as ET
import pprint
import re
from collections import defaultdict
import codecs
import json

SAMPLE_FILE = "C:\\git\\nanodegree\\Mongo\\UdacityNanoDegreeP2\\FinalProject\\data_dublin\\sample.osm" #dublin_ireland.osm"
JSON_FILE = "C:\\git\\nanodegree\\Mongo\\UdacityNanoDegreeP2\\FinalProject\\data_dublin\\sample.json"

#################regular expressions used on check 2################
lower = re.compile(r'^([a-z]|_)*$')
lower_colon = re.compile(r'^([a-z]|_)*:([a-z]|_)*$')
problemchars = re.compile(r'[=\+/&<>;\'"\?%#$@\,\. \t\r\n]')
####################################################################

#################regular expression used on check 4################
street_type_re = re.compile(r'\b\S+\.?$', re.IGNORECASE)
####################################################################


#######################check 1 - check XML tag count################################################################
def checkTagCount(filename):
    tags = {}

    for event, elem in ET.iterparse(filename):
        if elem.tag in tags:
            tags[elem.tag] += 1
        else:
            tags[elem.tag] = 1

    return tags

#######################check 2 - Analyse the "k" value on the "tag" TAG############################################
def checkTagStatus(filename):
    keys = {"lower": 0, "lower_colon": 0, "problemchars": 0, "other": 0}
    for _, element in ET.iterparse(filename):
        keys = key_type(element, keys)
    return keys

def key_type(element, keys):
    if element.tag == "tag":
        if lower.search(element.attrib['k']):
            keys['lower'] += 1
        elif lower_colon.search(element.attrib['k']):
            keys['lower_colon'] += 1
        elif problemchars.search(element.attrib['k']):
            keys['problemchars'] += 1
            print "Element:"
            print element.attrib['k']

        else:
            keys['other'] += 1

    return keys

#######################check 3 - List User ids##################################################################
def listUsers(filename):
    users = set()
    for _, element in ET.iterparse(filename):
        if "uid" in element.attrib:
        	users.add(element.attrib["user"])

    return users

#######################Check 4 - Street Names:##################################################################
def auditStreetName(osmfile):
    osm_file = open(osmfile, "r")
    street_types = defaultdict(set)

    for event, elem in ET.iterparse(osm_file, events=("start",)):

        if elem.tag == "node" or elem.tag == "way":
            for tag in elem.iter("tag"):
                if is_street_name(tag):
                    audit_street_type(street_types, tag.attrib['v'])

    return street_types


def is_street_name(elem):
    return (elem.attrib['k'] == "addr:street")

def audit_street_type(street_types, street_name):
    m = street_type_re.search(street_name)
    if m:
        street_type = m.group()
        if street_type not in expected:
            street_types[street_type].add(street_name)


expected = ["Street", "Avenue", "Boulevard", "Drive", "Court", "Place", "Square", "Lane", "Road",
            "Trail", "Parkway", "Commons", "Terrace", "Park", "Quay", "Rise","Row","South",
            "Upper", "View", "Villas", "Walk", "Way", "West", "Woods"]


mapping = { "St": "Street",
            "St.": "Street",
            "Sreet" : "Street",
            "sreet" : "Street",
            "Ave":"Avenue",
            "Rd.":"Road",
            "Center" : "Centre",
            "House," : "House",
            "Triangle)" : "'Triangle",
            "lane" : "Lane",
            "park" : "Park",
            "place" : "Place",
            "road" : "Road"
            #,"Way" : "WayTest" # this is a test replacement for debuging only
            }

def update_name(name, mapping):

    m = street_type_re.search(name)
    if m:
        street_type = m.group()
        if street_type not in expected:
            if street_type in mapping:
                name = re.sub(street_type_re, mapping[street_type], name)
    return name

######################Make JSON##################################################################
def process_map(file_in, better_names, pretty = False):
    # You do not need to change this file
    #file_out = "{0}.json".format(file_in)
    data = []
    with codecs.open(JSON_FILE, "w") as fo:
        for _, element in ET.iterparse(file_in):
            el = shape_element(element, better_names)
            if el:
                data.append(el)
                if pretty:
                    fo.write(json.dumps(el, indent=2)+"\n")
                else:
                    fo.write(json.dumps(el) + "\n")
    return data

CREATED = [ "version", "changeset", "timestamp", "user", "uid"]



def shape_element(element, better_names):
    node = {}
    if element.tag == "node" or element.tag == "way" :
        node['type'] = element.tag

        #ATRRIBUTES - all attributes should be turned into regular key/value pairs, except:
        node['created'] = {} #should I worry if it is empty?
        node['pos'] = {} #should I worry if it is empty?

        #<node changeset="12446579" id="1731613977" lat="53.3335744" lon="-6.2637359" timestamp="2012-07-23T08:36:40Z" uid="6367" user="mackerski" version="2">
        #loop through changeset, id, alt, log, timestamp, uid and so on....
        for a in element.attrib:
            attr = element.attrib[a]
            #print attr
            if a in CREATED: #attributes in the CREATED array should be added under a key "created"
                node['created'][a] = attr
            elif a in ['lat', 'lon']: #attributes for latitude and longitude should be added to a "pos" array
                if a == 'lat':
                    node['pos'][0] = float(attr) #try\catch?
                else:
                    node['pos'][1] = float(attr) #try\catch?
            else:
                node[a] = element.attrib[a]


        for tag in element.iter("tag"):
            #print tag.attrib['k']
            #if second level tag "k" value contains problematic characters, it should be ignored
            my_key = tag.attrib['k']
            my_value = tag.attrib['v']

            if problemchars.search(my_key) == None:
                if 'address' not in node:
                    node['address'] = {}
                if lower_colon.search(my_key):
                    #If second level tag "k" value starts with "addr:", it should be added to a dictionary "address"
                    if my_key.find('addr') == 0:
                        sub_attr = my_key.split(':', 1) #['addr', 'street']
                        address_key = sub_attr[1]

                        if  my_key == 'addr:street':
                            if my_value in better_names:
                                my_value = better_names[my_value]
                        node['address'][address_key] = my_value
                    #If second level tag "k" value does not start with "addr:", but contains ":", you can process it same as any other tag.
                    elif lower_colon.search(my_key):
                        my_key = my_key.split(':', 1)[1]
                        node[my_key] = my_value
                else:
                    if my_key != 'address': #there are cases were adrress is duplicated. We want the one on addr:street
                        node[my_key] = my_value
        return node
    else:
        return None

if __name__ == "__main__":

    #print "Check 1:"
    #tagCount = checkTagCount(SAMPLE_FILE)
    #pprint.pprint(tagCount)

    #print "Check 2:"
    #tagStatus =  checkTagStatus(SAMPLE_FILE)
    #pprint.pprint(tagStatus)

    #print "Check 3:"
    #l = listUsers(SAMPLE_FILE)
    #pprint.pprint(l)

    # print "Check 4:"
    st_types = auditStreetName(SAMPLE_FILE)
    #pprint.pprint(dict(st_types))

    better_names = {}
    for st_type, ways in st_types.iteritems():
        for name in ways:
            better_name = update_name(name, mapping)
            if name != better_name: #not expected but also not coded to be fixed
                print name, "=>", better_name
                better_names[name] = better_name

    data = process_map(SAMPLE_FILE, better_names, True)
    pprint.pprint(data)