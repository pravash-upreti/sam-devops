import os
import yaml
from jinja2 import Environment, FileSystemLoader
import requests
import json
import pprint


def get_vault_data():

    """ Return the json data from vault """

    url = os.environ["VAULT_SERVER"]+"/v1/"+os.environ["KV_ENGINE_NAME"]+"/data/"+os.environ["VAULT_SECRET_DIR"]+'/'+os.environ["STAGE"]+'/api'
    headers = {'content-type': 'application/json', 'Accept-Charset': 'UTF-8','X-Vault-Token':os.environ["VAULT_TOKEN"]}
    response = requests.get(url, headers=headers)

    try:
        response.raise_for_status()
    except HTTPError as e:
        raise SystemExit("Error: " + str(e))

    response_dict = response.json()
    parent_data = response_dict.get('data')
    
    return parent_data.get('data')


def get_formated_data():

    """ Return the key value pair """

    data = get_vault_data()

    formated_data = {}

    vault_data = {}
    
    # Remove underscore from the json key 
    for key in data:
        components = key.split('_')
        vault_data.update({
            key: components[0] + ''.join(x.title() for x in components[1:])
        })
    
    # Append environment key pair to formated_data dict
    formated_data.update({'vault' : vault_data})
    for key , value in os.environ.items():
        formated_data.update({
            key: value
        })

    # open the function name that is timestamp value 
    formated_data.update({
        "FUNCTION_NAME": open('function_name', 'r').readline().rstrip()
    })

    return formated_data


def compile():

    """ Compile the yaml template """
    
    # print formatedData
    env = Environment(loader = FileSystemLoader('./scripts'), trim_blocks=True, lstrip_blocks=True)
    
    # Refrence the template file
    template = env.get_template('template.yaml.j2')

    # open file to write the compiled template
    config_file = open("./sam-assets/template.yaml", "w+")
    
    # write to the file
    config_file.write(template.render(list = [get_formated_data()]))


if __name__ == "__main__":
    compile()