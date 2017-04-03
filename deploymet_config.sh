#!/bin/bash

# Configuration file used to deploy a Meteor application from source
# Duplicate the file and change the settings in order to use for your own app
# Make sure the file can be executed as a program

# Deployment config for: My App

export METEOR_DEPLOY_APP_SOURCE_FOLDER="/fuul/path/to/source"
export METEOR_DEPLOY_APP_DESTINATION_FOLDER="/full/path/to/destination"
export METEOR_DEPLOY_SERVER_NAME="https://live.servername.com"

export METEOR_DEPLOY_APP_BUNDLE_FILE_NAME="bundled_app.tar.gz"

export METEOR_DEPLOY_APP_NAME="my-app-name"
export METEOR_DEPLOY_KEYSTORE_FILE="my-app-name.keystore"
export METEOR_DEPLOY_KEYSTORE_PASSWORD="MyKeystorePassword"

export METEOR_DEPLOY_SERVER_ADDRESS="xx.xx.xx.xx"
export METEOR_DEPLOY_SERVER_PASSWORD="MyRemoteServerPassword"
export METEOR_DEPLOY_SERVER_DESTINATION_FOLDER="/full/remote/server/destination"