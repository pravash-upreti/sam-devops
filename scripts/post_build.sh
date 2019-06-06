#! /bin/sh

# clear broken symblink from the node modules folder
find ./build/node_modules -type l -exec sh -c 'for x; do [ -e "$x" ] || rm "$x"; done' _ {} +

# log timestamp to function_name file
TIMESTAMP=$(date +"%Y%m%d%H%M")
echo $TIMESTAMP > function_name

# zip the build folder 
cd build  && zip -r $TIMESTAMP.zip *

# move the zip file to working directory
mv $TIMESTAMP.zip ../ && cd ../

# copy the zip file to s3 bucket
aws s3 cp $TIMESTAMP.zip s3://$S3_BUCKET_NAME/
