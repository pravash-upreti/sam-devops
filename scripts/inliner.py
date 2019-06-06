import os
import requests
import json

from requests.exceptions import HTTPError


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

def get_inline():

    """ Return the inline key value by removing the underscore from key """

    data = get_vault_data()

    formated_data = {}
    
    # remove underscore from the key of json 
    for key in data:
        components = key.split('_')
        formated_data.update({
            components[0] + ''.join(x.title() for x in components[1:]) : data.get(key)
        })
    
    return formated_data

if __name__ == "__main__":
    print json.dumps(get_inline())