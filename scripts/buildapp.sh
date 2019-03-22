#! /bin/sh

# move devops assets package json to new build dir

echo  "X-Vault-Token:$VAULT_TOKEN" $VAULT_SERVER/v1/$KV_ENGINE_NAME/data/$VAULT_SECRET_DIR/$STAGE/app 
curl --header "X-Vault-Token:$VAULT_TOKEN" $VAULT_SERVER/v1/vyaguta/data/$VAULT_SECRET_DIR/$STAGE/app | jq .data | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" > $WSD/$APP_DIR/.env

# rm -rf build_app
# mkdir -p build_app

cd $WSD/$APP_DIR
yarn
yarn build