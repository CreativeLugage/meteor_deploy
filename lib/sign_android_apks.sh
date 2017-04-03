sign_android_apks()
{
	read -r -p "Sign the Android APK files? [(Y)es/(N)o/(Q)uit] " input_sign

	case $input_sign in
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
			# echo "Skipping signing the Android APK Files!"
			# echo ""

			meteor_deploy
		;;

		[qQ][uU][iI][tT]|[qQ])
			exit 1
		;;

	    *)
			echo "Invalid input..."
			sign_android_apks
		;;
	esac

	echo ""
	echo ""
}

sign_android_apks