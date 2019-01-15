#! /bin/sh

# parameter=$(curl --header "X-Vault-Token:$VAULT_TOKEN" $VAULT_SERVER/v1/secret/$VAULT_SECRET_DIR  \
#     | jq .data \
#     | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" \
#     | tr '\r\n' ' ' )

cd $WSD/$APP_DIR
aws s3 sync build/ s3://$S3_WEBSITE_BUCKET_NAME/$1/$MICRO_SERVICE_NAME/

# Only use this command for cached content 
# aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID \
#   --paths "/$MICRO_SERVICE_NAME/*"

# parameter=$(python scripts/inliner.py \
#     | jq .\
#     | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" \
#     | tr '\r\n' ' ')

# aws cloudformation deploy --template-file sam-assets/template.yaml --parameter-overrides RDSState="$RDS_STATE" BaseStack="$STACK_NAME" RDSSecurityGroup="$RDS_SECURITY_GROUP"  $parameter --stack-name $STACK_NAME-$1-$MICRO_SERVICE_NAME

# echo "Deploying the resources to default stage of"
# aws apigateway create-deployment --rest-api-id  $(aws cloudformation  describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`RestApiId`].OutputValue' --output text) --stage-name default --description 'Deployment to default stage'
