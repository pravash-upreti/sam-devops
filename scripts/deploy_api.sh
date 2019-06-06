#! /bin/sh

# get the parameter list to pass on cloudformation
parameter=$(python scripts/inliner.py \
    | jq .\
    | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" \
    | tr '\r\n' ' ')

# deploy the cloudformation template 
aws cloudformation deploy --template-file sam-assets/template.yaml --parameter-overrides RDSState="$RDS_STATE" BaseStack="$STACK_NAME" RDSSecurityGroup="$RDS_SECURITY_GROUP"  $parameter --stack-name $STACK_NAME-$1-$MICRO_SERVICE_NAME
STAGE=$1

# deploy the resources to default stage
echo "Deploying the resources to default stage"
aws apigateway create-deployment --rest-api-id  $(aws cloudformation  describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`RestApiId'$STAGE'`].OutputValue' --output text) --stage-name default --description 'Deployment to default stage'
