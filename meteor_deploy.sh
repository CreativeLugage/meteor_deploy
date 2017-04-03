#!/bin/bash

# STEPS:
# 
# 1.1 Ask for configuration file (see configuration file example)
# 1.2 If configuration file not used, ask for parameters
# 2. Build application bundle
# 3. Sign Android APK files
# 4. Upload new application bungle to remote server
# 5. Deploy uploaded bundle on remote server (using nginx/passenger on Ubuntu)

echo ""
echo ""
echo "Deploy your Meteor application to a remote server"
echo ""
echo ""

# Get the current folder path (full)
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

# Make all lib scripts executable
chmod +x -R ${SCRIPTPATH}/lib/*.sh

# Install local system dependencies
# 
# sudo apt-get update
# sudo apt-get install jarsigner sshpass rsync
# 
source "${SCRIPTPATH}/lib/install_local_dependencies.sh"

# Load configuration file
source "${SCRIPTPATH}/lib/load_config_file.sh"

# Build new app bundle
source "${SCRIPTPATH}/lib/build_new_bundle.sh"

# Upload app bundle to remote server
source "${SCRIPTPATH}/lib/upload_application_bundle.sh"

# Install remote system dependencies
# 
# 
# 
# source "${SCRIPTPATH}/lib/install_remote_dependencies.sh"

# Deploy app bundle on remote server
source "${SCRIPTPATH}/lib/deploy_remote_bundle.sh"

# END