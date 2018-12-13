#  use following command to check the code locally
# docker run -v $PWD/tmp:/home/sbx_user1051 -v $PWD/build:/var/task lambdanode lambda.handler

FROM lambci/lambda:nodejs8.10
WORKDIR /var/task
COPY build/ /var/task/
# use node to detail logging else run above commented line for final result
ENTRYPOINT [ "node","lambda.js" ]
