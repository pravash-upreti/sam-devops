#! /bin/sh

# move devops assets package json to new build dir
rm -rf build
rm -rf sam-build
mkdir -p build
mkdir -p sam-build

cp sam-assets/package.json sam-build
cd sam-build && npm install 

cd ../../$1
npm install 
npm run build

cp -rp dist/ ../devops/build/dist/
mkdir -p ../devops/build/node_modules
cp -rfp node_modules/* ../devops/build/node_modules/ 
cp -rp .env.example ../devops/build/.env || echo "Could not find  .env.example"
cp -rp .babelrc ../devops/build/ || echo "Couldnot find babelrc"
cp -rp public/ ../devops/build/public || echo "Couldnot find public  folder"
cp -rp package.json ../devops/build/ || echo "Couldnot find package.json  folder"

# deploy to aws using SAM cli
cd ../devops/

cp -p sam-assets/lambda.js build/lambda.js
# cp -p sam-assets/app.js build/app.js
cp -p sam-assets/test.js build/test.js
cp -p sam-assets/simple-proxy-api.yaml build/simple-proxy-api.yaml

sed -i 's#PROXY_API_REGION#'$AWS_DEFAULT_REGION'#g' build/simple-proxy-api.yaml

# do not override the original content
cp -rnp ./sam-build/node_modules/* ./build/node_modules
