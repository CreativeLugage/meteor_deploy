load_config_file()
{
	read -r -p "Use a bash configuration file? [Y/n/q] " input_config

	case $input_config in
	    [yY][eE][sS]|[yY])
			
			echo "Input full path to .sh configuration file (and press Enter): "
			read BASH_CONFIG_FILE
			source ${BASH_CONFIG_FILE}

		;;

	    [nN][oO]|[nN])
			echo "Skipping configuration file! Add the required parameters manually!"
			echo ""
		;;

		[qQ][uU][iI][tT]|[qQ])
			exit 1
		;;

	    *)
			echo "Invalid input..."
			load_config_file
		;;
	esac

	echo ""
	echo ""

}

load_config_file