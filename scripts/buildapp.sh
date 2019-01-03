#! /bin/sh

# move devops assets package json to new build dir
rm -rf build_app
mkdir -p build_app

cd $WSD/$APP_DIR
npm install
npm run build