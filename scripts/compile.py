import os
import yaml
from jinja2 import Environment, FileSystemLoader
import requests
import json
import pprint

url = os.environ["VAULT_SERVER"]+"/v1/"+os.environ["KV_ENGINE_NAME"]+"/data/"+os.environ["VAULT_SECRET_DIR"]+'/'+os.environ["STAGE"]+'/api'
headers = {'content-type': 'application/json', 'Accept-Charset': 'UTF-8','X-Vault-Token':os.environ["VAULT_TOKEN"]}
response = requests.get(url, headers=headers)
response_dict = response.json()
parent_data = response_dict.get('data')
data = parent_data.get('data')

formatedData = {}

vaultData={}
for key in data:
    components = key.split('_')
    vaultData.update({
        key: components[0] + ''.join(x.title() for x in components[1:])
    })
    
formatedData.update({'vault' : vaultData })
for key , value in os.environ.items():
    formatedData.update({
        key: value
    })

formatedData.update({
    "FUNCTION_NAME": open('function_name', 'r').readline().rstrip()
})

# print formatedData
env = Environment(loader = FileSystemLoader('./scripts'), trim_blocks=True, lstrip_blocks=True)

# Compile template.yml


template = env.get_template('template.yaml.j2')
config_file = open("./sam-assets/template.yaml", "w+")
config_file.write(template.render(list = [formatedData]))

# # Compile simple proxy
# nonFormatedData={}
# for key in data:
#     nonFormatedData.update({
#         key: data[key]
#     })

# for key , value in os.environ.items():
#     nonFormatedData.update({
#         key: value
#     })

# proxy_api = env.get_template('simple-proxy-api.yaml.j2')
# config_file = open("./sam-assets/simple-proxy-api.yaml", "w+")
# config_file.write(proxy_api.render(nonFormatedData))