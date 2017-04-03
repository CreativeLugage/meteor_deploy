echo "Checking local dependencies..."

echo ""

# java:jarsigner, sshpass, rsync

if type -p java; then
	echo -e "java is already installed [OK]"
    # echo found java executable in PATH
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
	echo -e "java is already installed [OK]"
    # echo found java executable in JAVA_HOME     
    _java="$JAVA_HOME/bin/java"
else
	echo -e "java is NOT installed"
	echo -e "Installing java..."

	sudo apt-get install python-software-properties
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	# sudo apt-get install oracle-java8-installer
	sudo apt-get install oracle-java8-set-default
fi

if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo version "$version"
    if [[ "$version" > "1.7" ]]; then
        echo version is more than 1.7 "[OK]"
    else         
        echo version is less than 1.7
		echo -e "Updating java..."

		sudo apt-get install python-software-properties
		sudo add-apt-repository ppa:webupd8team/java
		sudo apt-get update
		# sudo apt-get install oracle-java8-installer
		sudo apt-get install oracle-java8-set-default
    fi
fi


if dpkg --get-selections | grep -q "^sshpass[[:space:]]*install$" >/dev/null; then
	echo -e "sshpass is already installed [OK]"
else
	echo -e "sshpass is NOT installed"
	echo -e "Installing sshpass..."

	sudo apt-get -qq install sshpass
    echo "Successfully installed sshpass"
fi



if dpkg --get-selections | grep -q "^rsync[[:space:]]*install$" >/dev/null; then
	echo -e "rsync is already installed [OK]"
else
	echo -e "rsync is NOT installed"
	echo -e "Installing rsync..."

	sudo apt-get -qq install rsync
    echo "Successfully installed rsync"
fi

echo ""
echo ""