#!/bin/bash

# Configuration file used to deploy a Meteor application from source
# Duplicate the file inside the "./configs/" folder and change the settings in order to use for your own app

# Deployment config for: My App

export METEOR_DEPLOY_APP_SOURCE_FOLDER="/full/path/to/source"   # local machine
export METEOR_DEPLOY_APP_DESTINATION_FOLDER="/full/path/to/destination"   # local machine
export METEOR_DEPLOY_SERVER_NAME="https://live.servername.com"  # URL for the deployed application

export METEOR_DEPLOY_APP_BUNDLE_FILE_NAME="bundled_app.tar.gz"    # file name for the .tar.gs bundle

export METEOR_DEPLOY_APP_NAME="my-app-name"
export METEOR_DEPLOY_KEYSTORE_FILE="my-app-name.keystore"
export METEOR_DEPLOY_KEYSTORE_PASSWORD="MyKeystorePassword"

export METEOR_DEPLOY_SERVER_ADDRESS="xx.xx.xx.xx"   # address to access via SSH (remote server)
export METEOR_DEPLOY_SERVER_PASSWORD="MyRemoteServerPassword"   # remote server SSH password
export METEOR_DEPLOY_SERVER_DESTINATION_FOLDER="/full/remote/server/destination"    # Destination folder path on the REMOTE server
