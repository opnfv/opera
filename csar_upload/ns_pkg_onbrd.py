import requests
import json
import pprint

# http(s)://[hostname][:port]/openoapi/nslcm/v1/nspackage
#NS package onboarding. csarIds of CSAR packages should be given as input

payload1 = {'csarId' : '402d58fc-b904-4c25-be16-6597a0f08b38'}
payload2 = {'csarId' : '751866df-c4a0-4434-90b0-83b898fe6948' }
data1 = json.dumps(payload1)
data2 = json.dumps(payload2)
headers = {'Content-type': 'application/json'}
r1 = requests.post('http://192.168.57.54/openoapi/nslcm/v1/nspackage', data=data1,headers=headers)
r2 = requests.post('http://192.168.57.54/openoapi/nslcm/v1/nspackage', data=data2,headers=headers)
pprint.pprint(r1.json())
pprint.pprint(r2.json())
print (r1.status_code)
print (r2.status_code)


