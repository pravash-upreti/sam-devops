#! /bin/sh

# change directory to app folder
cd $WSD/$APP_DIR

# log the s3 bucket name 
echo "deploying to bucket $S3_WEBSITE_BUCKET_NAME-$1"

# copy the build artifacts to respective service folder
aws s3 sync build/ s3://$S3_WEBSITE_BUCKET_NAME-$1/$MICRO_SERVICE_NAME/
