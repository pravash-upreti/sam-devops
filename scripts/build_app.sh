#! /bin/sh

# get frontend credentials from vault server
curl --header "X-Vault-Token:$VAULT_TOKEN" $VAULT_SERVER/v1/$KV_ENGINE_NAME/data/$VAULT_SECRET_DIR/$STAGE/app | \
    
    # convert the response to json 
    jq .data.data | \
    
    # convert the json string to key value and store the key value to .env file which is used during app build process
    jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" > $WSD/$APP_DIR/.env

cat $WSD/$APP_DIR/.env

# go to app directory
cd $WSD/$APP_DIR

# install the packages
yarn

# build the src
yarn build