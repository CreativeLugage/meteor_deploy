# meteor_deploy
Bash script for easy Meteor.js deployment to remote server (Ubuntu with NGINX, Passenger) over SSH; needs remote server already configured

# Install remote server dependencies

You can use the tutorial below to install and configure MongoDB, Nginx and Passenger on the remote server

You can skip the building, uploading and deploying the Meteor application (the script will take care of those for you), but the article will teach you how to set up your server in order to run your Meteor application.

[Deploying a Meteor app on a Linux/Unix production server](https://www.phusionpassenger.com/library/walkthroughs/deploy/meteor/ownserver/nginx/oss/xenial/deploy_app.html#preparing-the-app-s-environment)

I have extracted the relevant sections of the article below for convenience.

## Login to your server, create a user for the app

Login to your server with SSH:

	$ ssh adminuser@yourserver.com

Replace adminuser with the name of an account with administrator privileges or sudo privileges.
> Starting from this point, unless stated otherwise, all commands that we instruct you to run should be run on the server, not on your local computer!

Now that you have logged in, you should create an operating system user account for your app. For security reasons, it is a good idea to run each app under its own user account, in order to limit the damage that security vulnerabilities in the app can do. Passenger will automatically run your app under this user account as part of its [user account sandboxing feature](https://www.phusionpassenger.com/library/deploy/nginx/user_sandboxing.html).

You should give the user account the same name as your app. But for demonstration purposes, this tutorial names the user account myappuser.

	$ sudo adduser myappuser

We also ensure that that user has your SSH key installed:

	$ sudo mkdir -p ~myappuser/.ssh
	$ touch $HOME/.ssh/authorized_keys
	$ sudo sh -c "cat $HOME/.ssh/authorized_keys >> ~myappuser/.ssh/authorized_keys"
	$ sudo chown -R myappuser: ~myappuser/.ssh
	$ sudo chmod 700 ~myappuser/.ssh
	$ sudo sh -c "chmod 600 ~myappuser/.ssh/*"

## Install Node.js

Run the following commands to install Node.js from the NodeSource APT repository. With these commands, we also install a compiler so that we are able to install native addons from npm.

	$ sudo apt-get update
	$ sudo apt-get install -y curl apt-transport-https ca-certificates && curl --fail -ssL -o setup-nodejs https://deb.nodesource.com/setup_4.x && sudo bash setup-nodejs && sudo apt-get install -y nodejs build-essential

## Install Passenger packages

These commands will install Passenger + Nginx through Phusion's APT repository. If you already had Nginx installed, then these commands will upgrade Nginx to Phusion's version (with Passenger compiled in).

	# Install our PGP key and add HTTPS support for APT
	$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
	$ sudo apt-get install -y apt-transport-https ca-certificates

	# Add our APT repository
	$ sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
	$ sudo apt-get update

	# Install Passenger + Nginx
	$ sudo apt-get install -y nginx-extras passenger

### Enable the Passenger Nginx module and restart Nginx

Edit /etc/nginx/nginx.conf and uncomment include /etc/nginx/passenger.conf;. For example, you may see this:

	# include /etc/nginx/passenger.conf;

Remove the '#' characters, like this:

	include /etc/nginx/passenger.conf;

If you don't see a commented version of include /etc/nginx/passenger.conf; inside nginx.conf, then you need to insert it yourself. Insert it into /etc/nginx/nginx.conf inside the http block. For example:

 	...
 
 	http {
 	    include /etc/nginx/passenger.conf;
     		...
	 }

When you are finished with this step, restart Nginx:

	$ sudo service nginx restart

### Check instalation

After installation, please validate the install by running sudo /usr/bin/passenger-config validate-install. For example:

	sudo /usr/bin/passenger-config validate-install
	 * Checking whether this Phusion Passenger install is in PATH... ✓
	 * Checking whether there are no other Phusion Passenger installations... ✓

All checks should pass. If any of the checks do not pass, please follow the suggestions on screen.

Finally, check whether Nginx has started the Passenger core processes. Run sudo /usr/sbin/passenger-memory-stats. You should see Nginx processes as well as Passenger processes. For example: 

	$ sudo /usr/sbin/passenger-memory-stats
	Version: 5.0.8
	Date   : 2015-05-28 08:46:20 +0200
	...

	---------- Nginx processes ----------
	PID    PPID   VMSize   Private  Name
	-------------------------------------
	12443  4814   60.8 MB  0.2 MB   nginx: master process /usr/sbin/nginx
	12538  12443  64.9 MB  5.0 MB   nginx: worker process
	### Processes: 3
	### Total private dirty RSS: 5.56 MB

	----- Passenger processes ------
	PID    VMSize    Private   Name
	--------------------------------
	12517  83.2 MB   0.6 MB    PassengerAgent watchdog
	12520  266.0 MB  3.4 MB    PassengerAgent server
	12531  149.5 MB  1.4 MB    PassengerAgent logger
	...

### Update regularly

Nginx updates, Passenger updates and system updates are delivered through the APT package manager regularly. You should run the following command regularly to keep them up to date:

	$ sudo apt-get update
	$ sudo apt-get upgrade

You do not need to restart Nginx or Passenger after an update, and you also do not need to modify any configuration files after an update. That is all taken care of automatically for you by APT. 

## Install MongoDB

During development, the Meteor runtime takes care of starting MongoDB for you. MongoDB is the database engine that Meteor uses. But a packaged Meteor app does not start MongoDB for you. Instead, a packaged Meteor app expects that MongoDB is already running somewhere, and that you tell the app where that MongoDB instance is.

You can install MongoDB from [www.mongodb.org](www.mongodb.org). While you can also install MongoDB via a package manager (apt-get), please note that this might be an outdated or even unsupported version.

>See also: mongoDB security checklist (notably the bindIp). 

## Configuring Nginx and Passenger

We need to create an Nginx configuration file and setup a virtual host entry that points to your app. This virtual host entry tells Nginx (and Passenger) where your app is located. 

	$ sudo nano /etc/nginx/sites-enabled/myapp.conf

Replace myapp with your app's name.

Put this inside the file: 

	server {
	    listen 80;
	    server_name yourserver.com;

	    # Tell Nginx and Passenger where your app's 'public' directory is
	    root /var/www/myapp/bundle/public;

	    # Turn on Passenger
	    passenger_enabled on;
	    # Tell Passenger that your app is a Meteor app
	    passenger_app_type node;
	    passenger_startup_file main.js;

	    # Tell your app where MongoDB is
	    passenger_env_var MONGO_URL mongodb://localhost:27017/myappdb;
	    # Tell your app what its root URL is
	    passenger_env_var ROOT_URL http://yourserver.com;
	}

Replace yourserver.com with your server's host name and replace /var/www/myapp/bundle with your application's package directory path. Replace myappdb with an appropriate MongoDB database name. Also be sure to set ROOT_URL to an appropriate value.

When you are done, restart Nginx:

	$ sudo service nginx restart

### Test drive

You should now be able to access your app through the server's host name! Try running this from your local computer. Replace yourserver.com with your server's hostname, exactly as it appears in the Nginx config file's server_name directive.

	$ curl http://yourserver.com/
	...your app's front page HTML...

If you do not see your app's front page HTML, then these are the most likely causes:

1. You did not correctly configure your server_name directive. The server_name must exactly match the host name in the URL. For example, if you use the command curl http://45.55.91.235/ to access your app, then the server_name must be 45.55.91.235.
2. You did not setup DNS records. Setting up DNS is outside the scope of this tutorial. In the mean time, we recommend that you use your server's IP address as the server name.