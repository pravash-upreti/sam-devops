include Makefile.settings
#! /bin/sh
export WSD=${PWD}/../


if [  $CI_COMMIT_REF_SLUG == "dev" ]
then
   export STAGE=dev
if [  $CI_COMMIT_REF_SLUG == "uat" ]
then
   export STAGE=uat
if [  $CI_COMMIT_REF_SLUG == "qa" ]
then
   export STAGE=qa
if [  $CI_COMMIT_REF_SLUG == "release" ]
then
   export STAGE=staging
if [  $CI_COMMIT_REF_SLUG == "master" ]
then
   export STAGE=prod
else
   echo "Undefine stage"
fi

.PHONY: build

pipeline:
	${INFO} "Running pipeline ..."
	${INFO} "Base directory ${WSD} "	
	@ make buildapi
	@ make buildapp
	@ make invokeWithoutAWSLayer
	@ make invokeFunctionBlackBox
	@ make postbuild
	@ make compileTemplate
	@ make deploy env="${CI_COMMIT_REF_SLUG}"
	@ make deployapp env="${CI_COMMIT_REF_SLUG}"
	${INFO} "Completed CI/CD"

buildapi:
	${INFO} "Building ..."
	@ . ./scripts/buildapi.sh
	${INFO} "Completed"

buildapp:
	${INFO} "Building ..."
	@ . ./scripts/buildapp.sh
	${INFO} "Completed"


compileTemplate:
	${INFO} "Compiling template"
	@ python ./scripts/compile.py
	@ cat sam-assets/template.yaml
	${INFO} "Completed"

postbuild:
	${INFO} "Making SAM compatible and uploading to s3 using deployer"
	@ . ./scripts/postbuild.sh 
	${INFO} "Completed"

invokeFunctionBlackBox:
	${INFO} "Black Box function invocation"
	@ docker run -v "${PWD}/tmp:/home/sbx_user1051" -v "${PWD}/build:/var/task" -e LOG_DIR='/tmp' -e BABEL_CACHE_PATH='/tmp/mycache.json' lambci/lambda:nodejs8.10 lambda.handler
	${INFO} "Completed"

invokeWithoutAWSLayer:
	${INFO} "Invoke without AWS Layer"
	@ docker build -t lambdanodewithoutawslayer:latest .
	@ docker run -v ${PWD}/tmp:/home/sbx_user1051  -e LOG_DIR='/tmp' -e BABEL_CACHE_PATH='/tmp/mycache.json' lambdanodewithoutawslayer
	${INFO} "Completed"


deploy:
	${INFO} "Deploying to environment"
	@ . ./scripts/deploy.sh ${env}
	${INFO} "Deploy completed"


deployapp:
	${INFO} "Deploying to environment"
	@ . ./scripts/deployapp.sh ${env}
	${INFO} "Deploy completed"