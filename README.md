# meteor_deploy
Bash script for easy Meteor.js deployment to remote server (Ubuntu with NGINX, Passenger) over SSH; needs remote server already configured

# Install remote server dependencies

You can use the tutorial below to install and configure MongoDB, Nginx and Passenger on the remote server

You can skip the building, uploading and deploying the Meteor application (the script will take care of those for you), but the article will teach you how to set up your server in order to run your Meteor application.

[Deploying a Meteor app on a Linux/Unix production server](https://www.phusionpassenger.com/library/walkthroughs/deploy/meteor/ownserver/nginx/oss/xenial/deploy_app.html#preparing-the-app-s-environment)