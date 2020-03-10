#!/usr/bin/python

import ESL
import sys
import requests
import json

con = ESL.ESLconnection('localhost', '8021', 'ClueCon')

print sys.argv

if con.connected:
    con.events('plain', 'all')
    e = con.recvEvent()
    if e:
    	print e.serialize()
info = con.getInfo()
var1 = con.execute("uuid_getvar")
print(var1)
print(info)

data = {"SipId" : 1010}
headers = {'Content-Type': 'application/json'}
url2='http://94.20.81.137'
r = requests.post(url2, data=json.dumps(data), headers=headers)

output = r.text.encode('ascii','ignore')
number = output[10:-1]
print(number)
