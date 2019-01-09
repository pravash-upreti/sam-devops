'use strict'
const awsServerlessExpress = require(process.env.NODE_ENV === 'test' ? '../../index' : 'aws-serverless-express')
const app = require('app')

// NOTE: If you get ERR_CONTENT_DECODING_FAILED in your browser, this is likely
// due to a compressed response (e.g. gzip) which has not been handled correctly
// by aws-serverless-express and/or API Gateway. Add the necessary MIME types to
// binaryMimeTypes below, then redeploy (`npm run package-deploy`)
const binaryMimeTypes = [
  'application/javascript',
  'application/json',
  'application/octet-stream',
  'application/xml',
  'font/eot',
  'font/opentype',
  'font/otf',
  'image/jpeg',
  'image/png',
  'image/svg+xml',
  'text/comma-separated-values',
  'text/css',
  'text/html',
  'text/javascript',
  'text/plain',
  'text/text',
  'text/xml'
]

const server = awsServerlessExpress.createServer(app, null, binaryMimeTypes)

exports.handler = (event, context) => {

  try {
    if(!event)
      console.log("Invalid event")
    console.log(event.resource)
    var removePath = event.resource.split('/{proxy+}')[0]  
    event.resource = event.resource.replace(removePath,'')  
    event.path =   event.path.replace(removePath,'')
    
    event.requestContext.resourcePath = event.requestContext.resourcePath.replace(removePath,'')
    event.requestContext.path =   event.requestContext.path.replace(removePath,'')
  }
  catch(err) {
    console.log(err)
  }
  awsServerlessExpress.proxy(server, event, context)
}
