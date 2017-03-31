read -r -p "Use a bash configuration file? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
		
		echo "Input full path to .sh configuration file (and press Enter): "
		read BASH_CONFIG_FILE
		source ${BASH_CONFIG_FILE}

	;;

    [nN][oO]|[nN])
		echo "Skipping configuration file! Add the required parameters manually!"
	;;

    *)
		echo "Invalid input..."
		exit 1
	;;
esac

echo ""
echo ""