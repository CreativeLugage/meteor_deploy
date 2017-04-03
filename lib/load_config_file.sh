load_config_file()
{
	read -r -p "Use a bash configuration file? [Y/n/q] " input_config

	case $input_config in
	    [yY][eE][sS]|[yY])
			
			# echo "Input full path to .sh configuration file (and press Enter): "
			# read BASH_CONFIG_FILE
			# source ${BASH_CONFIG_FILE}

			## Collect the files in the array $files
			files=( ${SCRIPTPATH}/configs/*.sh )
			## Enable extended globbing. This lets us use @(foo|bar) to
			## match either 'foo' or 'bar'.
			shopt -s extglob

			## Start building the string to match against.
			string="@(${files[0]}"
			## Add the rest of the files to the string
			for((i=1;i<${#files[@]};i++))
			do
			    string+="|${files[$i]}"
			done
			## Close the parenthesis. $string is now @(file1|file2|...|fileN)
			string+=
			string+=")"

			## Show the menu. This will list all files and the string "quit"
			select file in "${files[@]}" "manual" "skip"
			do
			    case $file in
				    ## If the choice is one of the files (if it matches $string)
				    $string)
				        source ${file}
				        break
			        ;;

				    "manual")
				        echo "Input full path to .sh configuration file (and press Enter): "
				        read BASH_CONFIG_FILE
				        source ${BASH_CONFIG_FILE}
				        break
				    ;;

				    "skip")
				        echo "Skipping configuration file! Add the required parameters manually!"
						echo ""
						break
					;;
				    
				    *)
				        file=""
				        echo "Please choose a number from 1 to $((${#files[@]}+1))"
			        ;;

			    esac
			done

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