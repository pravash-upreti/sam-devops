import os
import yaml
from jinja2 import Environment, FileSystemLoader
import requests
import json


url = os.environ["VAULT_SERVER"]+"/v1/secret/"+os.environ["VAULT_SECRET_DIR"]
headers = {'content-type': 'application/json', 'Accept-Charset': 'UTF-8','X-Vault-Token':os.environ["VAULT_TOKEN"]}
response = requests.get(url, headers=headers)
response_dict = response.json()
data = response_dict.get('data')

formatedData = {}
for key in data:
    components = key.split('_')
    formatedData.update({
        key: components[0] + ''.join(x.title() for x in components[1:])
    })

env = Environment(loader = FileSystemLoader('./scripts'), trim_blocks=True, lstrip_blocks=True)

# Compile template.yml

template = env.get_template('template.yaml.j2')
config_file = open("./sam-assets/template.yaml", "w+")
config_file.write(template.render(list = [formatedData]))

# Compile simple proxy
formatedData.update({
    "PROXY_API_REGION": os.environ["AWS_DEFAULT_REGION"]
})

proxy_api = env.get_template('simple-proxy-api.yaml.j2')
config_file = open("./sam-assets/simple-proxy-api.yaml", "w+")
config_file.write(proxy_api.render(list = [formatedData]))