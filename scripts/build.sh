#! /bin/sh

# move devops assets package json to new build dir
rm -rf build
rm -rf sam-build
mkdir -p build
mkdir -p sam-build

cp sam-assets/package.json sam-build
cd sam-build && npm install 

cd $WSD/$API_DIR
npm install 
npm run build

cp -rp dist/ $WSD/devops/build/dist/
echo "Changed to $PWD"
mkdir -p $WSD/devops/build/node_modules
cp -rfp node_modules/* $WSD/devops/build/node_modules/ 
cp -rp .env.example $WSD/devops/build/.env || echo "Could not find  .env.example"
cp -rp .babelrc $WSD/devops/build/ || echo "Couldnot find babelrc"
cp -rp public/ $WSD/devops/build/public || echo "Couldnot find public  folder"
cp -rp package.json $WSD/devops/build/ || echo "Couldnot find package.json  folder"

# deploy to aws using SAM cli
cd $WSD/devops/

cp -p sam-assets/lambda.js build/lambda.js
cp -p sam-assets/app.js build/app.js

#substitute the value
sed -i 's#APP_MODULE_DIR#'${APP_MODULE_DIR:="dist/app"}'#g' ./build/app.js

# cp -p sam-assets/app.js build/app.js
cp -p sam-assets/test.js build/test.js
cp -p sam-assets/simple-proxy-api.yaml build/simple-proxy-api.yaml

# do not override the original content
# -rpn not supported in alpine
cp -rpn ./sam-build/node_modules/* ./build/node_modules
