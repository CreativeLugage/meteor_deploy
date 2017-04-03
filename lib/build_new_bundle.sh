build_application_bundle()
{
	read -r -p "Build a new application bundle from source? [Y/n/q] " input_build

	case $input_build in
	    [yY][eE][sS]|[yY])
			echo "Building the new application bundle..."

			if [ -z ${METEOR_DEPLOY_APP_SOURCE_FOLDER+x} ]; then
				echo ""
				echo "Input full application source path (and press Enter): "
				read METEOR_DEPLOY_APP_SOURCE_FOLDER
			fi

			if [ -z ${METEOR_DEPLOY_APP_DESTINATION_FOLDER+x} ]; then
				echo ""
				echo "Input full destination path (and press Enter): "
				read METEOR_DEPLOY_APP_DESTINATION_FOLDER
			fi

			if [ -z ${METEOR_DEPLOY_SERVER_NAME+x} ]; then
				echo ""
				echo "Input server name with http:// or https:// (and press Enter): "
				read METEOR_DEPLOY_SERVER_NAME
			fi

			# Build the application for deployment
			cd ${METEOR_DEPLOY_APP_SOURCE_FOLDER}
			meteor build ${METEOR_DEPLOY_APP_DESTINATION_FOLDER} --server=${METEOR_DEPLOY_SERVER_NAME}
			
			echo "Done!"

		;;

	    [nN][oO]|[nN])
			echo "Skiping building a new application bundle! Using existing bundled version."
			echo ""
		;;

		[qQ][uU][iI][tT]|[qQ])
			exit 1
		;;

	    *)
			echo "Invalid input..."
			build_application_bundle
		;;
	esac

	echo ""
	echo ""
}

build_application_bundle