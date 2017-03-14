import requests
import json

#clearwater_ns.csar and clearwater_vnf.csar file should reside in the same path with this code
multipart_form_data1 = {
             'file': ('clearwater_ns.csar',open('clearwater_ns.csar', 'rb'),'multipart/form-data')              
              }

multipart_form_data2 = {
             'file': ('clearwater_vnf.csar',open('clearwater_vnf.csar', 'rb'),'multipart/form-data')
              }
 
file1 = requests.post('http://192.168.57.54/openoapi/catalog/v1/csars', files=multipart_form_data1 )
file2 = requests.post('http://192.168.57.54/openoapi/catalog/v1/csars', files=multipart_form_data2 )
print(file1.status_code)
print(file2.status_code)

