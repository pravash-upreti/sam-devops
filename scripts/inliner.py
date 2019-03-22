import os
import requests
import json

url = os.environ["VAULT_SERVER"]+"/v1/"+os.environ["KV_ENGINE_NAME"]+"/data/"+os.environ["VAULT_SECRET_DIR"]+'/'+os.environ["STAGE"]+'/api'
headers = {'content-type': 'application/json', 'Accept-Charset': 'UTF-8','X-Vault-Token':os.environ["VAULT_TOKEN"]}
response = requests.get(url, headers=headers)
response_dict = response.json()
data = response_dict.get('data')
formatedData = {}
for key in data:
    components = key.split('_')
    formatedData.update({
        components[0] + ''.join(x.title() for x in components[1:]) : data.get(key)
    })

print json.dumps(formatedData)