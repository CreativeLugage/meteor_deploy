deploy_remote_bundle()
{
	read -r -p "Deploy application bundle? [Y/n/q] " input_deploy_remote

	case $input_deploy_remote in
	    [yY][eE][sS]|[yY])
			echo "Deploying the application bundle..."

			if [ -z ${METEOR_DEPLOY_APP_BUNDLE_FILE_NAME+x} ]; then
				echo ""
				echo "Input the bundle file name WITHOUT the extension (and press Enter): "
				read METEOR_DEPLOY_APP_BUNDLE_FILE_NAME
			fi


			if [ -z ${METEOR_DEPLOY_SERVER_ADDRESS+x} ]; then
				echo ""
				echo "Input the remote server address (and press Enter): "
				read METEOR_DEPLOY_SERVER_ADDRESS
			fi

			if [ -z ${METEOR_DEPLOY_SERVER_PASSWORD+x} ]; then
				echo ""
				echo "Input the remote server password (and press Enter): "
				read -s METEOR_DEPLOY_SERVER_PASSWORD
			fi

			if [ -z ${METEOR_DEPLOY_SERVER_DESTINATION_FOLDER+x} ]; then
				echo ""
				echo "Input the full destination path on the remote server (and press Enter): "
				read METEOR_DEPLOY_SERVER_DESTINATION_FOLDER
			fi


			# SSH to the server
			sshpass -p ${METEOR_DEPLOY_SERVER_PASSWORD} ssh root@${METEOR_DEPLOY_SERVER_ADDRESS} bash -c "'
				
				# Unpack bundled app
				echo \"Unpacking the bundle...\"
				cd ${METEOR_DEPLOY_SERVER_DESTINATION_FOLDER}
				tar -zxf ${METEOR_DEPLOY_APP_BUNDLE_FILE_NAME}
				
				# Install NODE dependencies
				echo \"Installing NODE dependencies...\"
				cd bundle/programs/server/
				npm install
				cd ../../../
				
				# Restart NGINX
				echo \"Restarting NGINX...\"
				service nginx restart

			'"

			echo "Done!"
		;;

	    [nN][oO]|[nN])
			echo "Deployment canceled!"
			echo ""
			meteor_deploy
		;;

		[qQ][uU][iI][tT]|[qQ])
			exit 1
		;;

	    *)
			echo "Invalid input..."
			deploy_remote_bundle
		;;
	esac
}

deploy_remote_bundle