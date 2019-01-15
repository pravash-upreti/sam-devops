#! /bin/sh

# clear broken symblink
find ./build/node_modules -type l -exec sh -c 'for x; do [ -e "$x" ] || rm "$x"; done' _ {} +

TIMESTAMP=$(date +"%Y%m%d%H%M")
echo $TIMESTAMP > function_name
cd build 
zip -r $TIMESTAMP.zip *
mv $TIMESTAMP.zip ../
cd ../
aws s3 cp $TIMESTAMP.zip s3://$S3_BUCKET_NAME/
#sam package --template-file sam-assets/template.yaml --output-template-file build/serverless-output.yaml --s3-bucket $S3_BUCKET_NAME
