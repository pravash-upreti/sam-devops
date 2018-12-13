#! /bin/sh

# clear broken symblink
find ./build/node_modules -type l -exec sh -c 'for x; do [ -e "$x" ] || rm "$x"; done' _ {} +

sam package --template-file sam-assets/template.yaml --output-template-file build/serverless-output.yaml --s3-bucket $S3_BUCKET_NAME
