#! /bin/sh

# move devops assets package json to new build dir
rm -rf build
mkdir -p build

cd $WSD/$API_DIR

# install dependency
yarn

# install dependency for aws-serverless-express
yarn add binary-case@1.0.0 
yarn add type-is@1.6.16 

# build the api
yarn build

# copy the dist folder to build folder inside devops 
cp -rp dist/ $WSD/devops/build/dist/
mkdir -p $WSD/devops/build/node_modules
cp -rfp node_modules/* $WSD/devops/build/node_modules/ 
cp -rp .env.example $WSD/devops/build/.env || echo "Could not find  .env.example"
cp -rp .babelrc $WSD/devops/build/ || echo "Couldnot find babelrc"
cp -rp public/ $WSD/devops/build/public || echo "Couldnot find public  folder"
cp -rp package.json $WSD/devops/build/ || echo "Couldnot find package.json  folder"

# copy require file from sam-assets folder
cd $WSD/devops/

cp -p sam-assets/lambda.js build/lambda.js
cp -p sam-assets/app.js build/app.js
cp -p sam-assets/aws-serverless-express.js build/aws-serverless-express.js

# substitute the value
sed -i 's#APP_MODULE_DIR#'${APP_MODULE_DIR:="dist/app"}'#g' ./build/app.js