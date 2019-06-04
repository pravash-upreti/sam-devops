# SAMOps (Serverless Application Module Operation)

SAMOps is a shell script to deploy the frontend and backend in AWS Serverless stack. It support react app as frontend and express app as backend.

## Installation

`SAMOps` requires `curl` and `git` installed.

```
if [ "$SAMOPS_VERSION" != "" ] | [ "$SAMOPS_VERSION" != null ]
    then
        echo "Downloading the ${SAMOPS_VERSION}"
        
        # preparing the url to download the required version
        github_release_code_url="${SAMOPS_VERSION/.git//zip/$SAMOPS_VERSION}"
        
        # download the specified version of samops code and save as devops.zip file
        curl  "${github_release_code_url/github/codeload.github}" > devops.zip  

        # make temp directory _devops
        mkdir -p _devops

        # unzip devops.zip to _devops directory
        unzip devops.zip -d _devops 

        # move script to root directory inside devops folder
        cd _devops/* && cp -rfp . ../../devops && cd ../../ 

        # remove the unnecessary file and directory
        rm -rf _devops devops.zip

    else
        echo "Downloading the default branch"

        # clone the repo to _devops folder
        git clone ${SAMOPS_REPO} ./_devops

        # remove .git folder
        rm -rf ./_devops/.git/*

        # move script to root directory inside devops folder
        cp -rfp _devops/. devops && rm -rf _devops/
    fi
```

## Usage

### Build Frontend

> Note that front end is in `app` directory.

```
$ make build_app
```


### Deploy Frontend

> Note that front end is in `app` directory.

```
$ make deploy_app env=$STAGE
```


### Build Backend

> Note that front end is in `api` directory.

```
$ make build_api
```


### Deploy Backend

> Note that front end is in `api` directory.

```
# upload function to s3
$ make post_build

# compile cloudformation yaml template
$ make compile_template

# deploy the function using aws-cli
$ make deploy env=$STAGE
```
