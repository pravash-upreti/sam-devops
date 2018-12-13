include Makefile.settings
#! /bin/sh
export WSD=${PWD}../

pipeline:
	${INFO} "Running pipeline ..."
	${INFO} "Base directory ${WSD} "
	@ make build
	@ make invokeWithoutAWSLayer
	@ make invokeFunctionBlackBox	
	@ make compileTemplate
	@ make postbuild
	@ make deploy/api env=dev
	${INFO} "Completed CI/CD"

build:
	${INFO} "Building ..."
	@ . ./scripts/build.sh
	${INFO} "Completed"
	

compileTemplate:
	${INFO} "Compiling template"
	@ python ./scripts/compile.py
	${INFO} "Completed"

postbuild:
	${INFO} "Making SAM compatible and uploading to s3 using deployer"
	@ . ./scripts/postbuild.sh 
	${INFO} "Completed"

invokeFunctionBlackBox:
	${INFO} "Black Box function invocation"
	@ docker run -v "${PWD}/tmp:/home/sbx_user1051" -v "${PWD}/build:/var/task" lambci/lambda:nodejs8.10 lambda.handler
	${INFO} "Completed"

invokeWithoutAWSLayer:
	${INFO} "Invoke without AWS Layer"
	@ docker build -t lambdanodewithoutawslayer:latest .
	@ docker run -v ${PWD}/tmp:/home/sbx_user1051  lambdanodewithoutawslayer
	${INFO} "Completed"


deploy:
	${INFO} "Deploying to environment"
	@ . ./scripts/deploy.sh ${env}
	${INFO} "Deploy completed"