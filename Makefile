include Makefile.settings
#! /bin/sh

# working space directory is outside the devops folder

export WSD=${PWD}/../

.PHONY: build

# pipeline is complete frontend backend deployment job

pipeline:
	${INFO} "Running pipeline ..."
	
	# build stage
	@ make build_api
	@ make build_app
	
	# deploy stage
	@ make post_build
	@ make compile_template
	@ make deploy_api env="${CI_COMMIT_REF_SLUG}"
	@ make deploy_app env="${CI_COMMIT_REF_SLUG}"
	
	${INFO} "Completed CI/CD"

build_api:
	${INFO} "Building Backend ..."
	@ . ./scripts/build_api.sh
	${INFO} "Backend build completed"

build_app:
	${INFO} "Building Frontend..."
	@ . ./scripts/build_app.sh
	${INFO} "Frontend build completed"


compile_template:
	${INFO} "Compiling template"
	@ python ./scripts/compile.py
	${INFO} "Cloudformation template created"

post_build:
	${INFO} "Uploading to s3"
	@ . ./scripts/post_build.sh 
	${INFO} "Function uploaded to s3"

deploy_api:
	${INFO} "Deploying backend"
	@ . ./scripts/deploy.sh ${env}
	${INFO} "Backend deployment completed"


deploy_app:
	${INFO} "Deploying frontend"
	@ . ./scripts/deployapp.sh ${env}
	${INFO} "Frontend deployment completed"