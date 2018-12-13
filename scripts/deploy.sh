#! /bin/sh

# parameter=$(curl --header "X-Vault-Token:$VAULT_TOKEN" $VAULT_SERVER/v1/secret/$VAULT_SECRET_DIR  \
#     | jq .data \
#     | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" \
#     | tr '\r\n' ' ' )

parameter=$(python scripts/inliner.py \
    | jq .\
    | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" \
    | tr '\r\n' ' ')

sam deploy --template-file build/serverless-output.yaml --parameter-overrides RDSState="$RDS_STATE" BaseStack="$STACK_NAME" RDSSecurityGroup="$RDS_SECURITY_GROUP"  $parameter --stack-name $STACK_NAME-$1