upload_application_bundle()
{
	read -r -p "Upload application bundle to the remote server? [Y/n/q] " input

	case $input in
	    [yY][eE][sS]|[yY])
			echo "Uploading the application bundle..."

			if [ -z ${METEOR_DEPLOY_APP_DESTINATION_FOLDER+x} ]; then
				echo ""
				echo "Input full folder path for application bundle - just the folder path, NOT the bundled file (and press Enter): "
				read METEOR_DEPLOY_APP_DESTINATION_FOLDER
			fi

			if [ -z ${METEOR_DEPLOY_APP_BUNDLE_FILE_NAME+x} ]; then
				echo ""
				echo "Input the bundle file name WITH extension (and press Enter): "
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


			# Upload the server bundle
			sshpass -p ${METEOR_DEPLOY_SERVER_PASSWORD} rsync --verbose -h --progress ${METEOR_DEPLOY_APP_DESTINATION_FOLDER}/${METEOR_DEPLOY_APP_BUNDLE_FILE_NAME} root@${METEOR_DEPLOY_SERVER_ADDRESS}:${METEOR_DEPLOY_SERVER_DESTINATION_FOLDER}

			echo "Done!"

		;;

	    [nN][oO]|[nN])
			echo "Uploading application bundle canceled! Using previously uploaded bundle."
		;;

		[qQ][uU][iI][tT]|[qQ])
			exit 1
		;;

	    *)
			echo "Invalid input..."
			upload_application_bundle
		;;
	esac

	echo ""
	echo ""
}

upload_application_bundle