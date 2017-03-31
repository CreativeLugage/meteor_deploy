read -r -p "Build a new application bundle from source? [Y/n] " input

case $input in
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

		read -r -p "Sign the Android APK files? [Y/n] " input

		case $input in
		    [yY][eE][sS]|[yY])
				echo "Signing the Android APK Files..."

				if [ -z ${METEOR_DEPLOY_APP_NAME+x} ]; then
					echo ""
					echo "Input application name (and press Enter): "
					read METEOR_DEPLOY_APP_NAME
				fi

				if [ -z ${METEOR_DEPLOY_KEYSTORE_FILE+x} ]; then
					echo ""
					echo "Input full keystore file path (and press Enter): "
					read METEOR_DEPLOY_KEYSTORE_FILE
				fi

				if [ -z ${METEOR_DEPLOY_KEYSTORE_PASSWORD+x} ]; then
					echo ""
					echo "Input keystore password (and press Enter): "
					read -s METEOR_DEPLOY_KEYSTORE_PASSWORD
				fi
				
				# Sign the APK files for Android
				cd ${METEOR_DEPLOY_APP_DESTINATION_FOLDER}/android/project/build/outputs/apk/
				
				jarsigner -keystore ${METEOR_DEPLOY_KEYSTORE_FILE} -storepass ${METEOR_DEPLOY_KEYSTORE_PASSWORD} android-armv7-release-unsigned.apk ${METEOR_DEPLOY_APP_NAME}
				jarsigner -keystore ${METEOR_DEPLOY_KEYSTORE_FILE} -storepass ${METEOR_DEPLOY_KEYSTORE_PASSWORD} android-x86-release-unsigned.apk ${METEOR_DEPLOY_APP_NAME}
				
				echo "Done!"

			;;

		    [nN][oO]|[nN])
				echo "Skipping signing the Android APK Files!"
			;;

		    *)
				echo "Invalid input..."
				exit 1
			;;
		esac

		echo ""
		echo ""

	;;

    [nN][oO]|[nN])
		echo "Skiping building a new application bundle! Using existing bundled version."
	;;

    *)
		echo "Invalid input..."
		exit 1
	;;
esac

echo ""
echo ""