#! /bin/sh

# move devops assets package json to new build dir

echo curl --header "X-Vault-Token:$VAULT_TOKEN" $VAULT_SERVER/v1/secret/$VAULT_SECRET_DIR/$STAGE/app
curl --header "X-Vault-Token:$VAULT_TOKEN" $VAULT_SERVER/v1/secret/$VAULT_SECRET_DIR/$STAGE/app | jq .data | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" > $WSD/$APP_DIR/.env

# rm -rf build_app
# mkdir -p build_app

# cd $WSD/$APP_DIR
# npm install
# npm run build